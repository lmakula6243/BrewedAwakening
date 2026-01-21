//
//  BrewedAwakeningApp.swift
//  BrewedAwakening
//
//  Created by Lily P. Makula on 1/16/26.
//

import SwiftUI
import FirebaseCore
import FirebaseDatabase

@main
struct MyApp: App {
    init(){
        FirebaseApp.configure()
        print("firebase is configured")
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
