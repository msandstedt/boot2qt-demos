/****************************************************************************
**
** Copyright (C) 2014 Digia Plc and/or its subsidiary(-ies).
** Contact: For any questions to Digia, please use the contact form at
** http://www.qt.io
**
** This file is part of the examples of the Qt Enterprise Embedded.
**
** $QT_BEGIN_LICENSE:BSD$
** You may use this file under the terms of the BSD license as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of Digia Plc and its Subsidiary(-ies) nor the names
**     of its contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/
import QtQuick 2.0
import QtSensors 5.0
import QtSensors 5.0 as Sensors

Rectangle {
    id: root
    anchors.fill: parent

    Component {
        id: sensorExample
        Rectangle {
            id: main
            width: root.width
            height: root.height
            anchors.centerIn: parent
            color: "blue"
            border.width: 1
            Accelbubble {
                id: bubble
                width: parent.width / 2
                height: parent.height
            }
            Light {
                anchors.left: bubble.right
                width: parent.width / 2
                height: parent.height
            }

        }
    }

    Component {
        id: message
        Rectangle {
            width: root.width
            height: root.height
            color: "black"
            Text {
                font.pixelSize: 80
                width: parent.width * 0.8
                anchors.centerIn: parent
                color: "white"
                text: "It appears that this device doesn't provide the required sensors!"
                wrapMode: Text.WordWrap
            }
        }
    }

    Loader {
        id: pageLoader
        anchors.centerIn: parent
    }

    Component.onCompleted: {
        var typesList = Sensors.QmlSensors.sensorTypes();
        var count = 0
        for (var i = 0; i < typesList.length; ++i) {
            if (typesList[i] == "QAccelerometer")
                count++
            if (typesList[i] == "QLightSensor")
                count++
        }

        if (count > 1)
            pageLoader.sourceComponent = sensorExample
        else
            pageLoader.sourceComponent = message
    }
}
