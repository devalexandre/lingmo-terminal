/**
 * New LingmoOS terminal
 * Copyright 2023 LingmoOS Team
 */
import QtQuick 2.12
import QtQml.Models 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12

import Lingmo.TermWidget 1.0
import LingmoUI.CompatibleModule 3.0 as LingmoUI

LingmoUI.Window {
    id: root
    minimumWidth: 400
    minimumHeight: 300
    width: settings.width
    height: settings.height
    title: currentItem && currentItem.terminal ? currentItem.terminal.session.title : ""

    GlobalSettings { id: settings }

    background.color: LingmoUI.Theme.darkMode ? settings.darkbackgroundColor : settings.lightbackgroundColor
    background.opacity: root.compositing ? settings.opacity : 1
//    background.opacity: rootWindow.compositing ? 0.95 : 1.0
    header.height: LingmoUI.Units.windowHeaderHeight

    property int currentIndex: -1
    property alias currentItem: _tabView.currentItem
    readonly property QMLTermWidget currentTerminal: currentItem ? currentItem.terminal : null

    // MenuBar {
    //     id: menuBar

    //     Menu {
    //         id: helpMenu
    //         title: qsTr("Help")

    //         MenuItem {
    //             text: qsTr("About Terminal")
    //             onTriggered: aboutDialog.show()
    //         }
    //     }
    // }

    // LingmoUI.AboutDialog {
    //     id: aboutDialog
    //     name: root.title
    //     description: qsTr("LingmoOS terminal simulator")
    //     iconSource: "image://icontheme/lingmo-terminal"
    // }

    ExitPromptDialog {
        id: exitPrompt

        property var index: -1

        onOkBtnClicked: {
            if (index != -1) {
                closeTab(index)
            } else {
                onOkBtnClicked: Qt.quit()
            }
        }
    }

    SettingsDialog {
        id: settingsDialog
    }

    LingmoUI.WindowBlur {
        view: root
        geometry: Qt.rect(root.x, root.y, root.width, root.height)
        windowRadius: root.background.radius
        enabled: settings.blur
    }

    onClosing: {
        if (!root.isMaximized && !root.isFullScreen) {
            settings.width = root.width
            settings.height = root.height
        }

        // Exit prompt.
        for (var i = 0; i < _tabView.contentModel.count; ++i) {
            var obj = _tabView.contentModel.get(i)
            if (obj.session.hasActiveProcess) {
                exitPrompt.index = -1
                exitPrompt.visible = true
                close.accepted = false
                break
            }
        }
    }

    // Tabs as pills in the window's header strip, next to the window buttons
    headerItem: Item {
        LingmoUI.PillTabBar {
            anchors.fill: parent
            anchors.topMargin: LingmoUI.Units.smallSpacing / 2
            anchors.bottomMargin: LingmoUI.Units.smallSpacing / 2
            model: _tabView.count
            textProvider: (index) => _tabView.contentModel.get(index) ? _tabView.contentModel.get(index).title : ""
            currentIndex: _tabView.currentIndex
            newTabTipText: qsTr("New Tab")

            onActivated: (index) => {
                _tabView.currentIndex = index
                _tabView.currentItem.forceActiveFocus()
            }
            onCloseRequested: (index) => root.closeProtection(index)
            onNewTabRequested: openNewTab()
        }
    }

    ColumnLayout {
        anchors.fill: parent

        LingmoUI.TabView {
            id: _tabView
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
    }

    Component.onCompleted: {
        openTab("$PWD")
    }

    function openNewTab() {
        if (_tabView.currentItem) {
            openTab(_tabView.currentItem.session.currentDir)
        } else {
            openTab("$HOME")
        }
    }

    function openTab(path) {
        if (_tabView.contentModel.count > 7)
            return

        const component = Qt.createComponent("Terminal.qml");
        if (component.status === Component.Ready) {
            const index = _tabView.contentModel.count
            const object = _tabView.addTab(component, {path: path})
            object.terminalClosed.connect(() => closeTab(index))
        }
    }

    function closeProtection(index) {
        var obj = _tabView.contentModel.get(index)
        if (obj.session.hasActiveProcess) {
            exitPrompt.index = index
            exitPrompt.visible = true
            return
        }

        closeTab(index)
    }

    function closeTab(index) {
        _tabView.closeTab(index)

        if (_tabView.contentModel.count === 0)
            Qt.quit()
    }

    function closeCurrentTab() {
        closeProtection(_tabView.currentIndex)
    }

    function toggleTab() {
        var nextIndex = _tabView.currentIndex
        ++nextIndex
        if (nextIndex > _tabView.contentModel.count - 1)
            nextIndex = 0

        _tabView.currentIndex = nextIndex
    }
}
