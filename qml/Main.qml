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

    onSplashScreenFinished: world.running = true

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
            id: world
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

        Table{

        }

        EntityBase {
            entityId: "puck"
            entityType: "puck"
            anchors.centerIn: parent

            Image {
                id: puckImage
                source: "../assets/images/" + scene.imagesFolder + "/puck.png"
                x: puckImage.width / -2
                y: puckImage.height / -2
            }
            CircleCollider {
                radius: scene.puckSize / 2
                friction: 0.99
                x: scene.puckSize / -2
                y: scene.puckSize / -2
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
                friction: 0.99
                x: scene.puckSize * -1
                y: scene.puckSize * -1
            }
        }
    }
}
