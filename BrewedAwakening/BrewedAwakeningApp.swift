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
            VStack {
                HeaderPage()
                    .frame(height: 150)
                
                NavigationStack {
                    VStack(spacing: 0) {
                        GroupView(groups: $groups)
                        HomePage()
                            
                    }
                }
            }
            
            
        }
        
        
        
        
    }
}
