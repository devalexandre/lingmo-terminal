import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import LingmoUI.CompatibleModule 3.0 as LingmoUI

ItemPage {
    headerTitle: qsTr("Bookmark")

    function addBookmark() {
        var dir = _dirurl.text.trim()
        if (dir.length === 0)
            return
        var mbm = settings.bookmark
        mbm.push(dir)
        settings.bookmark = mbm
        _dirurl.clear()
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: _mainLayout.implicitHeight

        ColumnLayout {
            id: _mainLayout
            width: parent.width
            spacing: LingmoUI.Units.largeSpacing * 2

            LingmoUI.Card {
                id: _card1
                Layout.fillWidth: true
                implicitHeight: _cardLayout1.implicitHeight + LingmoUI.Units.largeSpacing * 2

                ColumnLayout {
                    id: _cardLayout1
                    anchors.fill: parent
                    anchors.leftMargin: _card1.padding
                    anchors.rightMargin: _card1.padding
                    anchors.topMargin: LingmoUI.Units.largeSpacing
                    anchors.bottomMargin: LingmoUI.Units.largeSpacing
                    spacing: LingmoUI.Units.smallSpacing

                    Label {
                        Layout.bottomMargin: LingmoUI.Units.smallSpacing
                        text: qsTr("Bookmark")
                        color: LingmoUI.Theme.secondaryTextColor
                        font.pointSize: LingmoUI.Units.fontCaption
                        font.weight: Font.DemiBold
                    }

                    LingmoUI.EmptyState {
                        Layout.fillWidth: true
                        Layout.topMargin: LingmoUI.Units.smallSpacing
                        Layout.bottomMargin: LingmoUI.Units.smallSpacing
                        visible: settings.bookmark.length === 0
                        title: qsTr("No bookmarks")
                        text: qsTr("Folders added here appear under Bookmark in the terminal's menu.")
                    }

                    Repeater {
                        model: settings.bookmark

                        delegate: RowLayout {
                            Layout.fillWidth: true
                            spacing: LingmoUI.Units.smallSpacing

                            Label {
                                Layout.fillWidth: true
                                text: modelData
                                elide: Text.ElideMiddle
                                font.pointSize: LingmoUI.Units.fontBody
                            }

                            LingmoUI.IconButton {
                                iconName: "qrc:/images/" + (LingmoUI.Theme.darkMode ? "dark/" : "light/") + "close.svg"
                                tipText: qsTr("Remove")
                                onClicked: {
                                    var mbm = settings.bookmark
                                    mbm.splice(index, 1)
                                    settings.bookmark = mbm
                                }
                            }
                        }
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        Layout.topMargin: LingmoUI.Units.smallSpacing
                        spacing: LingmoUI.Units.smallSpacing

                        TextField {
                            id: _dirurl
                            Layout.fillWidth: true
                            placeholderText: qsTr("Directory address")
                            onAccepted: addBookmark()
                        }

                        LingmoUI.IconButton {
                            iconName: "qrc:/images/" + (LingmoUI.Theme.darkMode ? "dark/" : "light/") + "add.svg"
                            tipText: qsTr("Add")
                            enabled: _dirurl.text.trim().length > 0
                            onClicked: addBookmark()
                        }
                    }
                }
            }
        }
    }
}
