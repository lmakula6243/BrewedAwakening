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
    
    @State var groupName: String = ""
    @State var group: [Group] = []
    @State var path = NavigationPath()
    @State var selectedPage = "groups"
    @State var selectedGroup: Group? = nil
    @State var showLockedSheet = false
    @State var password: String = ""
    @StateObject var groupsVM = GroupsViewModel()
    @StateObject var myViewModel = StudentsViewModel()
    @State var buttonName = true
    
    
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $path) {
                VStack(spacing: 0) {
                    
                    HeaderPage(
                        selectedPage: $selectedPage,
                        groups: $groupsVM.groups,
                        showLockedSheet: $showLockedSheet
                    )
                    .frame(height: 150)
                    
                    ZStack {
                        
                        if selectedPage == "groups" {
                            
                            GroupView(
                                myViewModel: myViewModel,
                                groupsVM: groupsVM,
                                groups: $groupsVM.groups,
                                selectedPage: $selectedPage,
                                selectedGroup: $selectedGroup
                            )
                            
                        } else if selectedPage == "home" {
                            
                            if let group = selectedGroup {
                                
                                IDScannerChoicePage(
                                    myViewModel: myViewModel,
                                    groupsVM: groupsVM,
                                    group: Binding(
                                        get: { group },
                                        set: { selectedGroup = $0 }
                                    )
                                )
                                
                            } else {
                                Text("Select a group first")
                            }
                            
                        } else if selectedPage == "stats" {
                            
                            workerStatsPage(
                                groups: $groupsVM.groups,
                                myViewModel: myViewModel,
                                groupsVM: groupsVM
                            )
                        }
                    }
                    .sheet(isPresented: $showLockedSheet) {
                        lockPage()
                    }
                }
                .environmentObject(groupsVM)
            }
            
        }
        
    }
        
        func lockPage() -> some View {
            VStack(spacing: 20) {
                Text("Password Required to Unlock Screen")
                    .font(Font.largeTitle.bold())
                    .frame(alignment: .center)
                    .padding()
                Image(systemName: buttonName ? "lock.fill" : "lock.open.fill")
                    .resizable()
                    .frame(width: 60, height: 70)
                SecureField("Enter the password to unlock", text: $password)
                    .padding()
                    .onSubmit {
                        if password == "214214" {
                            withAnimation {
                                buttonName = false
                            }
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                                showLockedSheet = false
                                buttonName = true
                            }
                        }
                        password = ""
                    }
                    .padding()
                    .interactiveDismissDisabled(true)
                    .textFieldStyle(.roundedBorder)
            }
        }
    
}



