/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: http://www.qt.io/licensing/
**
** This file is part of the E-Bike demo project.
**
** $QT_BEGIN_LICENSE:LGPL3$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see http://www.qt.io/terms-conditions. For further
** information use the contact form at http://www.qt.io/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 3 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPLv3 included in the
** packaging of this file. Please review the following information to
** ensure the GNU Lesser General Public License version 3 requirements
** will be met: https://www.gnu.org/licenses/lgpl.html.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 2.0 or later as published by the Free
** Software Foundation and appearing in the file LICENSE.GPL included in
** the packaging of this file. Please review the following information to
** ensure the GNU General Public License version 2.0 requirements will be
** met: http://www.gnu.org/licenses/gpl-2.0.html.
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.9
import QtQuick.Controls 2.2
import QtCharts 2.2
import DataStore 1.0

import "./BikeStyle"
import "moment.js" as Moment

Page {
    id: statsPage
    background: Rectangle {
        color: Colors.mainBackground
    }

    // Function for pretty-printing duration
    function splitDuration(duration) {
        var hours = Math.floor(duration / 3600);
        var minutes = Math.floor((duration % 3600) / 60);
        var seconds = Math.floor(duration % 60);
        if (minutes < 10)
            minutes = "0" + minutes;
        return hours + ":" + minutes;
    }

    function timestampToReadable(timestamp) {
        return Moment.moment.unix(timestamp).calendar();
    }

    // On new trip data (save clicked), switch index to new trip
    Connections {
        target: tripdata
        onTripDataSaved: tripView.setCurrentIndex(index)
    }

    RoundButton {
        id: endTrip
        width: UILayout.statsEndtripWidth
        height: UILayout.statsEndtripHeight
        radius: height / 2
        anchors {
            horizontalCenter: parent.horizontalCenter
            top: parent.top
            topMargin: UILayout.statsEndtripMargin
        }

        background: Rectangle {
            anchors.fill: parent
            color: parent.down ? Colors.statsButtonPressed : "transparent"
            radius: parent.radius
            border.color: Colors.statsButtonActive
            border.width: parent.down ? 0 : 1
        }

        contentItem: Text {
            color: Colors.statsButtonActiveText
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            text: qsTr("END TRIP")
            font {
                family: "Montserrat, Medium"
                weight: Font.Medium
                pixelSize: UILayout.statsEndtripTextSize
            }
        }
        visible: tripView.currentIndex === 0
        onClicked: tripdata.endTrip()
    }

    Text {
        id: tripDateText
        anchors {
            horizontalCenter: parent.horizontalCenter
            verticalCenter: parent.top
            verticalCenterOffset: UILayout.statsEndtripMargin + UILayout.statsEndtripHeight / 2
        }
        color: Colors.statsButtonActiveText
        text: qsTr("YESTERDAY")
        font {
            family: "Montserrat, Medium"
            weight: Font.Medium
            pixelSize: UILayout.statsEndtripTextSize
        }
        visible: tripView.currentIndex > 0
    }

    RoundButton {
        id: previousChart
        width: UILayout.statsTripButtonWidth
        height: UILayout.statsTripButtonHeight
        radius: height / 2
        anchors {
            left: parent.left
            top: endTrip.top
            leftMargin: UILayout.statsTripButtonMarginSide
        }
        enabled: tripView.currentIndex > 0

        background: Rectangle {
            anchors.fill: parent
            color: parent.down ? Colors.statsButtonPressed : "transparent"
            radius: parent.radius
            border.color: enabled ? Colors.statsButtonActive : Colors.statsButtonInactive
            border.width: parent.down ? 0 : 1
        }

        contentItem: Item {}
        Image {
            anchors.centerIn: parent
            source: "images/arrow_left.png"
            opacity: parent.enabled ? 1.0 : 0.3
        }

        onClicked: tripView.decrementCurrentIndex()
    }

    RoundButton {
        id: nextChart
        width: UILayout.statsTripButtonWidth
        height: UILayout.statsTripButtonHeight
        radius: height / 2
        anchors {
            right: parent.right
            top: endTrip.top
            rightMargin: UILayout.statsTripButtonMarginSide
        }
        enabled: tripView.currentIndex < tripView.count - 1

        background: Rectangle {
            anchors.fill: parent
            color: parent.down ? Colors.statsButtonPressed : "transparent"
            radius: parent.radius
            border.color: enabled ? Colors.statsButtonActive : Colors.statsButtonInactive
            border.width: parent.down ? 0 : 1
        }

        contentItem: Item {}
        Image {
            anchors.centerIn: parent
            source: "images/arrow_right.png"
            opacity: parent.enabled ? 1.0 : 0.3
        }

        onClicked: tripView.incrementCurrentIndex()
    }

    // Odometer
    Item {
        width: odometerText.width + odometerUnit.width + odometerDescription.width + 2 * 4
        anchors {
            right: parent.right
            bottom: parent.top
            rightMargin: UILayout.statsOdometerMarginRight
            bottomMargin: -UILayout.statsOdometerBaselineOffset
        }

        Text {
            id: odometerDescription
            anchors.right: odometerText.left
            anchors.rightMargin: 4
            anchors.baseline: parent.bottom
            color: Colors.statsDescriptionText
            text: qsTr("Total")
            font {
                family: "Montserrat, Light"
                weight: Font.Light
                pixelSize: UILayout.statsDescriptionTextSize
            }
        }

        Text {
            id: odometerText
            anchors.right: odometerUnit.left
            anchors.rightMargin: 4
            anchors.baseline: parent.bottom
            color: Colors.statsValueText
            text: datastore.odometer.toFixed(1)
            font {
                family: "Montserrat, Bold"
                weight: Font.Bold
                pixelSize: UILayout.statsValueTextSize
            }
        }

        Text {
            id: odometerUnit
            anchors.right: parent.right
            anchors.baseline: parent.bottom
            color: Colors.statsDescriptionText
            text: datastore.unit === DataStore.Kmh ? qsTr("km") : qsTr("mi.")
            font {
                family: "Montserrat, Light"
                weight: Font.Light
                pixelSize: UILayout.statsDescriptionTextSize
            }
        }
    }

    SwipeView {
        id: tripView
        anchors {
            left: parent.left
            right: parent.right
            top: endTrip.bottom
            bottom: tripChart.top
            leftMargin: UILayout.statsTripButtonMarginSide
            rightMargin: UILayout.statsTripButtonMarginSide
            topMargin: UILayout.statsTopMargin
        }
        // Hide any excess content, since we are using margins
        clip: true

        // Load data on first show
        Component.onCompleted: tripdata.refresh()

        onCurrentIndexChanged: tripDateText.text = timestampToReadable(tripdata.get(currentIndex).starttime)

        Repeater {
            model: tripdata

            Column {
                width: tripView.width
                height: tripView.height

                ColumnSpacer {
                    color: Colors.statsSeparator
                }

                StatsRow {
                    leftTitle: qsTr("Duration (h:m)")
                    leftValue: splitDuration(duration)
                    rightTitle: datastore.unit === DataStore.Kmh ? qsTr("Max. speed (km/h)") : qsTr("Max. speed (mph)")
                    rightValue: maxspeed.toFixed(1)
                }

                ColumnSpacer {
                    color: Colors.statsSeparator
                }

                StatsRow {
                    leftTitle: datastore.unit === DataStore.Kmh ? qsTr("Distance (km)") : qsTr("Distance (mi.)")
                    leftValue: distance.toFixed(1)
                    rightTitle: datastore.unit === DataStore.Kmh ? qsTr("Avg. speed (km/h)") : qsTr("Avg. speed (mph)")
                    rightValue: avgspeed.toFixed(1)
                }

                ColumnSpacer {
                    color: Colors.statsSeparator
                }

                StatsRow {
                    leftTitle: qsTr("Calories (kcal)")
                    leftValue: calories.toFixed(1)
                    rightTitle: qsTr("Ascent (m)")
                    rightValue: ascent.toFixed(1)
                }

                ColumnSpacer {
                    color: Colors.statsSeparator
                }
            }
        }
    }

    TripChart {
        id: tripChart
        width: UILayout.chartWidth
        height: UILayout.chartHeight
        anchors {
            bottom: parent.bottom
            right: parent.right
            bottomMargin: UILayout.chartBottomMargin
            rightMargin: UILayout.chartRightMargin
        }
        animationRunning: tripView.currentIndex === 0
        tripDetails: tripdata.get(currentIndex)
        currentIndex: tripView.currentIndex
    }
}
