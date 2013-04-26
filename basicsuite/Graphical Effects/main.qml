import QtQuick 2.0

Item {
    id: root

    width: 1280
    height: 720

    Checkers {
        id: checkers;
        anchors.fill: parent
        anchors.leftMargin: list.width
        tileSize: 32
    }

    Loader {
        id: loader
        anchors.fill: checkers;
    }

    Rectangle {
        id: listBackground
        anchors.left: parent.left
        anchors.right: checkers.left
        anchors.top: parent.top
        anchors.bottom: parent.bottom
        color: "black"
    }

    ListModel {
        id: listModel
        ListElement { name: "Brignthness / Contrast"; file: "effect_BrightnessContrast.qml" }
        ListElement { name: "Colorize"; file: "effect_Colorize.qml" }
        ListElement { name: "Displacement"; file: "effect_Displacement.qml" }
        ListElement { name: "Drop Shadow"; file: "effect_DropShadow.qml" }
        ListElement { name: "Gaussian Blur"; file: "effect_GaussianBlur.qml" }
        ListElement { name: "Glow"; file: "effect_Glow.qml" }
        ListElement { name: "Hue / Saturation"; file: "effect_HueSaturation.qml" }
        ListElement { name: "Opacity Mask"; file: "effect_OpacityMask.qml" }
        ListElement { name: "Threshold Mask"; file: "effect_ThresholdMask.qml" }
        ListElement { name: "Custom"; file: "effect_CustomWave.qml" }
    }

    ListView
    {
        id: list
        anchors.top: parent.top
        anchors.left: parent.left
        width: parent.width / 4
        height: parent.height - width

        clip: true
        focus: true

        highlightMoveDuration: 0

        onCurrentItemChanged: {
            var entry = listModel.get(currentIndex);
            loader.source = entry.file;
        }

        model: listModel

        highlight: Rectangle {
            color: "steelblue"
        }

        delegate: Item {
            id: delegateRoot

            width: list.width
            height: root.height * 0.05

            Rectangle {
                width: parent.width
                height: 3
                anchors.bottom: parent.bottom
                gradient: Gradient {
                    GradientStop { position: 0; color: "transparent" }
                    GradientStop { position: 0.5; color: "lightgray" }
                    GradientStop { position: 1; color: "transparent" }
                }
            }

            Text {
                color: "white"
                font.pixelSize: parent.height * 0.5
                anchors.verticalCenter: parent.verticalCenter
                anchors.verticalCenterOffset: -2
                x: parent.width * 0.1
                text: name
            }

            MouseArea {
                anchors.fill: parent
                onClicked: list.currentIndex = index;
            }
        }
    }

    Canvas {
        id: canvas
        anchors.fill: controller
        anchors.margins: 10

        property real padding: 20

        onPaint: {
            print("painting the canvas...");
            var ctx = canvas.getContext("2d");

            var w = canvas.width
            var h = canvas.height;


            ctx.fillStyle = "rgb(50, 50, 50)"
            ctx.beginPath();
            ctx.roundedRect(0, 0, w, h, w * 0.1, w * 0.1);
            ctx.fill();

            var margin = canvas.padding;
            var segmentSize = 4
            ctx.strokeStyle = "gray"
            ctx.beginPath();
            ctx.moveTo(margin, margin);
            ctx.lineTo(margin, h-margin);
            ctx.moveTo(margin, h - margin);
            ctx.lineTo(w-margin, h - margin);

            var segmentCount = 11
            for (var i = 0; i<segmentCount; ++i) {
                var offset = margin + i * (w - margin * 2) / (segmentCount - 1);
                ctx.moveTo(margin - segmentSize, offset);
                ctx.lineTo(margin + segmentSize, offset);
                ctx.moveTo(offset, h - margin - segmentSize);
                ctx.lineTo(offset, h - margin + segmentSize);
            }

            ctx.stroke();
        }
    }

    Text {
        id: labelX
        anchors.bottom: canvas.bottom
        x: canvas.width * 0.4
        anchors.bottomMargin: 2
        text: (loader.item != undefined && typeof loader.item.nameX != 'undefined' ? loader.item.nameX : "")
              + (loader.item != undefined && typeof loader.item.feedbackX != 'undefined' ? ": " + loader.item.feedbackX.toFixed(2) : "");

        color: "white"
        font.pixelSize: canvas.padding * 0.5
    }

    Text {
        id: labelY

        anchors.verticalCenter: canvas.verticalCenter
        anchors.verticalCenterOffset: canvas.height * 0.15
        anchors.left: canvas.left
        transformOrigin: Item.TopLeft
        rotation: -90
        text: (loader.item != undefined && typeof loader.item.nameY != 'undefined' ? loader.item.nameY : "")
              + (loader.item != undefined && typeof loader.item.feedbackY != 'undefined' ? ": " + loader.item.feedbackY.toFixed(2) : "");
        color: "white"
        font.pixelSize: canvas.padding * 0.5
    }

    MouseArea {
        id: controller

        anchors.top: list.bottom;
        anchors.left: parent.left
        anchors.right: checkers.left
        anchors.bottom: parent.bottom;

        onPositionChanged: {
            var effect = loader.item;
            function bound(val) { return Math.max(0, Math.min(1, val)); }
            if (effect != undefined) {
                if (typeof effect.inputX != 'undefined')
                    effect.inputX = bound(mouseX / controller.width);
                if (typeof effect.inputY != 'undefined')
                    effect.inputY = bound(1 - mouseY / controller.height);
            }
        }

    }


}