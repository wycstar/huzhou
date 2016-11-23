import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0

ApplicationWindow{
    id:main
    x:Screen.desktopAvailableWidth / 2 - width / 2
    y:Screen.desktopAvailableHeight / 2 - height / 2
    width:1320;
    height:550;
    color: "#00000000";
    visible:true;
    opacity: 0.0
    flags:Qt.FramelessWindowHint | Qt.WA_TranslucentBackground;
    property string mainColor: "#5fb2ff"
    property var powerWindowObject
    property bool isAllGraphStarted:false
    property bool isGraphPause:false
    property int captionHeight: 50
    property double fontScale: 1.6

    signal closeApplication()

    Rectangle{
        id: mainDockTipWrap
        width: main.width
        height: captionHeight
        color: "#00000000"
        property int topMargin: 5
        Rectangle{
            id:hyPowerDockTipWrap
            x: hyPowerDock.x + hyPowerDock.width / 2 - width / 2
            visible:false
            color: "#88000000"
            width: hyRemainDock.width
            height: captionHeight - mainDockTipWrap.topMargin
            radius: 8
            Text{
                anchors.centerIn: hyPowerDockTipWrap
                text: "燃料电池状态仪表"
                font.bold: true
                font.family: "微软雅黑"
                font.pixelSize: 20
                color: "white"
            }
        }
        Rectangle{
            id:liPowerDockTipWrap
            x: liPowerDock.x + liPowerDock.width / 2 - width / 2
            visible:false
            color: "#88000000"
            width: hyRemainDock.width
            height: captionHeight - mainDockTipWrap.topMargin
            radius: 8
            Text{
                anchors.centerIn: liPowerDockTipWrap
                text: "锂电池状态仪表"
                font.bold: true
                font.family: "微软雅黑"
                font.pixelSize: 20
                color: "white"
            }
        }
    }

    //氢气剩余仪表
    Image{
        id:hyRemainDock
        x:0;
        y:hyPowerDock.height * 0.8 - height + captionHeight;
        width:200
        height: 200
        source: "resource/pic/hyremain.png"
        Image{
            id:hyRemainGraphIcon
            source: "resource/pic/gas.png"
            x:hyRemainDock.width / 2 - width / 2
            y:hyRemainIncicator.y + hyRemainIncicator.height + 10
            height:40
            width: 40
        }
        Text{
            id:hyRemainIncicator
            x:hyRemainDock.width / 2 - width / 2
            y:120
            color:"white"
            text:"0MPa"
            font.family: lcdFont.name
            font.bold: true
            font.pointSize: 10 * fontScale
        }
        Rectangle{
            id:hyRemainPointerWrapper
            width:hyRemainDock.width
            height:hyRemainDock.height
            color:Qt.rgba(0, 0, 0, 0)
            property int pointerAngle: -30
            Canvas{
                id:hyRemainPointer
                width:hyRemainDock.width
                height:hyRemainDock.height
                property int pointerRadius: 4
                property int pointerStart: 20
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.save();
                    ctx.clearRect(0, 0, hyRemainDock.width, hyRemainDock.height);
                    ctx.beginPath();
                    ctx.lineWidth = 1;
                    ctx.strokeStyle = main.mainColor;
                    ctx.fillStyle = main.mainColor;
                    ctx.moveTo(hyRemainPointer.pointerStart, hyRemainDock.height / 2);
                    ctx.lineTo(hyRemainDock.width / 2, hyRemainDock.height / 2 - hyRemainPointer.pointerRadius);
                    ctx.arc(hyRemainDock.width / 2,
                            hyRemainDock.height / 2,
                            hyRemainPointer.pointerRadius,
                            -Math.PI / 2,
                            Math.PI / 2);
                    ctx.lineTo(hyRemainPointer.pointerStart, hyRemainDock.height / 2);
                    ctx.closePath()
                    ctx.fill()
                    ctx.stroke();}
            }
            transform: Rotation{origin.x: hyRemainPointerWrapper.width / 2;
                                origin.y: hyRemainPointerWrapper.height / 2;
                                angle: hyRemainPointerWrapper.pointerAngle}
        }
    }
    //氢气仪表
    Image{
        id:hyPowerDock
        x:hyRemainDock.width * 0.9;
        y: captionHeight;
        width:500
        height: 500
        source: "resource/pic/hy.png"
        Image{
            id:hyPowerGraphIcon
            source: "resource/pic/wave.png"
            x:hyPowerDock.width / 2 - width / 2
            y:hyPowerIncicator.y + hyPowerIncicator.height + 30
            height:60
            width: 120
            MouseArea{
                anchors.fill: parent
                onClicked: {var component = Qt.createComponent("powerGraph.qml");
                            if(component.status == Component.Ready){
                                powerWindowObject = component.createObject(main)
                                powerWindowObject.visible = true
                                powerWindowObject.pauseGraph.connect(pauseGraph)
                                isAllGraphStarted = true}}
            }
        }
        Text{
            id:hyPowerIncicator
            x:hyPowerDock.width / 2 - width / 2
            y:330
            color:"white"
            text:"0W"
            font.family: lcdFont.name
            font.bold: true
            font.pointSize: 20 * fontScale
        }
        Rectangle{
            id:hyPowerPointerWrapper
            width:500
            height:500
            color:Qt.rgba(0, 0, 0, 0)
            property int pointerAngle: -30
            Canvas{
                id:hyPowerPointer
                width:500
                height:500
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.save();
                    ctx.clearRect(0, 0, hyPowerDock.width, hyPowerDock.height);
                    ctx.beginPath();
                    ctx.lineWidth = 1;
                    ctx.strokeStyle = main.mainColor;
                    ctx.fillStyle = main.mainColor;
                    ctx.moveTo(50, hyPowerDock.height / 2);
                    ctx.lineTo(hyPowerDock.width / 2, hyPowerDock.height / 2 - 10);
                    ctx.arc(hyPowerDock.width / 2,
                            hyPowerDock.height / 2,
                            10,
                            -Math.PI / 2,
                            Math.PI / 2);
                    ctx.lineTo(50, hyPowerDock.height / 2);
                    ctx.closePath()
                    ctx.fill()
                    ctx.stroke();}
            }
            transform: Rotation{origin.x: hyPowerPointerWrapper.width / 2;
                                origin.y: hyPowerPointerWrapper.height / 2;
                                angle: hyPowerPointerWrapper.pointerAngle}
        }
        MouseArea{
            anchors.fill: hyPowerDock
            cursorShape:Qt.PointingHandCursor
            propagateComposedEvents: true
            hoverEnabled: true
            onEntered: {hyPowerDockTipWrap.visible = true}
            onExited: {hyPowerDockTipWrap.visible = false}
        }
    }
    //锂电池仪表
    Image{
        id:liPowerDock
        x:hyPowerDock.x + width * 0.9;
        y:captionHeight;
        width:500
        height: 500
        source: "resource/pic/li.png"
        Image{
            id:liPowerGrapthIcon
            source: "resource/pic/wave.png"
            x:liPowerDock.width / 2 - width / 2
            y:liPowerIncicator.y + liPowerIncicator.height + 30
            height:60
            width: 120
        }
        Text{
            id:liPowerIncicator
            x:liPowerDock.width / 2 - width / 2
            y:330
            color:"white"
            text:"0W"
            font.family: lcdFont.name
            font.bold: true
            font.pointSize: 20 * fontScale
        }
        Rectangle{
            id:liPowerPointerWrapper
            width:500
            height:500
            color:Qt.rgba(0, 0, 0, 0)
            property int pointerAngle: -30
            Canvas{
                id:liPowerPointer
                width:500
                height:500
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.save();
                    ctx.clearRect(0, 0, liPowerDock.width, liPowerDock.height);
                    ctx.beginPath();
                    ctx.lineWidth = 1;
                    ctx.strokeStyle = main.mainColor;
                    ctx.fillStyle = main.mainColor;
                    ctx.moveTo(50, liPowerDock.height / 2);
                    ctx.lineTo(liPowerDock.width / 2, liPowerDock.height / 2 - 10);
                    ctx.arc(liPowerDock.width / 2,
                            liPowerDock.height / 2,
                            10,
                            -Math.PI / 2,
                            Math.PI / 2);
                    ctx.lineTo(50, liPowerDock.height / 2);
                    ctx.closePath()
                    ctx.fill()
                    ctx.stroke();}
            }
            transform: Rotation{origin.x: liPowerPointerWrapper.width / 2;
                                origin.y: liPowerPointerWrapper.height / 2;
                                angle: liPowerPointerWrapper.pointerAngle}
        }
        MouseArea{
            anchors.fill: liPowerDock
            cursorShape:Qt.PointingHandCursor
            propagateComposedEvents: true
            hoverEnabled: true
            onEntered: {liPowerDockTipWrap.visible = true}
            onExited: {liPowerDockTipWrap.visible = false}
        }
    }
    //锂电池剩余仪表
    Image{
        id:liRemainDock
        x:liPowerDock.x + liPowerDock.width - liRemainDock.width * 0.1;
        y:hyRemainDock.y;
        z:-1
        width:200
        height: 200
        source: "resource/pic/liremain.png"
        Image{
            id:liRemainGraphIcon
            source: "resource/pic/battery.png"
            x:liRemainDock.width / 2 - width / 2
            y:liRemainIncicator.y + liRemainIncicator.height + 10
            height:40
            width: 20
        }
        Text{
            id:liRemainIncicator
            x:liRemainDock.width / 2 - width / 2
            y:120
            color:"white"
            text:String(0) + "V"
            font.family: lcdFont.name
            font.bold: true
            font.pointSize: 10 * fontScale
        }
        Rectangle{
            id:liRemainPointerWrapper
            width:liRemainDock.width
            height:liRemainDock.height
            color:Qt.rgba(0, 0, 0, 0)
            property int pointerAngle: -30
            Canvas{
                id:liRemainPointer
                width:liRemainDock.width
                height:liRemainDock.height
                property int pointerRadius: 4
                property int pointerStart: 20
                onPaint: {
                    var ctx = getContext("2d");
                    ctx.save();
                    ctx.clearRect(0, 0, liRemainDock.width, liRemainDock.height);
                    ctx.beginPath();
                    ctx.lineWidth = 1;
                    ctx.strokeStyle = main.mainColor;
                    ctx.fillStyle = main.mainColor;
                    ctx.moveTo(liRemainPointer.pointerStart, liRemainDock.height / 2);
                    ctx.lineTo(liRemainDock.width / 2, liRemainDock.height / 2 - liRemainPointer.pointerRadius);
                    ctx.arc(liRemainDock.width / 2,
                            liRemainDock.height / 2,
                            liRemainPointer.pointerRadius,
                            -Math.PI / 2,
                            Math.PI / 2);
                    ctx.lineTo(liRemainPointer.pointerStart, liRemainDock.height / 2);
                    ctx.closePath()
                    ctx.fill()
                    ctx.stroke();}
            }
            transform: Rotation{origin.x: liRemainPointerWrapper.width / 2;
                                origin.y: liRemainPointerWrapper.height / 2;
                                angle: liRemainPointerWrapper.pointerAngle}
        }
    }
    //关闭按钮等
    Rectangle{
        id:caption
        property int buttonWidth: 40
        property string closeColor: "#CC3333"
        x:main.width - width
        y:0
        width:2 * buttonWidth
        height:40
        color:"#00000000"
        Rectangle{
            id:closeButton
            x:caption.buttonWidth
            width: caption.buttonWidth
            height: 40
            color:"#00000000"
            Text{
                id:closeButtonText
                anchors.centerIn: parent
                text:"X"
                color:main.mainColor
                font.bold: false
                font.pixelSize: 19
                font.family: "微软雅黑"
            }
            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {main.close()
                            closeApplication()}
                onEntered: closeButtonText.color = caption.closeColor
                onExited: closeButtonText.color = main.mainColor
            }
        }
        Rectangle{
            id:minimumButton
            x:0
            width: caption.buttonWidth
            height: 40
            color:"#00000000"
            Text{
                id:minimumButtonText
                anchors.centerIn: parent
                text:"一"
                color:main.mainColor
                font.bold: false
                font.pixelSize: 19
                font.family: "微软雅黑"
            }
            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {main.lower()}
                onEntered: minimumButtonText.color = caption.closeColor
                onExited: minimumButtonText.color = main.mainColor
            }
        }
    }
    MouseArea{
        property variant mousePoint: "0,0"
        anchors.fill: parent
        cursorShape:Qt.PointingHandCursor
        propagateComposedEvents: true
        onClicked: {mouse.accepted = false}
        onPositionChanged: {
            var delta = Qt.point(mouse.x-mousePoint.x, mouse.y-mousePoint.y)
            main.x += delta.x
            main.y += delta.y}
        onPressed: {
            mousePoint = Qt.point(mouse.x,mouse.y)}
    }
    Timer{
        id:mainOpacityTimer
        running: true
        interval: 100
        repeat: true
        property var tempOpacity:0
        onTriggered: {if(tempOpacity <= 1.0){
                          tempOpacity += 0.08
                          tempOpacity = (tempOpacity > 1.0 ? 1.0 : tempOpacity)
                          main.opacity = tempOpacity}
                      else{
                          main.opacity = 1.0
                          mainOpacityTimer.stop()}}
    }
    //测试区域
    Timer{
        id:hyPowerPointerWrapperTimer
        interval: 1
        running: false
        repeat: true
        onTriggered: {
            hyPowerPointerWrapper.pointerAngle += 1;
            liPowerPointerWrapper.pointerAngle += 1;
        }}
    FontLoader{
        id: lcdFont
        source: "./resource/font/LCD.ttf"
    }
    //函数
    property int hyPower: 0
    property int liPower: 0
    property double hyRemain: 0
    property double liRemain: 0
    function setAllChartData(seriesData, pointData)
    {
        hyPower = pointData["HyPower"]
        liPower = pointData["LiPower"]
        hyRemain = pointData["HyPress"]
        liRemain = pointData["LiVolt"]
        if(isAllGraphStarted){
            powerWindowObject.setChartData(seriesData["HyPower"], seriesData["LiPower"], seriesData["AllPower"], seriesData["x"])}
        hyPowerPointerWrapper.pointerAngle = -30 + 240 * hyPower / 1200
        hyPowerIncicator.text = String(hyPower) + "W"
        liPowerPointerWrapper.pointerAngle = -30 + 240 * liPower / 3000
        liPowerIncicator.text = String(liPower) + "W"
        hyRemainPointerWrapper.pointerAngle = -30 + hyRemain * 240 / 30
        hyRemainIncicator.text = String(hyRemain) + "MPa"
        liRemainPointerWrapper.pointerAngle = -30 + (liRemain - 28) * 240 / 6
        liRemainIncicator.text = String(liRemain) + "V"
        return 0
    }
    function pauseGraph()
    {
        isGraphPause = !isGraphPause
    }
}

