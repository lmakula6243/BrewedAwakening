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
    @State var groupName: String = ""
        @State var groups: [Group] = []
    init(){
        FirebaseApp.configure()
        print("firebase is configured")
    }
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                VStack {
                    HeaderPage()
                        .frame(width: 1200, height: 150)
                    GroupView(groupName: $groupName, groups: $groups)
                    HomePage()
                    
                }
            }
            
        }
    }
}
