import QtQuick 2.4
import QtQuick.Controls 2.4
import LingmoUI.CompatibleModule 3.0 as LingmoUI

// Vertical page scroller (same as Lingmo Settings' Scrollable)
Flickable {
    id: root
    flickableDirection: Flickable.VerticalFlick
    boundsBehavior: Flickable.StopAtBounds
    clip: true

    topMargin: LingmoUI.Units.largeSpacing
    bottomMargin: LingmoUI.Units.largeSpacing * 2
    leftMargin: LingmoUI.Units.largeSpacing * 2
    rightMargin: LingmoUI.Units.largeSpacing * 2

    contentWidth: width - (leftMargin + rightMargin)

    // Start at the top even when the content grows while the page loads
    Component.onCompleted: contentY = -topMargin

    LingmoUI.WheelHandler {
        target: root
    }

    ScrollBar.vertical: ScrollBar {
        bottomPadding: LingmoUI.Theme.smallRadius
    }
}
