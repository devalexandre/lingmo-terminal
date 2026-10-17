import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import LingmoUI.CompatibleModule 3.0 as LingmoUI

LingmoUI.Window {
    id: control

    title: qsTr("Settings")
    width: 820
    height: 580
    minimumWidth: 720
    minimumHeight: 460

    minimizeButtonVisible: false
    flags: Qt.WindowStaysOnTopHint | Qt.Dialog | Qt.FramelessWindowHint
    modality: Qt.WindowModal

    // Like Settings: the content goes up to the top edge and the sidebar keeps
    // a strip of header.height free for the window buttons
    header.height: LingmoUI.Units.windowHeaderHeight
    contentTopMargin: 0
    background.color: LingmoUI.Theme.backgroundColor

    LayoutMirroring.enabled: Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    visible: false

    RowLayout {
        anchors.fill: parent
        spacing: 0

        LingmoUI.SettingsSideBar {
            id: sideBar
            Layout.fillHeight: true

            // Tile colours follow the theme; ListElement only takes constants,
            // so they are filled in here
            model: ListModel {
                id: listModel

                ListElement {
                    title: qsTranslate("SettingsSideBar", "General")
                    name: "general"
                    page: "qrc:/qml/SettingsPages/General.qml"
                    iconSource: "qrc:/images/sidebar/general.svg"
                    iconColor: "transparent"
                }
                ListElement {
                    title: qsTranslate("SettingsSideBar", "Appearance")
                    name: "appearance"
                    page: "qrc:/qml/SettingsPages/Appearance.qml"
                    iconSource: "qrc:/images/sidebar/appearance.svg"
                    iconColor: "transparent"
                }
                ListElement {
                    title: qsTranslate("SettingsSideBar", "Bookmark")
                    name: "bookmark"
                    page: "qrc:/qml/SettingsPages/Bookmark.qml"
                    iconSource: "qrc:/images/sidebar/bookmark.svg"
                    iconColor: "transparent"
                }
                ListElement {
                    title: qsTranslate("SettingsSideBar", "Custom")
                    name: "custom"
                    page: "qrc:/qml/SettingsPages/Custom.qml"
                    iconSource: "qrc:/images/sidebar/custom.svg"
                    iconColor: "transparent"
                }
            }

            readonly property var tileColors: [LingmoUI.Theme.greyColor, LingmoUI.Theme.purpleColor,
                                               LingmoUI.Theme.orangeColor, LingmoUI.Theme.blueColor]
            onTileColorsChanged: updateTiles()
            Component.onCompleted: updateTiles()

            function updateTiles() {
                for (var i = 0; i < listModel.count && i < tileColors.length; ++i)
                    listModel.setProperty(i, "iconColor", tileColors[i].toString())
            }

            onCurrentIndexChanged: {
                switchPageFromIndex(currentIndex)
            }
        }

        StackView {
            id: _stackView
            Layout.fillWidth: true
            Layout.fillHeight: true
            initialItem: Qt.resolvedUrl(sideBar.model.get(0).page)
            clip: true

            pushEnter: Transition {}
            pushExit: Transition {}
            popEnter: Transition {}
            popExit: Transition {}
            replaceEnter: Transition {}
            replaceExit: Transition {}
        }
    }

    function switchPageFromIndex(index) {
        _stackView.replace(null, Qt.resolvedUrl(sideBar.model.get(index).page))
    }
}
