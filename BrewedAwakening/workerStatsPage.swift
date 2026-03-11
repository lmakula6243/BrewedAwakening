//
//  workerStatsPage.swift
//  BrewedAwakening
//
//  Created by Lily P. Makula on 2/17/26.
//

import SwiftUI
import FirebaseCore

struct workerStatsPage: View {
    @Binding var groups: [Group] 
//    @ObservedObject var GroupsVM = GroupsViewModel()
    @State var selectedMenu: String = "Groups"
    @State var searchText = ""
    @State var selectedGroup: Group?
    @State var payPerHour : Int = 0
    @ObservedObject var myViewModel: StudentsViewModel = StudentsViewModel()
    @ObservedObject var GroupsVM: GroupsViewModel = GroupsViewModel()
    
//    var filteredGroups: [Group] {
//        groups
//            .filter {
//                searchText.isEmpty ||
//                $0.groupName.localizedCaseInsensitiveContains(searchText)
//            }
//            .sorted { $0.groupName < $1.groupName }
//    }
    var filteredGroups: [Group] {
        GroupsVM.groups
            .filter {
                searchText.isEmpty ||
                $0.groupName.localizedCaseInsensitiveContains(searchText)
            }
            .sorted { $0.groupName < $1.groupName }
    }
    var body: some View {
        
        NavigationSplitView {
            Text("MENU")
                .font(.largeTitle)
            List {
                Button("Groups") {
                    selectedMenu = "Groups"
                }
                
                Button("Students") {
                    selectedMenu = "Students"
                }
                
                Button("Calculate Pay") {
                    selectedMenu = "Pay"
                }
            }
            .navigationTitle("Menu")
            
        } detail: {
            NavigationStack{
                if selectedMenu == "Groups" {
                    if let group = selectedGroup {
                        
                        VStack {
                            Button("← Back to Groups") {
                                selectedGroup = nil
                            }
                            .padding()
                            
//                            GroupStudentsView(group: )
                        }
                        .navigationTitle(group.groupName)
                        
                    } else {
                        
//                        List{
//                            ForEach($GroupsVM.groups) { $group in
//                                
//                                NavigationLink( destination: GroupStudentsView(group: $group)){
//                                    Text(group.groupName)
//                                        .font(Font.custom("Hiragino Kaku Gothic StdN", size: 15))
//                                        .foregroundStyle(.black)
//                                    
//                                    //                            List(filteredGroups) { group in
//                                    //                                Button {
//                                    //                                    selectedGroup = group
//                                    //                                } label: {
//                                    //                                    Text(group.groupName)
//                                    //                                }
//                                    //                            }
//                                        .searchable(text: $searchText, prompt: "Search groups")
//                                        .navigationTitle("Groups")
//                                    
//                                }
//                            }
//                        }
                        List {
                            ForEach(filteredGroups) { group in
                                
                                NavigationLink(destination: GroupStudentsView(group: group)) {
                                    Text(group.groupName)
                                        .font(Font.custom("Hiragino Kaku Gothic StdN", size: 15))
                                        .foregroundStyle(.black)
                                }

                            }
                        }
                        .searchable(text: $searchText, prompt: "Search groups")
                        .navigationTitle("Groups")
                    }
                        
                    } else if selectedMenu == "Students" {
                        Text("students search here")
                        
                    } else if selectedMenu == "Pay" {
                        
                        Text("Pay calculation goes here")
                            .font(.largeTitle)
                            .navigationTitle("Calculate Pay")
                        
                    } else if selectedMenu == "Groups"{
                        Text("Groups go here")
                    }else {
                        
                        Text("Select a menu option")
                    }
                }
            }
        }
        
    }
    

    

