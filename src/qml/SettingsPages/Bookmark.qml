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

            RoundedItem {
                spacing: LingmoUI.Units.smallSpacing

                Label {
                    Layout.bottomMargin: LingmoUI.Units.smallSpacing
                    text: qsTr("Bookmark")
                    color: LingmoUI.Theme.disabledTextColor
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
                        }

                        IconButton {
                            iconName: "close"
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

                    IconButton {
                        iconName: "add"
                        tipText: qsTr("Add")
                        enabled: _dirurl.text.trim().length > 0
                        onClicked: addBookmark()
                    }
                }
            }
        }
    }
}
