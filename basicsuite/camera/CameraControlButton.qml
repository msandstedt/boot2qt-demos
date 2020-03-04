/****************************************************************************
**
** Copyright (C) 2016 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of Qt for Device Creation.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
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
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
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

MouseArea {
    id: buttonRoot
    property alias title: titleTxt.text
    property alias subtitle: valueTxt.text
    property bool toggled: false

    width: 78 * root.contentScale
    height: 78 * root.contentScale
    opacity: pressed ? 0.3 : 1.0
    rotation: root.contentRotation
    Behavior on rotation { NumberAnimation { } }

    Rectangle {
        anchors.fill: parent
        color: toggled ? "#8898c66c" : "#77333333"
        radius: 5 * root.contentScale
    }

    Column {
        id: expModeControls
        spacing: 2 * root.contentScale
        anchors.centerIn: parent

        Text {
            id: titleTxt
            anchors.horizontalCenter: expModeControls.horizontalCenter
            font.pixelSize: 22 * root.contentScale
            font.letterSpacing: -1
            color: "white"
            font.bold: true
        }

        Text {
            id: valueTxt
            anchors.horizontalCenter: expModeControls.horizontalCenter
            height: 22 * root.contentScale
            verticalAlignment: Text.AlignVCenter
            color: "white"

            Connections {
                target: root
                function onContentScaleChanged() { valueTxt.font.pixelSize = Math.round(18 * root.contentScale) }
            }

            onTextChanged: font.pixelSize = Math.round(18 * root.contentScale)
            onPaintedWidthChanged: {
                if (paintedWidth > buttonRoot.width - (8 * root.contentScale))
                    font.pixelSize -= Math.round(2 * root.contentScale);
            }
        }
    }
}
