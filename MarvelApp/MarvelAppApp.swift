//
//  MarvelAppApp.swift
//  MarvelApp
//
//  Created by Rodolfo Gonzalez on 14-01-25.
//

import SwiftUI

@main
struct MarvelAppApp: App {
    
    var body: some Scene {
        WindowGroup {
            ZStack {
                TabView {
                    EventDesign1View()
                        .tabItem {
                            Image(systemName: "figure.soccer")
                            Text("Discover")
                        }

                    EventDesign1View()
                        .tabItem {
                            Image(systemName: "figure.soccer")
                            Text("Discover")
                        }

                    EventDesign1View()
                        .tabItem {
                            Image(systemName: "figure.soccer")
                            Text("Discover")
                        }
                }
                .accentColor(.white)
                
            }
            .onAppear {
                let appearance = UITabBarAppearance()
                appearance.backgroundColor = UIColor.black
                UITabBar.appearance().standardAppearance = appearance
                UITabBar.appearance().scrollEdgeAppearance = appearance
            }
        }
    }
}
