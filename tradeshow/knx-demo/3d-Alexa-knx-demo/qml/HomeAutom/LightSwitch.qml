/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Qt 3D Studio Demos.
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

import QtQuick 2.8
import QtQuick.Controls 2.3
import Style 1.0

Item {
    id: lightSwitch
    property real value: control.checked ? 1.0 : 0.0
    property real lightValue: control.position
    property real currentValue: lightValue.toFixed(1)
    property real lightNum: 0

    width: sizesMap.controlHeight * 2
    height: sizesMap.controlHeight + sliderText.height
    function updateLight(state) {
        control.checked = state
    }

    Text {
        id: sliderText
        anchors.bottom: control.top
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: sizesMap.fontSize
        color: Style.textColor
        font.bold: true
        style: Text.Outline
        styleColor: Style.sliderBackgroundColor
    }

    Switch {
        id: control
        width: lightSwitch.width
        height: sizesMap.controlHeight

        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: sizesMap.controlMargin / 2
        onClicked: {
            console.log('Clicked on ligth!'+ lightNum)
            knxBackend.toggleLight(lightNum)
        }
        indicator: Rectangle {
            implicitWidth: sizesMap.controlHeight * 2
            implicitHeight: sizesMap.controlHeight
            x: control.leftPadding
            y: control.topPadding + control.availableHeight / 2 - height / 2
            radius: height / 2
            color: control.checked ? Style.sliderSelectionColor : Style.sliderBackgroundColor
            border.color: Style.backgroundColor
            border.width: sizesMap.controlBorderWidth
            opacity: control.enabled ? 1 : 0.3

            Rectangle {
                x: control.checked ? parent.width - width : 0
                width: sizesMap.controlHeight
                height: sizesMap.controlHeight
                radius: height / 2
                antialiasing: true
                color: Style.backgroundColor
                opacity: control.enabled ? 1 : 0.3
                Image {
                    id: handleItemIcon
                    anchors.fill: parent
                    fillMode: Image.PreserveAspectFit
                    anchors.margins: sizesMap.controlMargin / 2
                    anchors.centerIn: parent
                    source: "qml/images/icon_light.png"
                }
            }
        }
    }
}
