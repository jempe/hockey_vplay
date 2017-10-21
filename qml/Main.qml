import VPlay 2.0
import QtQuick 2.0
import "pages"
import "helper"

/*/////////////////////////////////////
  NOTE:
  Additional integration steps are needed to use V-Play Plugins, for example to add and link required libraries for Android and iOS.
  Please follow the integration steps described in the plugin documentation of your chosen plugins:
  - AdMob: https://v-play.net/doc/plugin-admob/
  - Chartboost: https://v-play.net/doc/plugin-chartboost/

  To open the documentation of a plugin item in Qt Creator, place your cursor on the item in your QML code and press F1.
  This allows to view the properties, methods and signals of V-Play Plugins directly in Qt Creator.

/////////////////////////////////////*/

GameWindow {
    id: gameWindow

    // You get free licenseKeys from https://v-play.net/licenseKey
    // With a licenseKey you can:
    //  * Publish your games & apps for the app stores
    //  * Remove the V-Play Splash Screen or set a custom one (available with the Pro Licenses)
    //  * Add plugins to monetize, analyze & improve your apps (available with the Pro Licenses)
    //licenseKey: "<generate one from https://v-play.net/licenseKey>"

    onSplashScreenFinished: physicsWorld.running = true

    activeScene: scene

    // the size of the Window can be changed at runtime by pressing Ctrl (or Cmd on Mac) + the number keys 1-8
    // the content of the logical scene size (480x320 for landscape mode by default) gets scaled to the window size based on the scaleMode
    // you can set this size to any resolution you would like your project to start with, most of the times the one of your main target device
    // this resolution is for iPhone 4 & iPhone 4S
    screenWidth: 640
    screenHeight: 960

    Scene {
        id: scene

        // the "logical size" - the scene content is auto-scaled to match the GameWindow size
        width: gameWindow.screenWidth
        height: gameWindow.screenHeight

        PhysicsWorld {
            id: physicsWorld
            // physics is disabled initially, and enabled after the splash is finished
            running: false
            z: 10 // draw the debugDraw on top of the entities

            // these are performance settings to avoid boxes colliding too far together
            // set them as low as possible so it still looks good
            updatesPerSecondForPhysics: 60
            velocityIterations: 5
            positionIterations: 5
            // set this to true to see the debug draw of the physics system
            // this displays all bodies, joints and forces which is great for debugging
            debugDrawVisible: true
        }

        // This item contains example code for the chosen V-Play Plugins
        // It is hidden by default and will overlay the QML items below if shown
        PluginMainItem {
            id: pluginMainItem
            z: 1           // display the plugin example above other items in the QML code below
            visible: false // set this to true to show the plugin example
        }

        EntityManager {
            id: entityManager
            entityContainer: scene
        }

        property string imagesFolder: {
            if(gameWindow.screenWidth < 321)
                return "iphone"
            else if(gameWindow.screenWidth < 481)
                return "nexus"
            else if(gameWindow.screenWidth < 769)
                return "iphone5"
            else if(gameWindow.screenWidth < 1001)
                return "nexus7"
            else if(gameWindow.screenWidth < 1201)
                return "nexus7II"
            else
                return "nexus10"
        }
        property int puckSize: {
            if(gameWindow.screenWidth < 321)
                return 24
            else if(gameWindow.screenWidth < 481)
                return 45
            else if(gameWindow.screenWidth < 769)
                return 58
            else if(gameWindow.screenWidth < 1001)
                return 71
            else if(gameWindow.screenWidth < 1201)
                return 97
            else
                return 130
        }

        property double wallsWidth: puckSize * 0.45

        property double redCircleRadius: puckSize * 2.35

        property double tableCornerRadius: puckSize * 0.47

        Table{
            id: table
        }

        Component {
            id: mouseJoint
            MouseJoint {

                maxForce: 300000
                // The damping ratio. 0 = no damping, 1 = critical damping. Default is 0.7
                dampingRatio: 1
                // The response speed, default is 5
                frequencyHz: 5

                //collideConnected: true // collideConnected is only needed, if 2 bodies are connected with a MouseJoint and those should collide or not - but the typical use case for a MouseJoint is that only 1 body is affected, which should be pulled towards a targetPoint
            }
        }

        MouseArea {
            anchors.fill: parent

            property Body selectedBody: null
            property MouseJoint mouseJointWhileDragging: null

            onPressed: {

                selectedBody = physicsWorld.bodyAt(Qt.point(mouseX, mouseY));
                console.debug("selected body at position", mouseX, mouseY, ":", selectedBody);
                if(selectedBody) {
                    mouseJointWhileDragging = mouseJoint.createObject(physicsWorld)

                    // set the target point to the current mouse position
                    mouseJointWhileDragging.target = Qt.point(mouseX, mouseY)

                    // set the body to move to the currently selected one
                    mouseJointWhileDragging.bodyB = selectedBody

                }
            }

            onPositionChanged: {
                if (mouseJointWhileDragging)
                    mouseJointWhileDragging.target = Qt.point(mouseX, mouseY)
            }

            onReleased: {
                // if the user pressed a body initially, don't create a new box but remove the created MouseJoint
                if(selectedBody) {

                    selectedBody = null
                    if (mouseJointWhileDragging)
                        mouseJointWhileDragging.destroy()
                }
            }
        }

        EntityBase {
            entityId: "puck"
            entityType: "puck"
            x: gameWindow.width / 2
            y: table.height / 2

            Image {
                id: puckImage
                source: "../assets/images/" + scene.imagesFolder + "/puck.png"
                x: puckImage.width / -2
                y: puckImage.height / -2
            }
            CircleCollider {
                radius: scene.puckSize / 2
                friction: 0.1
                restitution: 1
                x: scene.puckSize / -2
                y: scene.puckSize / -2
                collidesWith: Circle.Category1

            }
        }

        EntityBase {
            entityId: "mallet"
            entityType: "mallet"
            x: gameWindow.width / 2
            y: gameWindow.height * 0.75

            Image {
                id: malletImage
                source: "../assets/images/" + scene.imagesFolder + "/mallet.png"
                x: malletImage.width / -2
                y: malletImage.height / -2
            }
            CircleCollider {
                radius: scene.puckSize
                friction: 0
                x: scene.puckSize * -1
                y: scene.puckSize * -1
                categories: Circle.Category1
            }
        }

        EntityBase {
            entityId: "tableWalls"
            entityType: "tableWalls"

            BoxCollider {
                x: 0
                y: 0
                width:scene.wallsWidth
                height:gameWindow.height
                bodyType: Body.Static
            }
            BoxCollider {
                x:gameWindow.width - scene.wallsWidth
                y: 0
                width:scene.wallsWidth
                height:gameWindow.height
                bodyType: Body.Static
            }
            BoxCollider {
                x: 0
                y: 0
                width:(gameWindow.width / 2) - scene.redCircleRadius - scene.tableCornerRadius
                height:scene.wallsWidth
                bodyType: Body.Static
            }
            CircleCollider {
                x: (gameWindow.width / 2) - scene.redCircleRadius - (scene.tableCornerRadius * 2)
                y: -scene.tableCornerRadius
                radius: scene.tableCornerRadius
                bodyType: Body.Static
            }
            BoxCollider {
                x: (gameWindow.width / 2) + scene.redCircleRadius + scene.tableCornerRadius
                y: 0
                width:(gameWindow.width / 2) - scene.redCircleRadius - scene.tableCornerRadius
                height:scene.wallsWidth
                bodyType: Body.Static
            }
            CircleCollider {
                x: (gameWindow.width / 2) + scene.redCircleRadius
                y: -scene.tableCornerRadius
                radius: scene.tableCornerRadius
                bodyType: Body.Static
            }
            BoxCollider {
                x: 0
                y: table.height - scene.wallsWidth
                width:(gameWindow.width / 2) - scene.redCircleRadius - scene.tableCornerRadius
                height:scene.wallsWidth
                bodyType: Body.Static
            }
            CircleCollider {
                x: (gameWindow.width / 2) - scene.redCircleRadius - (scene.tableCornerRadius * 2)
                y: table.height - scene.wallsWidth
                radius: scene.tableCornerRadius
                bodyType: Body.Static
            }
            BoxCollider {
                x: (gameWindow.width / 2) + scene.redCircleRadius + scene.tableCornerRadius
                y: table.height - scene.wallsWidth
                width:(gameWindow.width / 2) - scene.redCircleRadius - scene.tableCornerRadius
                height:scene.wallsWidth
                bodyType: Body.Static
            }
            CircleCollider {
                x: (gameWindow.width / 2) + scene.redCircleRadius
                y: table.height - scene.wallsWidth
                radius: scene.tableCornerRadius
                bodyType: Body.Static
            }
        }

        EntityBase {
            entityId: "malletLimits"
            BoxCollider {
                categories: Box.Category2
                y: table.height / 2 - 3
                x: 0
                height: 6
                width: gameWindow.width
                bodyType: Body.Static
            }
            BoxCollider {
                categories: Box.Category2
                y: table.height - scene.wallsWidth
                x: 0
                height: scene.wallsWidth
                width: gameWindow.width
                bodyType: Body.Static
            }
            BoxCollider {
                categories: Box.Category2
                y: 0
                x: 0
                height: scene.wallsWidth
                width: gameWindow.width
                bodyType: Body.Static
            }
        }
    }
}
