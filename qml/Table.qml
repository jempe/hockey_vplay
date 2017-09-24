import QtQuick 2.0

Rectangle{
    id:hockeyTable
    width:gameWindow.screenWidth
    height:gameWindow.screenHeight
    color: "white"

    property double circleSize: scene.puckSize * 4.7
    property double borderWidth: scene.puckSize / 8

    Rectangle {
        id: centerCircle
        width: circleSize
        height: circleSize
        border.color: "red"
        border.width: borderWidth
        radius: circleSize / 2
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Rectangle {
        width: circleSize
        height: circleSize
        border.color: "red"
        border.width: borderWidth
        radius: circleSize / 2
        anchors.verticalCenter: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Rectangle {
        width: circleSize
        height: circleSize
        border.color: "red"
        border.width: borderWidth
        radius: circleSize / 2
        anchors.verticalCenter: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Rectangle {
        width:parent.width
        height: borderWidth
        color: "red"
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Image  {
        source: "../assets/images/" + scene.imagesFolder + "/jempe_logo.png"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
    }
    Image  {
        source: "../assets/images/" + scene.imagesFolder + "/table_side.png"
        anchors.left: parent.left
        anchors.verticalCenter: parent.center
    }
    Image  {
        mirror: true
        source: "../assets/images/" + scene.imagesFolder + "/table_side.png"
        anchors.right: parent.right
        anchors.verticalCenter: parent.center
    }
    Image  {
        source: "../assets/images/" + scene.imagesFolder + "/table_bottom.png"
        anchors.bottom: parent.bottom
        anchors.left: centerCircle.right
    }
    Image  {
        mirror: true
        source: "../assets/images/" + scene.imagesFolder + "/table_bottom.png"
        anchors.bottom: parent.bottom
        anchors.right: centerCircle.left
    }
    Image  {
        mirror: true
        source: "../assets/images/" + scene.imagesFolder + "/table_bottom.png"
        anchors.top: parent.top
        anchors.left: centerCircle.right
        scale: -1
    }
    Image  {
        source: "../assets/images/" + scene.imagesFolder + "/table_bottom.png"
        anchors.top: parent.top
        anchors.right: centerCircle.left
        scale: -1
    }
    Image  {
        source: "../assets/images/" + scene.imagesFolder + "/corner.png"
        anchors.left: parent.left
        anchors.top: parent.top
    }
    Image  {
        mirror: true
        source: "../assets/images/" + scene.imagesFolder + "/corner.png"
        anchors.right: parent.right
        anchors.top: parent.top
    }
    Image  {
        scale: -1
        source: "../assets/images/" + scene.imagesFolder + "/corner.png"
        anchors.right: parent.right
        anchors.bottom: parent.bottom
    }
    Image  {
        mirror: true
        scale: -1
        source: "../assets/images/" + scene.imagesFolder + "/corner.png"
        anchors.left: parent.left
        anchors.bottom: parent.bottom
    }
}
