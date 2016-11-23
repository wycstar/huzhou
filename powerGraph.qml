import QtQuick 2.0
import QtQuick.Window 2.0
import QtQuick.Controls 1.0
import QtQuick.Controls.Styles 1.0
import "./qml"
import jbQuick.Charts 1.0
import "./qml/jbQuick/Charts/QChart.js"        as Charts
import "./qml/jbQuick/Charts/QChartGallery.js" as ChartsData

ApplicationWindow{
    id:power
    width:1000;
    height:600;
    color: "#EE000000";
    visible:true;
    flags:Qt.FramelessWindowHint | Qt.WA_TranslucentBackground;
    property string mainColor: "#5fb2ff"
    property string hyChartColor: "#4bCCCC"
    property string liChartColor: "#ffff00"
    property string allChartColor: "#993333"

    signal pauseGraph()

    Rectangle{
        id:powerCaption
        height:allChart.y
        width:power.width
        color:power.color
        property int buttonWidth: 40
        property string closeColor: "#CC3333"
        Rectangle{
            id:powerCloseButton
            x:power.width - powerCaption.buttonWidth
            width: powerCaption.buttonWidth
            height: 40
            color:"#00000000"
            Text{
                id:powerCloseButtonText
                anchors.centerIn: parent
                text:"X"
                color:power.mainColor
                font.bold: false
                font.pixelSize: 19
                font.family: "微软雅黑"
            }
            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {power.close()}
                onEntered: powerCloseButtonText.color = powerCaption.closeColor
                onExited: powerCloseButtonText.color = power.mainColor
            }
        }
        Rectangle{
            id:powerMinimumButton
            x:power.width - powerCaption.buttonWidth * 2
            width: powerCaption.buttonWidth
            height: 40
            color:"#00000000"
            Text{
                id:powerMinimumButtonText
                anchors.centerIn: parent
                text:"一"
                color:power.mainColor
                font.bold: false
                font.pixelSize: 19
                font.family: "微软雅黑"
            }
            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {power.lower()}
                onEntered: powerMinimumButtonText.color = powerCaption.closeColor
                onExited: powerMinimumButtonText.color = power.mainColor
            }
        }
        Rectangle{
            id:powerPauseButton
            x:power.width - powerCaption.buttonWidth * 3
            width: powerCaption.buttonWidth
            height: 40
            color:"#00000000"
            Text{
                id:powerPauseButtonText
                anchors.centerIn: parent
                text:"II"
                color:power.mainColor
                font.bold: false
                font.pixelSize: 19
                font.family: "微软雅黑"
            }
            MouseArea{
                anchors.fill: parent
                hoverEnabled: true
                onClicked: {pauseGraph()}
                onEntered: powerPauseButtonText.color = powerCaption.closeColor
                onExited: powerPauseButtonText.color = power.mainColor
            }
        }
    }
    Chart {
        id: allChart;
        x:0
        y:40
        width:power.width
        height:power.height - y
        objectName:"allChart"
        chartType: Charts.ChartType.LINE;
        chartOptions: {bezierCurve : false}
    }
    MouseArea{
        property variant mousePoint: "0,0"
        anchors.fill: parent
        cursorShape:Qt.PointingHandCursor
        propagateComposedEvents: true
        onClicked: {mouse.accepted = false}
        onPositionChanged: {
            var delta = Qt.point(mouse.x-mousePoint.x, mouse.y-mousePoint.y)
            power.x += delta.x
            power.y += delta.y}
        onPressed: {
            mousePoint = Qt.point(mouse.x,mouse.y)}
    }
    Column{
        x:allChart.x + 70
        y:allChart.y + 10
        z:2
        width:100
        height: 100
        spacing:12
        Text{
            text:"——  氢燃料电池"
            color:power.hyChartColor
            font.bold: true
            font.family: "微软雅黑"
        }
        Text{
            text:"——  锂电池"
            color:power.liChartColor
            font.bold: true
            font.family: "微软雅黑"
        }
        Text{
            text:"——  总功率"
            color:power.allChartColor
            font.bold: true
            font.family: "微软雅黑"
        }
    }
    function setChartData(hy, li, motor, x)
    {
        var ChartLineData = {
        labels: x,
        datasets: [{
            fillColor: "rgba(220,220,220,0.0)",
            strokeColor: "rgba(75,192,192,0.7)",
            pointColor: "rgba(75,192,192,0.7)",
            pointStrokeColor: "#ffffff",
            bezierCurve : false,
            data: hy},{
            fillColor: "rgba(151,187,205,0.0)",
            strokeColor: "rgba(255,255,0,1)",
            pointColor: "rgba(255,255,0,1)",
            pointStrokeColor: "#ffffff",
            bezierCurve : false,
            data: li},{
            fillColor: "rgba(153,51,51,0.0)",
            strokeColor: "rgba(153,51,51,1)",
            pointColor: "rgba(153,51,51,1)",
            pointStrokeColor: "#ffffff",
            bezierCurve : false,
            data: motor}]
        }
        allChart.chartData = ChartLineData;
        allChart.chartOptions = {bezierCurve : true,
                                 scaleOverride:true,
                                 scaleSteps:20,
                                 scaleStepWidth : 150,
                                 scaleStartValue:0};
    }
}
