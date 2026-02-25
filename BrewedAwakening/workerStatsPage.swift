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
    @State var selectedMenu: String = "Groups"
    @State var searchText = ""
    
    var filteredGroups: [Group] {
        groups
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

            if selectedMenu == "Groups" {

                            List(filteredGroups) { group in
                                Text(group.groupName)
                            }
                            .navigationTitle("Groups")
                            .searchable(text: $searchText, prompt: "Search groups")

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
