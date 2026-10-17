/**
 * New LingmoOS terminal
 * Copyright 2023 LingmoOS Team
 */
import QtQuick 2.12
import QtQml.Models 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import Qt5Compat.GraphicalEffects

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
        RowLayout {
            id: _tabRow
            anchors.fill: parent
            anchors.topMargin: LingmoUI.Units.smallSpacing / 2
            anchors.bottomMargin: LingmoUI.Units.smallSpacing / 2
            spacing: LingmoUI.Units.smallSpacing

            // Every tab gets the same width; long titles are elided
            readonly property real tabWidth: {
                var free = _tabRow.width - _newTabButton.width - _dragSpace.Layout.minimumWidth
                           - _tabRow.spacing * 2 - _tabbar.spacing * Math.max(0, _tabbar.count - 1)
                return Math.max(LingmoUI.Units.gridUnit * 4,
                                Math.min(LingmoUI.Units.gridUnit * 13, free / Math.max(1, _tabbar.count)))
            }

            ListView {
                id: _tabbar
                Layout.fillHeight: true
                Layout.preferredWidth: contentWidth
                Layout.maximumWidth: _tabRow.width - _newTabButton.width - _dragSpace.Layout.minimumWidth
                                     - _tabRow.spacing * 2
                orientation: ListView.Horizontal
                spacing: LingmoUI.Units.smallSpacing / 2
                boundsBehavior: Flickable.StopAtBounds
                clip: true
                model: _tabView.count
                currentIndex: _tabView.currentIndex
                highlightMoveDuration: LingmoUI.Units.shortDuration

                delegate: Item {
                    id: _tabBtn

                    required property int index
                    readonly property bool checked: _tabView.currentIndex === index
                    readonly property bool hovered: _tabMouse.containsMouse || _closeBtn.hovered
                    readonly property string title: _tabView.contentModel.get(index) ? _tabView.contentModel.get(index).title : ""

                    width: _tabRow.tabWidth
                    height: ListView.view.height

                    Accessible.role: Accessible.PageTab
                    Accessible.name: title

                    ToolTip.delay: 500
                    ToolTip.timeout: 5000
                    ToolTip.visible: _tabMouse.containsMouse
                    ToolTip.text: title

                    Rectangle {
                        id: _pill
                        anchors.fill: parent
                        anchors.topMargin: 3
                        anchors.bottomMargin: 3
                        radius: height / 2
                        color: _tabBtn.checked ? LingmoUI.Theme.highlightColor
                             : _tabMouse.pressed ? LingmoUI.Theme.pressedColor
                             : _tabBtn.hovered ? LingmoUI.Theme.hoverColor
                             : "transparent"
                        border.width: _tabBtn.checked ? 0 : 1
                        border.color: LingmoUI.Theme.borderColor
                        scale: _tabMouse.pressed ? 0.97 : 1.0

                        Behavior on color { ColorAnimation { duration: LingmoUI.Units.shortDuration; easing.type: LingmoUI.Units.easing } }
                        Behavior on scale { NumberAnimation { duration: LingmoUI.Units.veryShortDuration; easing.type: LingmoUI.Units.easing } }
                    }

                    MouseArea {
                        id: _tabMouse
                        anchors.fill: parent
                        hoverEnabled: true
                        acceptedButtons: Qt.LeftButton

                        onClicked: {
                            _tabView.currentIndex = index
                            _tabView.currentItem.forceActiveFocus()
                        }
                    }

                    RowLayout {
                        anchors.fill: _pill
                        anchors.leftMargin: LingmoUI.Units.largeSpacing
                        anchors.rightMargin: LingmoUI.Units.smallSpacing / 2
                        spacing: 0

                        Label {
                            Layout.fillWidth: true
                            text: _tabBtn.title
                            elide: Text.ElideMiddle
                            horizontalAlignment: Text.AlignHCenter
                            font.pointSize: LingmoUI.Units.fontBody
                            font.weight: _tabBtn.checked ? Font.DemiBold : Font.Normal
                            color: _tabBtn.checked ? LingmoUI.Theme.highlightedTextColor
                                 : _tabBtn.hovered ? LingmoUI.Theme.textColor
                                 : LingmoUI.Theme.secondaryTextColor

                            Behavior on color { ColorAnimation { duration: LingmoUI.Units.shortDuration } }
                        }

                        // Close button: on the current tab and on the hovered one
                        LingmoUI.IconButton {
                            id: _closeBtn
                            Layout.alignment: Qt.AlignVCenter
                            size: _pill.height - 6
                            iconSize: 12
                            round: true
                            iconName: "qrc:/images/" + (LingmoUI.Theme.darkMode || _tabBtn.checked ? "dark/" : "light/") + "close.svg"
                            focusPolicy: Qt.NoFocus
                            opacity: (_tabBtn.checked || _tabBtn.hovered) ? 1.0 : 0.0
                            enabled: opacity > 0

                            Behavior on opacity { NumberAnimation { duration: LingmoUI.Units.shortDuration } }

                            onClicked: root.closeProtection(_tabBtn.index)
                        }
                    }
                }
            }

            LingmoUI.IconButton {
                id: _newTabButton
                Layout.alignment: Qt.AlignVCenter
                round: true
                iconName: "qrc:/images/" + (LingmoUI.Theme.darkMode ? "dark/" : "light/") + "add.svg"
                tipText: qsTr("New Tab")
                focusPolicy: Qt.NoFocus
                onClicked: openNewTab()
            }

            // Free space to drag the window by
            Item {
                id: _dragSpace
                Layout.fillWidth: true
                Layout.minimumWidth: LingmoUI.Units.largeSpacing * 4
            }
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
