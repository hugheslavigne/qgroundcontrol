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
//-- RC RSSI Indicator

Item {
    width:          rssiRow.width * 1.1
    anchors.top:    parent.top
    anchors.bottom: parent.bottom
    visible:        true

    function getRSSIColor() {
        if(_activeVehicle) {
            if(pD2dInforData.getUlRateValue() > 7) {
                return qgcPal.colorGreen
            }
            if(pD2dInforData.getUlRateValue() > 4) {
                return qgcPal.colorOrange
            }
            if(pD2dInforData.getUlRateValue() > 0.1) {
                return qgcPal.colorRed
            }
        }
        return qgcPal.colorGrey
    }

    //end
    Component {
        id: rcRSSIInfo

        Rectangle {
            width:  rcrssiCol.width   + ScreenTools.defaultFontPixelWidth  * 3
            height: rcrssiCol.height  + ScreenTools.defaultFontPixelHeight * 2
            radius: ScreenTools.defaultFontPixelHeight * 0.5
            color:  qgcPal.window
            border.color:   qgcPal.text

            Column {
                id:                 rcrssiCol
                spacing:            ScreenTools.defaultFontPixelHeight * 0.5
                width:              Math.max(rcrssiGrid.width, rssiLabel.width)
                anchors.margins:    ScreenTools.defaultFontPixelHeight
                anchors.centerIn:   parent

                QGCLabel {
                    id:             rssiLabel
                    text:           qsTr("Data Rate")
                    font.family:    ScreenTools.demiboldFontFamily
                    anchors.horizontalCenter: parent.horizontalCenter
                }
            }

            Component.onCompleted: {
                var pos = mapFromItem(toolBar, centerX - (width / 2), toolBar.height)
                x = pos.x
                y = pos.y + ScreenTools.defaultFontPixelHeight
            }
        }
    }

    Row {
        id:             rssiRow
        anchors.top:    parent.top
        anchors.bottom: parent.bottom
        spacing:        ScreenTools.defaultFontPixelWidth

        QGCColoredImage {
            width:              height
            anchors.top:        parent.top
            anchors.bottom:     parent.bottom
            sourceSize.height:  height
            source:             "/qmlimages/RC.svg"
            fillMode:           Image.PreserveAspectFit
            opacity:            1
            color:              qgcPal.buttonText
        }


        QGCLabel {
            id:                     dataRate
            text:                   qsTr("0kbps")
            font.pointSize:         ScreenTools.mediumFontPointSize
            color:                  qgcPal.colorGrey
            anchors.verticalCenter: parent.verticalCenter
        }

        Connections {
            target:  pD2dInforData
            onSignalUpRate: {
               dataRate.text = pD2dInforData.getUlRateValue() + "kbps";
               dataRate.color = getRSSIColor()
            }
        }
    }

    MouseArea {
        anchors.fill:   parent
        onClicked: {
            var centerX = mapToItem(toolBar, x, y).x + (width / 2)
            mainWindow.showPopUp(rcRSSIInfo, centerX)
        }
    }
}
