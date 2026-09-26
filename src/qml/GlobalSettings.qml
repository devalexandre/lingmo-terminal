/**
 * New LingmoOS terminal
 * Copyright 2023 LingmoOS Team
 */
import QtQuick 2.0
import QtCore

Settings {
    property int width: 750
    property int height: 500
    property int fontPointSize: 11
    property string fontName: "Ubuntu Mono"
    property int keyboardCursorShape: 0
    property bool blinkingCursor: true

    property var searchUrl: [[qsTr("Bing"),"https://cn.bing.com/search?from=MOZLBR&pc=MOZI&q={KeyWord}"]]
    property var bookmark: []
    property string wordCharacters: ":@-./_~,"
    property var colorschemes: ["Lingmo-Light","Lingmo-Dark","Dracula","BlackOnLightYellow","BlackOnRandomLight","BlackOnWhite","Tango","Ubuntu","Solarized","SolarizedLight"]
    property string lightcolorScheme: "Lingmo-Light"
    property string darkcolorScheme: "Dracula"
    property color lightbackgroundColor : "#FFFFFF"
    property color darkbackgroundColor : "#282A36"

    // v1: Dracula became the dark default and the scheme list gained it. Saved
    // settings keep the old list and default, so update them once.
    property int schemesVersion: 0
    Component.onCompleted: {
        if (schemesVersion < 1) {
            colorschemes = ["Lingmo-Light","Lingmo-Dark","Dracula","BlackOnLightYellow","BlackOnRandomLight","BlackOnWhite","Tango","Ubuntu","Solarized","SolarizedLight"]
            if (darkcolorScheme === "Tango")
                darkcolorScheme = "Dracula"
            schemesVersion = 1
        }
    }

    property double opacity: 0.4
    property bool blur: true
}
