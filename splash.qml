import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0

ApplicationWindow{
    id:splash
    visible: true
    width: splashLogo.width
    height:splashLogo.height
    flags:Qt.FramelessWindowHint | Qt.WA_TranslucentBackground;
    color: "#00000000";

    property bool isToClose: false
    property var mainWindowObject
    property bool isMainWindowObjectReady: false
    property bool isGraphPause: false
    property bool isGraphPaint: false

    Image {
        id: splashLogo
        width:806
        height:185
        opacity: 1.0
        source: "./resource/pic/Logo.png"
    }
    Timer{
        id:splashOpacityTimer
        interval: 100
        running: true
        repeat:true
        onTriggered: {if(splashLogo.opacity > 0){
                          splashLogo.opacity -= 0.08;}
                      else{
                          isToClose = true
                          splashOpacityTimer.stop()
                          var component = Qt.createComponent("main.qml");
                          if(component.status == Component.Ready){
                              mainWindowObject = component.createObject()
                              mainWindowObject.closeApplication.connect(closeApplication)
                              mainWindowObject.visible = true
                              isMainWindowObjectReady = true}
                          splash.close()}}
    }
    function b(serialData, pointData)
    {
        if(isMainWindowObjectReady){
            isGraphPause = mainWindowObject.isGraphPause
            isGraphPaint = mainWindowObject.isAllGraphStarted
            mainWindowObject.setAllChartData(serialData, pointData)}
    }
    function closeApplication(){
        pyRoot.closeApplication()
    }
}
