import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import LingmoUI.CompatibleModule 3.0 as LingmoUI

ItemPage {
    headerTitle: qsTr("Custom")

    // settings.searchUrl hands out a copy, so edit a copy and store it back
    function setEngine(index, name, url) {
        var engines = settings.searchUrl
        engines[index] = [name, url]
        settings.searchUrl = engines
    }

    function addEngine() {
        var name = _urlname.text.trim()
        var url = _url.text.trim()
        if (name.length === 0 || url.length === 0)
            return
        var engines = settings.searchUrl
        engines.push([name, url])
        settings.searchUrl = engines
        _urlname.clear()
        _url.clear()
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: _mainLayout.implicitHeight

        ColumnLayout {
            id: _mainLayout
            width: parent.width
            spacing: LingmoUI.Units.largeSpacing * 2

            RoundedItem {
                Label {
                    text: qsTr("Terminal")
                    color: LingmoUI.Theme.disabledTextColor
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: LingmoUI.Units.largeSpacing * 2

                    Label {
                        text: qsTr("Word Characters")
                    }

                    TextField {
                        Layout.fillWidth: true
                        text: settings.wordCharacters
                        onTextChanged: settings.wordCharacters = text
                    }
                }
            }

            RoundedItem {
                spacing: LingmoUI.Units.smallSpacing

                Label {
                    text: qsTr("Search Engines")
                    color: LingmoUI.Theme.disabledTextColor
                }

                Label {
                    Layout.fillWidth: true
                    Layout.bottomMargin: LingmoUI.Units.smallSpacing
                    text: qsTr("{KeyWord} in the address is replaced by the selected text.")
                    color: LingmoUI.Theme.disabledTextColor
                    font.pointSize: LingmoUI.Theme.fontSize * 0.9
                    wrapMode: Text.WordWrap
                }

                Repeater {
                    model: settings.searchUrl

                    delegate: RowLayout {
                        Layout.fillWidth: true
                        spacing: LingmoUI.Units.smallSpacing

                        TextField {
                            id: _name
                            Layout.preferredWidth: LingmoUI.Units.gridUnit * 7
                            text: modelData[0]
                            onEditingFinished: if (text !== modelData[0]) setEngine(index, text, _address.text)
                        }

                        TextField {
                            id: _address
                            Layout.fillWidth: true
                            text: modelData[1]
                            onEditingFinished: if (text !== modelData[1]) setEngine(index, _name.text, text)
                        }

                        IconButton {
                            iconName: "close"
                            tipText: qsTr("Remove")
                            onClicked: {
                                var engines = settings.searchUrl
                                engines.splice(index, 1)
                                settings.searchUrl = engines
                            }
                        }
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: LingmoUI.Units.smallSpacing
                    spacing: LingmoUI.Units.smallSpacing

                    TextField {
                        id: _urlname
                        Layout.preferredWidth: LingmoUI.Units.gridUnit * 7
                        placeholderText: qsTr("Name")
                        onAccepted: _url.forceActiveFocus()
                    }

                    TextField {
                        id: _url
                        Layout.fillWidth: true
                        placeholderText: "https://…?q={KeyWord}"
                        onAccepted: addEngine()
                    }

                    IconButton {
                        iconName: "add"
                        tipText: qsTr("Add")
                        enabled: _urlname.text.trim().length > 0 && _url.text.trim().length > 0
                        onClicked: addEngine()
                    }
                }
            }
        }
    }
}
