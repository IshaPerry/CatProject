//
//  CatProjectApp.swift
//  CatProject
//
//  Created by Isha Perry on 1/30/24.
//

import SwiftUI


@main
struct CatProjectApp: App {
    @ObservedObject var appState: AppState = AppState()
    var body: some Scene {
        WindowGroup {
            if appState.isLoggedIn{
                ContentView()
            } else {
                AuthView()
                    .environmentObject(appState)
            }
                
        }
    }
}
