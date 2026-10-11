import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import LingmoUI.CompatibleModule 3.0 as LingmoUI

ItemPage {
    headerTitle: qsTr("Appearance")

    Scrollable {
        anchors.fill: parent
        contentHeight: _mainLayout.implicitHeight

        ColumnLayout {
            id: _mainLayout
            width: parent.width
            spacing: LingmoUI.Units.largeSpacing * 2

            RoundedItem {
                Label {
                    text: qsTr("Font")
                    color: LingmoUI.Theme.disabledTextColor
                }

                GridLayout {
                    columns: 2
                    columnSpacing: LingmoUI.Units.largeSpacing * 2
                    rowSpacing: LingmoUI.Units.largeSpacing

                    Label {
                        text: qsTr("Font")
                    }

                    ComboBox {
                        id: fontsCombobox
                        model: Fonts.families
                        Layout.fillWidth: true

                        // Write only on a user choice, so opening the page never changes the setting
                        onActivated: settings.fontName = currentText
                        Component.onCompleted: currentIndex = Math.max(0, find(settings.fontName))
                    }

                    Label {
                        text: qsTr("Font Size")
                    }

                    RowLayout {
                        Layout.fillWidth: true
                        spacing: LingmoUI.Units.largeSpacing

                        Slider {
                            id: fontSizeSlider
                            Layout.fillWidth: true
                            from: 5
                            to: 30
                            stepSize: 1

                            Component.onCompleted: {
                                fontSizeSlider.value = settings.fontPointSize
                            }

                            onMoved: settings.fontPointSize = fontSizeSlider.value
                        }

                        Label {
                            Layout.preferredWidth: LingmoUI.Units.fontMetrics.advanceWidth("00") + LingmoUI.Units.smallSpacing
                            horizontalAlignment: Text.AlignRight
                            text: Math.round(fontSizeSlider.value)
                            color: LingmoUI.Theme.disabledTextColor
                        }
                    }
                }
            }

            RoundedItem {
                Label {
                    text: qsTr("Color Scheme")
                    color: LingmoUI.Theme.disabledTextColor
                }

                GridLayout {
                    columns: 2
                    columnSpacing: LingmoUI.Units.largeSpacing * 2
                    rowSpacing: LingmoUI.Units.largeSpacing

                    Label {
                        text: qsTr("Light Color Scheme")
                    }

                    ComboBox {
                        id: lightthemeCombobox
                        model: settings.colorschemes
                        Layout.fillWidth: true
                        currentIndex: count > 0 ? find(settings.lightcolorScheme) : -1
                        onActivated: settings.lightcolorScheme = currentText
                    }

                    Label {
                        text: qsTr("Dark Color Scheme")
                    }

                    ComboBox {
                        id: darkthemeCombobox
                        model: settings.colorschemes
                        Layout.fillWidth: true
                        currentIndex: count > 0 ? find(settings.darkcolorScheme) : -1
                        onActivated: settings.darkcolorScheme = currentText
                    }
                }
            }

            RoundedItem {
                Label {
                    text: qsTr("Keyboard Cursor")
                    color: LingmoUI.Theme.disabledTextColor
                }

                GridLayout {
                    columns: 2
                    columnSpacing: LingmoUI.Units.largeSpacing * 2
                    rowSpacing: LingmoUI.Units.largeSpacing

                    Label {
                        text: qsTr("Shape")
                    }

                    TabBar {
                        Layout.fillWidth: true
                        currentIndex: settings.keyboardCursorShape
                        onCurrentIndexChanged: settings.keyboardCursorShape = currentIndex

                        TabButton {
                            text: "▐"
                        }

                        TabButton {
                            text: "▂"
                        }

                        TabButton {
                            text: "|"
                        }
                    }

                    Label {
                        text: qsTr("Blinking")
                    }

                    Switch {
                        Layout.alignment: Qt.AlignRight
                        checked: settings.blinkingCursor
                        onCheckedChanged: settings.blinkingCursor = checked
                    }
                }
            }

            RoundedItem {
                Label {
                    text: qsTr("Window effects")
                    color: LingmoUI.Theme.disabledTextColor
                }

                GridLayout {
                    columns: 2
                    columnSpacing: LingmoUI.Units.largeSpacing * 2
                    rowSpacing: LingmoUI.Units.largeSpacing

                    Label {
                        text: qsTr("Transparency")
                    }

                    Slider {
                        id: transparencySlider
                        Layout.fillWidth: true
                        from: 0.1
                        to: 1.0
                        stepSize: 0.05

                        Component.onCompleted: {
                            transparencySlider.value = settings.opacity
                        }

                        onMoved: settings.opacity = transparencySlider.value
                    }

                    Label {
                        text: qsTr("Window Blur")
                    }

                    Switch {
                        Layout.alignment: Qt.AlignRight
                        checked: settings.blur
                        onCheckedChanged: settings.blur = checked
                    }
                }
            }
        }
    }
}
