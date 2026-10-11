import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Controls 2.12
import LingmoUI.CompatibleModule 3.0 as LingmoUI

ItemPage {
    id: page
    headerTitle: qsTr("General")

    // Read once per page: the list only changes when shells are (un)installed
    readonly property string defaultShell: Utils.defaultShell()
    readonly property var shells: Utils.availableShells()

    // True while "Other..." is picked but no valid path was applied yet
    property bool otherPicked: false

    readonly property bool customShell: {
        if (settings.shellProgram === "")
            return false
        for (var i = 0; i < shells.length; ++i) {
            if (shells[i].path === settings.shellProgram)
                return false
        }
        return true
    }
    readonly property bool otherSelected: otherPicked || customShell

    function chooseShell(path) {
        otherPicked = false
        otherError.visible = false
        settings.shellProgram = path
    }

    function applyOther() {
        var path = otherField.text.trim()
        if (Utils.isUsableShell(path)) {
            otherError.visible = false
            otherPicked = false
            settings.shellProgram = path
        } else {
            otherError.visible = true
        }
    }

    // One choice in the list; the chosen one is highlighted with a check mark,
    // like the language list in Lingmo Settings
    component ShellRow: Rectangle {
        id: row

        property string title
        property string subtitle
        property bool selected: false
        signal picked()

        Layout.fillWidth: true
        implicitHeight: rowLayout.implicitHeight + LingmoUI.Units.smallSpacing * 2
        radius: LingmoUI.Theme.smallRadius
        color: row.selected ? LingmoUI.Theme.highlightColor
             : rowMouse.containsMouse ? Qt.rgba(LingmoUI.Theme.textColor.r, LingmoUI.Theme.textColor.g,
                                                LingmoUI.Theme.textColor.b, 0.08)
             : "transparent"

        Behavior on color { ColorAnimation { duration: 120 } }

        Accessible.role: Accessible.RadioButton
        Accessible.name: row.title
        Accessible.checked: row.selected

        MouseArea {
            id: rowMouse
            anchors.fill: parent
            hoverEnabled: true
            onClicked: row.picked()
        }

        RowLayout {
            id: rowLayout
            anchors.fill: parent
            anchors.leftMargin: LingmoUI.Units.largeSpacing
            anchors.rightMargin: LingmoUI.Units.largeSpacing
            spacing: LingmoUI.Units.largeSpacing

            ColumnLayout {
                Layout.fillWidth: true
                spacing: 0

                Label {
                    Layout.fillWidth: true
                    text: row.title
                    elide: Text.ElideRight
                    color: row.selected ? LingmoUI.Theme.highlightedTextColor : LingmoUI.Theme.textColor
                }

                Label {
                    Layout.fillWidth: true
                    text: row.subtitle
                    visible: text.length > 0
                    color: row.selected ? Qt.rgba(LingmoUI.Theme.highlightedTextColor.r,
                                                  LingmoUI.Theme.highlightedTextColor.g,
                                                  LingmoUI.Theme.highlightedTextColor.b, 0.8)
                                        : LingmoUI.Theme.disabledTextColor
                    font.pointSize: LingmoUI.Theme.fontSize * 0.9
                    elide: Text.ElideMiddle
                }
            }

            Image {
                Layout.preferredWidth: LingmoUI.Units.iconSizes.small
                Layout.preferredHeight: LingmoUI.Units.iconSizes.small
                sourceSize: Qt.size(LingmoUI.Units.iconSizes.small * 2, LingmoUI.Units.iconSizes.small * 2)
                source: "qrc:/images/checked.svg"
                visible: row.selected
                smooth: true
            }
        }
    }

    Scrollable {
        anchors.fill: parent
        contentHeight: layout.implicitHeight

        ColumnLayout {
            id: layout
            width: parent.width
            spacing: LingmoUI.Units.largeSpacing * 2

            RoundedItem {
                spacing: LingmoUI.Units.smallSpacing

                Label {
                    text: qsTr("Shell")
                    color: LingmoUI.Theme.disabledTextColor
                }

                Label {
                    Layout.fillWidth: true
                    Layout.bottomMargin: LingmoUI.Units.smallSpacing
                    text: qsTr("Applies to new tabs and windows.")
                    color: LingmoUI.Theme.disabledTextColor
                    font.pointSize: LingmoUI.Theme.fontSize * 0.9
                    wrapMode: Text.WordWrap
                }

                ShellRow {
                    title: qsTr("System default (%1)").arg(Utils.shellName(page.defaultShell))
                    subtitle: page.defaultShell
                    selected: settings.shellProgram === "" && !page.otherPicked
                    onPicked: page.chooseShell("")
                }

                Repeater {
                    model: page.shells

                    delegate: ShellRow {
                        title: modelData.name
                        subtitle: modelData.path
                        selected: settings.shellProgram === modelData.path && !page.otherPicked
                        onPicked: page.chooseShell(modelData.path)
                    }
                }

                ShellRow {
                    title: qsTr("Other…")
                    subtitle: page.customShell ? settings.shellProgram : qsTr("Any program, by its full path")
                    selected: page.otherSelected
                    onPicked: {
                        page.otherPicked = true
                        otherField.text = page.customShell ? settings.shellProgram : ""
                        otherField.forceActiveFocus()
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    Layout.topMargin: LingmoUI.Units.smallSpacing
                    spacing: LingmoUI.Units.smallSpacing
                    visible: page.otherSelected

                    TextField {
                        id: otherField
                        Layout.fillWidth: true
                        placeholderText: "/usr/bin/…"
                        text: page.customShell ? settings.shellProgram : ""
                        inputMethodHints: Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
                        onAccepted: page.applyOther()
                        onTextChanged: otherError.visible = false
                    }

                    Button {
                        text: qsTr("Use")
                        enabled: otherField.text.trim().length > 0
                        onClicked: page.applyOther()
                    }
                }

                Label {
                    id: otherError
                    Layout.fillWidth: true
                    visible: false
                    text: qsTr("Enter the full path of an executable file, like /usr/bin/fish.")
                    color: LingmoUI.Theme.redColor
                    font.pointSize: LingmoUI.Theme.fontSize * 0.9
                    wrapMode: Text.WordWrap
                }
            }
        }
    }
}
