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
                    spacing: LingmoUI.Units.largeSpacing

                    Label {
                        text: qsTr("Font")
                        color: LingmoUI.Theme.secondaryTextColor
                        font.pointSize: LingmoUI.Units.fontCaption
                        font.weight: Font.DemiBold
                    }

                    GridLayout {
                        columns: 2
                        columnSpacing: LingmoUI.Units.largeSpacing * 2
                        rowSpacing: LingmoUI.Units.largeSpacing

                        Label {
                            text: qsTr("Font")
                            font.pointSize: LingmoUI.Units.fontBody
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
                            font.pointSize: LingmoUI.Units.fontBody
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
                                color: LingmoUI.Theme.secondaryTextColor
                                font.pointSize: LingmoUI.Units.fontBody
                            }
                        }
                    }
                }
            }

            LingmoUI.Card {
                id: _card2
                Layout.fillWidth: true
                implicitHeight: _cardLayout2.implicitHeight + LingmoUI.Units.largeSpacing * 2

                ColumnLayout {
                    id: _cardLayout2
                    anchors.fill: parent
                    anchors.leftMargin: _card2.padding
                    anchors.rightMargin: _card2.padding
                    anchors.topMargin: LingmoUI.Units.largeSpacing
                    anchors.bottomMargin: LingmoUI.Units.largeSpacing
                    spacing: LingmoUI.Units.largeSpacing

                    Label {
                        text: qsTr("Color Scheme")
                        color: LingmoUI.Theme.secondaryTextColor
                        font.pointSize: LingmoUI.Units.fontCaption
                        font.weight: Font.DemiBold
                    }

                    GridLayout {
                        columns: 2
                        columnSpacing: LingmoUI.Units.largeSpacing * 2
                        rowSpacing: LingmoUI.Units.largeSpacing

                        Label {
                            text: qsTr("Light Color Scheme")
                            font.pointSize: LingmoUI.Units.fontBody
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
                            font.pointSize: LingmoUI.Units.fontBody
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
            }

            LingmoUI.Card {
                id: _card3
                Layout.fillWidth: true
                implicitHeight: _cardLayout3.implicitHeight + LingmoUI.Units.largeSpacing * 2

                ColumnLayout {
                    id: _cardLayout3
                    anchors.fill: parent
                    anchors.leftMargin: _card3.padding
                    anchors.rightMargin: _card3.padding
                    anchors.topMargin: LingmoUI.Units.largeSpacing
                    anchors.bottomMargin: LingmoUI.Units.largeSpacing
                    spacing: LingmoUI.Units.largeSpacing

                    Label {
                        text: qsTr("Keyboard Cursor")
                        color: LingmoUI.Theme.secondaryTextColor
                        font.pointSize: LingmoUI.Units.fontCaption
                        font.weight: Font.DemiBold
                    }

                    GridLayout {
                        columns: 2
                        columnSpacing: LingmoUI.Units.largeSpacing * 2
                        rowSpacing: LingmoUI.Units.largeSpacing

                        Label {
                            text: qsTr("Shape")
                            font.pointSize: LingmoUI.Units.fontBody
                        }

                        LingmoUI.SegmentedControl {
                            Layout.fillWidth: true
                            fillWidth: true
                            model: ["▐", "▂", "|"]
                            currentIndex: settings.keyboardCursorShape
                            onActivated: (index) => settings.keyboardCursorShape = index
                        }

                        Label {
                            text: qsTr("Blinking")
                            font.pointSize: LingmoUI.Units.fontBody
                        }

                        Switch {
                            Layout.alignment: Qt.AlignRight
                            checked: settings.blinkingCursor
                            onCheckedChanged: settings.blinkingCursor = checked
                        }
                    }
                }
            }

            LingmoUI.Card {
                id: _card4
                Layout.fillWidth: true
                implicitHeight: _cardLayout4.implicitHeight + LingmoUI.Units.largeSpacing * 2

                ColumnLayout {
                    id: _cardLayout4
                    anchors.fill: parent
                    anchors.leftMargin: _card4.padding
                    anchors.rightMargin: _card4.padding
                    anchors.topMargin: LingmoUI.Units.largeSpacing
                    anchors.bottomMargin: LingmoUI.Units.largeSpacing
                    spacing: LingmoUI.Units.largeSpacing

                    Label {
                        text: qsTr("Window effects")
                        color: LingmoUI.Theme.secondaryTextColor
                        font.pointSize: LingmoUI.Units.fontCaption
                        font.weight: Font.DemiBold
                    }

                    GridLayout {
                        columns: 2
                        columnSpacing: LingmoUI.Units.largeSpacing * 2
                        rowSpacing: LingmoUI.Units.largeSpacing

                        Label {
                            text: qsTr("Transparency")
                            font.pointSize: LingmoUI.Units.fontBody
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
                            font.pointSize: LingmoUI.Units.fontBody
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
}
