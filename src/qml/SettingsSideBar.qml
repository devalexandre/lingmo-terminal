import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import LingmoUI.CompatibleModule 3.0 as LingmoUI

// Same look as the sidebar of Lingmo Settings
Item {
    implicitWidth: 230

    property alias view: listView
    property alias model: listModel
    property alias currentIndex: listView.currentIndex

    Rectangle {
        anchors.fill: parent
        color: LingmoUI.Theme.darkMode ? Qt.rgba(0.11, 0.11, 0.15, 0.55) : "#EDEEF2"

        Behavior on color {
            ColorAnimation {
                duration: 250
                easing.type: Easing.Linear
            }
        }
    }

    ListModel {
        id: listModel

        ListElement {
            title: qsTr("General")
            name: "general"
            page: "qrc:/qml/SettingsPages/General.qml"
            iconSource: "qrc:/images/sidebar/general.svg"
            tile: "grey"
        }
        ListElement {
            title: qsTr("Appearance")
            name: "appearance"
            page: "qrc:/qml/SettingsPages/Appearance.qml"
            iconSource: "qrc:/images/sidebar/appearance.svg"
            tile: "purple"
        }
        ListElement {
            title: qsTr("Bookmark")
            name: "bookmark"
            page: "qrc:/qml/SettingsPages/Bookmark.qml"
            iconSource: "qrc:/images/sidebar/bookmark.svg"
            tile: "orange"
        }
        ListElement {
            title: qsTr("Custom")
            name: "custom"
            page: "qrc:/qml/SettingsPages/Custom.qml"
            iconSource: "qrc:/images/sidebar/custom.svg"
            tile: "blue"
        }
    }

    function tileColor(name) {
        switch (name) {
        case "purple": return LingmoUI.Theme.purpleColor
        case "orange": return LingmoUI.Theme.orangeColor
        case "blue": return LingmoUI.Theme.blueColor
        default: return LingmoUI.Theme.greyColor
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 0

        // The window buttons sit in this strip
        Item {
            Layout.preferredHeight: control.header.height
        }

        Label {
            Layout.fillWidth: true
            text: control.title
            color: control.active ? LingmoUI.Theme.textColor : LingmoUI.Theme.disabledTextColor
            leftPadding: LingmoUI.Units.largeSpacing + LingmoUI.Units.smallSpacing
            rightPadding: LingmoUI.Units.largeSpacing + LingmoUI.Units.smallSpacing
            topPadding: 2
            bottomPadding: LingmoUI.Units.largeSpacing
            font.pointSize: 17
            font.bold: true
            elide: Text.ElideRight
        }

        ListView {
            id: listView
            Layout.fillHeight: true
            Layout.fillWidth: true
            clip: true
            model: listModel
            boundsBehavior: Flickable.StopAtBounds

            spacing: LingmoUI.Units.smallSpacing
            leftMargin: LingmoUI.Units.largeSpacing
            rightMargin: LingmoUI.Units.largeSpacing
            bottomMargin: LingmoUI.Units.largeSpacing

            ScrollBar.vertical: ScrollBar {}

            highlightFollowsCurrentItem: true
            highlightMoveDuration: 0
            highlightResizeDuration: 0
            highlight: Rectangle {
                radius: LingmoUI.Theme.mediumRadius
                color: LingmoUI.Theme.highlightColor
            }

            LingmoUI.WheelHandler {
                target: listView
            }

            delegate: Item {
                id: item
                width: ListView.view.width - ListView.view.leftMargin - ListView.view.rightMargin
                height: LingmoUI.Units.fontMetrics.height + LingmoUI.Units.largeSpacing * 1.5

                property bool isCurrent: listView.currentIndex === index

                Rectangle {
                    anchors.fill: parent
                    radius: LingmoUI.Theme.mediumRadius
                    color: mouseArea.containsMouse && !item.isCurrent
                           ? Qt.rgba(LingmoUI.Theme.textColor.r, LingmoUI.Theme.textColor.g,
                                     LingmoUI.Theme.textColor.b, 0.1)
                           : "transparent"

                    Behavior on color { ColorAnimation { duration: 120 } }
                }

                MouseArea {
                    id: mouseArea
                    anchors.fill: parent
                    hoverEnabled: true
                    acceptedButtons: Qt.LeftButton
                    onClicked: listView.currentIndex = index
                }

                RowLayout {
                    anchors.fill: parent
                    anchors.leftMargin: LingmoUI.Units.largeSpacing
                    anchors.rightMargin: LingmoUI.Units.smallSpacing
                    spacing: LingmoUI.Units.smallSpacing * 1.5

                    Rectangle {
                        id: iconRect
                        Layout.preferredWidth: 26
                        Layout.preferredHeight: 26
                        Layout.alignment: Qt.AlignVCenter
                        radius: 7

                        readonly property color baseColor: {
                            var c = tileColor(model.tile)
                            return LingmoUI.Theme.darkMode ? Qt.lighter(c, 1.12) : Qt.darker(c, 1.04)
                        }
                        gradient: Gradient {
                            GradientStop { position: 0.0; color: Qt.lighter(iconRect.baseColor, LingmoUI.Theme.darkMode ? 1.18 : 1.12) }
                            GradientStop { position: 1.0; color: iconRect.baseColor }
                        }
                        border.width: 1
                        border.color: LingmoUI.Theme.darkMode ? Qt.rgba(1, 1, 1, item.isCurrent ? 0.55 : 0.18)
                                                              : Qt.rgba(0, 0, 0, item.isCurrent ? 0.0 : 0.10)

                        Image {
                            anchors.centerIn: parent
                            width: 16
                            height: width
                            source: model.iconSource
                            sourceSize: Qt.size(width * 2, height * 2)
                            smooth: true
                            antialiasing: true
                        }
                    }

                    Label {
                        Layout.fillWidth: true
                        text: model.title
                        elide: Text.ElideRight
                        color: item.isCurrent ? LingmoUI.Theme.highlightedTextColor : LingmoUI.Theme.textColor
                    }
                }
            }
        }
    }
}
