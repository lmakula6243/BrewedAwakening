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
    @State var group: [Group] = []
    @State var path = NavigationPath()
    @State var selectedPage = "groups"
    @State var selectedGroup: Group? = nil
    @State var showLockedSheet = false
    @State var password: String = ""
    init(){
        FirebaseApp.configure()
        print("firebase is configured")
    }
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
                VStack(spacing: 0) {
                    HeaderPage(selectedPage: $selectedPage, showLockedSheet: $showLockedSheet)
                        .frame(height: 150)
                    ZStack {
                    if selectedPage == "home" {
                        if let firstGroup = group.first {
                                IDScannerChoicePage(group: .constant(firstGroup))
                            } else {
                                Text("No group available")
                                    .font(.title)
                                    .foregroundColor(.gray)
                                        }
                    } else if selectedPage == "groups" {
                        GroupView(groups: $group, selectedPage: $selectedPage)
                    } else if selectedPage == "stats" {
                        workerStatsPage(groups: $group)
                    }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .sheet(isPresented: $showLockedSheet) {
                    Text("Password Required to Unlock Screen")
                        .font(Font.largeTitle.bold())
                        .frame(alignment: .center)
                        .padding()
                    Image(systemName: "lock.fill")
                        .resizable()
                        .frame(width: 60, height: 70)
                    SecureField("Enter the password to unlock", text: $password)
                        .padding()
                        .onSubmit {
                            if password == "214214" {
                                showLockedSheet = false
                            }
                            password = ""
                        }
                        .padding()
                        .interactiveDismissDisabled(true)
                        .textFieldStyle(.roundedBorder)
            }
            
            }
        }
        
    }
    
    
    
    
    
    
    
}
