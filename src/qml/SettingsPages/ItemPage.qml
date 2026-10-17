import QtQuick 2.4
import QtQuick.Controls 2.4
import QtQuick.Layouts 1.3
import LingmoUI.CompatibleModule 3.0 as LingmoUI

// A settings page with its title in the window's header strip, like Lingmo Settings
Page {
    id: page

    property string headerTitle

    background: Rectangle {
        color: control.background.color
    }

    header: LingmoUI.PageHeader {
        height: control.header.height
        title: page.headerTitle
        large: false
        leftPadding: LingmoUI.Units.largeSpacing * 2
        rightPadding: LingmoUI.Units.largeSpacing * 2
    }
}
