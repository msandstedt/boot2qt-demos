/****************************************************************************
**
** Copyright (C) 2012 Digia Plc and/or its subsidiary(-ies).
** Contact: http://www.qt-project.org/legal
**
** This file is part of the Qt Mobility Components.
**
** $QT_BEGIN_LICENSE:LGPL$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and Digia.  For licensing terms and
** conditions see http://qt.digia.com/licensing.  For further information
** use the contact form at http://qt.digia.com/contact-us.
**
** GNU Lesser General Public License Usage
** Alternatively, this file may be used under the terms of the GNU Lesser
** General Public License version 2.1 as published by the Free Software
** Foundation and appearing in the file LICENSE.LGPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU Lesser General Public License version 2.1 requirements
** will be met: http://www.gnu.org/licenses/old-licenses/lgpl-2.1.html.
**
** In addition, as a special exception, Digia gives you certain additional
** rights.  These rights are described in the Digia Qt LGPL Exception
** version 1.1, included in the file LGPL_EXCEPTION.txt in this package.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3.0 as published by the Free Software
** Foundation and appearing in the file LICENSE.GPL included in the
** packaging of this file.  Please review the following information to
** ensure the GNU General Public License version 3.0 requirements will be
** met: http://www.gnu.org/copyleft/gpl.html.
**
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick 2.0
import QtMultimedia 5.0

FocusScope {
    id: applicationWindow
    focus: true

    MouseArea {
        id: mouseActivityMonitor
        anchors.fill: parent

        hoverEnabled: true
        onClicked: {
            if (controlBar.state === "VISIBLE" && content.videoPlayer.mediaPlayer.status === MediaPlayer.Loaded) {
                controlBar.hide();
            } else {
                controlBar.show();
                controlBarTimer.restart();
            }
        }
    }

    signal resetTimer
    onResetTimer: {
        controlBar.show();
        controlBarTimer.restart();
    }

    Component.onCompleted: {
        init();
    }

    Content {
        id: content
        anchors.fill: parent
    }

    Timer {
        id: controlBarTimer
        interval: 4000
        running: false

        onTriggered: {
            hideToolBars();
        }
    }

    ControlBar {
        id: controlBar
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: applicationWindow.bottom
        mediaPlayer: content.videoPlayer.mediaPlayer

        onOpenFile: {
            applicationWindow.openVideo();
        }

        onOpenURL: {
            applicationWindow.openURL();
        }

        onOpenFX: {
            applicationWindow.openFX();
        }

        onToggleFullScreen: {
//            viewer.toggleFullscreen();
        }
    }

    ParameterPanel {
        id: parameterPanel
        opacity: controlBar.opacity
        visible: effectSelectionPanel.visible && model.count !== 0
        height: 116
        width: 500
        anchors {
            bottomMargin: 15
            bottom: controlBar.top
            right: effectSelectionPanel.left
            rightMargin: 15
        }
    }

    EffectSelectionPanel {
        id: effectSelectionPanel
        visible: false
        opacity: controlBar.opacity
        anchors {
            bottom: controlBar.top
            right: controlBar.right
            //            rightMargin: 15
            bottomMargin: 15
        }
        width: 250
        height: 350
        itemHeight: 80
        onEffectSourceChanged: {
            content.effectSource = effectSource
            parameterPanel.model = content.effect.parameters
        }
    }

    UrlBar {
        id: urlBar
        opacity: 0
        visible: opacity != 0
        anchors.fill: parent
        onUrlAccepted: {
            urlBar.opacity = 0;
            if (text != "")
                content.openVideo(text)
        }
    }

    Rectangle {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 32
        anchors.topMargin: 32
        width: 40
        height: 40
        radius: width / 2
        color: infoMouser.pressed ? "#BB999999" : "#88444444"
        antialiasing: true
        visible: content.videoPlayer.mediaPlayer.status !== MediaPlayer.NoMedia && controlBar.state === "VISIBLE"

        Text {
            anchors.centerIn: parent
            text: "i"
            font.italic: true
            font.bold: true
            color: "white"
            font.pixelSize: 28
        }

        MouseArea {
            id: infoMouser
            anchors.fill: parent
            anchors.margins: -10
            onClicked: metadataView.opacity = 1
        }
    }

    MetadataView {
        id: metadataView
        mediaPlayer: content.videoPlayer.mediaPlayer
    }

    property real volumeBeforeMuted: 1.0
    property bool isFullScreen: false

    FileBrowser {
        id: fileBrowser
        anchors.fill: parent
        onFileSelected: {
            if (file != "")
                content.openVideo(file);
        }
    }

    Keys.onPressed: {
        applicationWindow.resetTimer();
        if (event.key === Qt.Key_O && event.modifiers & Qt.ControlModifier) {
            openVideo();
            return;
        } else if (event.key === Qt.Key_N && event.modifiers & Qt.ControlModifier) {
            openURL();
            return;
        } else if (event.key === Qt.Key_E && event.modifiers & Qt.ControlModifier) {
            openFX();
            return;
        } else if (event.key === Qt.Key_F && event.modifiers & Qt.ControlModifier) {
//            viewer.toggleFullscreen();
            return;
        } else if (event.key === Qt.Key_Up || event.key === Qt.Key_VolumeUp) {
            content.videoPlayer.mediaPlayer.volume = Math.min(1, content.videoPlayer.mediaPlayer.volume + 0.1);
            return;
        } else if (event.key === Qt.Key_Down || event.key === Qt.Key_VolumeDown) {
            if (event.modifiers & Qt.ControlModifier) {
                if (content.videoPlayer.mediaPlayer.volume) {
                    volumeBeforeMuted = content.videoPlayer.mediaPlayer.volume;
                    content.videoPlayer.mediaPlayer.volume = 0
                } else {
                    content.videoPlayer.mediaPlayer.volume = volumeBeforeMuted;
                }
            } else {
                content.videoPlayer.mediaPlayer.volume = Math.max(0, content.videoPlayer.mediaPlayer.volume - 0.1);
            }
            return;
        } else if (applicationWindow.isFullScreen && event.key === Qt.Key_Escape) {
//            viewer.toggleFullscreen();
            return;
        }

        // What's next should be handled only if there's a loaded media
        if (content.videoPlayer.mediaPlayer.status !== MediaPlayer.Loaded
                && content.videoPlayer.mediaPlayer.status !== MediaPlayer.Buffered)
            return;

        if (event.key === Qt.Key_Space) {
            if (content.videoPlayer.mediaPlayer.playbackState === MediaPlayer.PlayingState)
                content.videoPlayer.mediaPlayer.pause()
            else if (content.videoPlayer.mediaPlayer.playbackState === MediaPlayer.PausedState
                     || content.videoPlayer.mediaPlayer.playbackState === MediaPlayer.StoppedState)
                content.videoPlayer.mediaPlayer.play()
        } else if (event.key === Qt.Key_Left) {
            content.videoPlayer.mediaPlayer.seek(Math.max(0, content.videoPlayer.mediaPlayer.position - 30000));
            return;
        } else if (event.key === Qt.Key_Right) {
            content.videoPlayer.mediaPlayer.seek(Math.min(content.videoPlayer.mediaPlayer.duration, content.videoPlayer.mediaPlayer.position + 30000));
            return;
        }
    }

    function init() {
        content.init()
    }

    function openVideo() {
        //videoFileBrowser.show()
        //        var videoFile = viewer.openFileDialog();
        //        if (videoFile != "")
        //            content.openVideo(videoFile);
        fileBrowser.show()
    }

    function openCamera() {
        content.openCamera()
    }

    function openURL() {
        urlBar.opacity = urlBar.opacity === 0 ? 1 : 0
    }

    function openFX() {
        effectSelectionPanel.visible = !effectSelectionPanel.visible;
    }

    function close() {
    }

    function hideToolBars() {
        if (!controlBar.isMouseAbove && !parameterPanel.isMouseAbove && !effectSelectionPanel.isMouseAbove && content.videoPlayer.isPlaying)
            controlBar.hide();
    }
}