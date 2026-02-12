//
//  GroupPage.swift
//  BrewedAwakening
//
//  Created by Cassandra Botnari on 1/29/26.
//

import SwiftUI

struct GroupView: View {
    @State var showAddGroupSheet = false
    @State var enteredNewGroup: String = ""
    @Binding var groups: [Group]
    var body: some View {
        NavigationStack{
            Text("Welcome")
                .font(.largeTitle)
            Text("Start a working session...")
            List {
                ForEach($groups) { $group in
                    NavigationLink {
                        IDScannerChoicePage(group: $group)
                    } label: {
                        Text(group.groupName)
                    }
                }
                
                Button(action: {
                    showAddGroupSheet.toggle()
                }, label: {
                    Text("Don't see your group?")
                })
                .sheet(isPresented: $showAddGroupSheet) {
                    Text("Name Of Your Group")
                    TextField("Enter Group Name Here", text: $enteredNewGroup)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                    Button(action: {
                        showAddGroupSheet.toggle()
//                        groupName = enteredNewGroup
                        groups.append(Group(groupName: enteredNewGroup))
                        enteredNewGroup = ""
                    }, label: {
                        Text("Done")
                    })
                }
            }
        }
    }
}
