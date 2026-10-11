import QtQuick 2.12
import QtQuick.Controls 2.12
import LingmoUI.CompatibleModule 3.0 as LingmoUI

// Icon-only button with an animated hover background. `iconName` is one of the
// bundled icons ("add", "close"); images/dark holds the white glyphs for the
// dark theme, images/light the dark ones.
AbstractButton {
    id: control

    property string iconName
    property string tipText

    implicitWidth: LingmoUI.Units.iconSizes.medium
    implicitHeight: LingmoUI.Units.iconSizes.medium
    hoverEnabled: true
    opacity: enabled ? 1.0 : 0.4

    background: Rectangle {
        radius: LingmoUI.Theme.smallRadius
        color: control.pressed ? Qt.rgba(LingmoUI.Theme.textColor.r, LingmoUI.Theme.textColor.g,
                                         LingmoUI.Theme.textColor.b, 0.15)
             : control.hovered ? Qt.rgba(LingmoUI.Theme.textColor.r, LingmoUI.Theme.textColor.g,
                                         LingmoUI.Theme.textColor.b, 0.08)
             : "transparent"

        Behavior on color { ColorAnimation { duration: 120 } }
    }

    contentItem: Item {
        Image {
            anchors.centerIn: parent
            width: LingmoUI.Units.iconSizes.small
            height: width
            sourceSize: Qt.size(width * 2, height * 2)
            source: "qrc:/images/" + (LingmoUI.Theme.darkMode ? "dark/" : "light/") + control.iconName + ".svg"
            smooth: true
        }
    }

    Accessible.name: tipText
    ToolTip.visible: hovered && tipText.length > 0
    ToolTip.text: tipText
    ToolTip.delay: 500
}
