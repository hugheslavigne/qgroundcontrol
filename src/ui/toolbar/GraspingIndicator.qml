/****************************************************************************
 *
 *   (c) 2009-2016 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

import QtQuick          2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts  1.2

import QGroundControl                       1.0
import QGroundControl.Controls              1.0
import QGroundControl.MultiVehicleManager   1.0
import QGroundControl.ScreenTools           1.0
import QGroundControl.Palette               1.0

//-------------------------------------------------------------------------
//-- Armed Indicator
Column {
    id:                 graspingCol
    spacing:            ScreenTools.defaultFontPixelHeight * 0.5
    width:              graspingLabel.width * 2
    anchors.margins:    ScreenTools.defaultFontPixelHeight
    anchors.centerIn:   parent

    QGCLabel {
        id:                 graspingLabel
        anchors.top:        parent.top
        anchors.bottom:     parent.bottom
        verticalAlignment:  Text.AlignVCenter
        text:               "Grasping"
        font.pointSize:     ScreenTools.mediumFontPointSize
        color:              qgcPal.buttonText
        QGCPalette { id: qgcPal }
    }

    ProgressBar {
        id:                 graspingProgress
        anchors.top:        parent.top
        anchors.bottom:     parent.bottom
        width:              graspingLabel.width
        verticalAlignment:  Text.AlignVCenter
        background: Rectangle {
                color: "#e6e6e6"
                radius: 3
            }
        contentItem: Item {
                Rectangle {
                    width: progressBar.visualPosition * parent.width
                    height: parent.height
                    radius: 2
                    color: "#17a81a"
                    }
            }
    }

//    QGCMouseArea {
//        fillItem: parent
//        onClicked: _armed ? toolBar.disarmVehicle() : toolBar.armVehicle()
//    }
}
