import QtQuick 2.12
import QtQuick.Layouts 1.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.12
import LingmoUI.CompatibleModule 3.0 as LingmoUI

LingmoUI.Window {
    id: control

    title: qsTr("Settings")
    width: 820
    height: 580
    minimumWidth: 720
    minimumHeight: 460

    minimizeButtonVisible: false
    flags: Qt.WindowStaysOnTopHint | Qt.Dialog | Qt.FramelessWindowHint
    modality: Qt.WindowModal

    // Like Settings: the content goes up to the top edge and the sidebar keeps
    // a strip of header.height free for the window buttons
    header.height: 40
    contentTopMargin: 0
    background.color: LingmoUI.Theme.backgroundColor

    LayoutMirroring.enabled: Qt.application.layoutDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    visible: false

    RowLayout {
        anchors.fill: parent
        spacing: 0

        SettingsSideBar {
            id: sideBar
            Layout.fillHeight: true

            onCurrentIndexChanged: {
                switchPageFromIndex(currentIndex)
            }
        }

        StackView {
            id: _stackView
            Layout.fillWidth: true
            Layout.fillHeight: true
            initialItem: Qt.resolvedUrl(sideBar.model.get(0).page)
            clip: true

            pushEnter: Transition {}
            pushExit: Transition {}
            popEnter: Transition {}
            popExit: Transition {}
            replaceEnter: Transition {}
            replaceExit: Transition {}
        }
    }

    function switchPageFromIndex(index) {
        _stackView.replace(null, Qt.resolvedUrl(sideBar.model.get(index).page))
    }
}
