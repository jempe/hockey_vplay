import VPlayApps 1.0
import VPlayPlugins 1.0
import QtQuick 2.0
import "helper"
import "pages"

Item {
    anchors.fill: parent

    // app content with plugin list
    NavigationStack {
        id: pluginMainItem

        // initial page contains list if plugins and opens pages for each plugin when selected
        ListPage {
            id: page
            title: qsTr("V-Play Plugins")

            model: ListModel {
                ListElement { type: "Advertising"; name: "AdMob";
                    detailText: "Ad Monetization and Promotion"; image: "../assets/logo-admob.png" }
                ListElement { type: "Advertising"; name: "Chartboost"
                    detailText: "Ad Monetization and Promotion"; image: "../assets/logo-chartboost.png" }
            }

            delegate: PluginListItem {
                visible: name !== "GameCenter" || Theme.isIos

                onSelected: {
                    switch (name) {
                    case "AdMob":
                        page.navigationStack.push(Qt.resolvedUrl("pages/AdMobPage.qml"))
                        break
                    case "Chartboost":
                        page.navigationStack.push(Qt.resolvedUrl("pages/ChartboostPage.qml"))
                        break
                    }
                }
            }

            section.property: "type"
            section.delegate: SimpleSection { }
        }
    }
}
