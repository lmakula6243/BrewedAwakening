//
//  GroupPage.swift
//  BrewedAwakening
//
//  Created by Cassandra Botnari on 1/29/26.
//

import SwiftUI
import FirebaseDatabase


struct GroupView: View {
    @StateObject var GroupVM: GroupsViewModel = GroupsViewModel()
    @State var showAddGroupSheet = false
    @State var enteredNewGroup: String = ""
    @Binding var groups: [Group]
    var body: some View {
        ZStack{
            Text("Welcome")
                .font(.custom("Hiragino Kaku Gothic StdN", size: 50))
                .foregroundStyle(.brown)
            
            Text("Welcome")
                .font(.custom("Hiragino Kaku Gothic StdN", size: 50))
                .foregroundStyle(.orange)
                .offset(x: -5, y: -2)
        }
        Text("Start a working session...")
            .font(.custom("Snell Roundhand Bold", size: 30))
        ZStack{
            
            
            List {
                ForEach($groups) { $group in
                    NavigationLink {
                        IDScannerChoicePage(group: $group)
                    } label: {
                        Text(group.groupName)
                            .font(Font.custom("Hiragino Kaku Gothic StdN", size: 15))
                    }
                }
                .listRowBackground(Color(.systemGray3))
            }
            
            Button(action: {
                showAddGroupSheet.toggle()
            }, label: {
                Text("Don't see your group?")
                    .font(.headline)
            })
            .sheet(isPresented: $showAddGroupSheet) {
                Text("Name Your Group")
                    .font(Font.custom("Hiragino Kaku Gothic StdN", size: 35))
                Text("(Ex: Mr. Smith)")
                    .font(Font.custom("Hiragino Kaku Gothic StdN", size: 15))
                TextField("Enter Group Name Here", text: $enteredNewGroup)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                Button(action: {
                    showAddGroupSheet.toggle()
                    let newGroup = Group(groupName: enteredNewGroup)
                    groups.append(newGroup)
                    GroupVM.createGroup(groupName: enteredNewGroup)
                    enteredNewGroup = ""
                }, label: {
                    ZStack{
                        RoundedRectangle(cornerRadius: 5)
                            .foregroundStyle(.orange)
                            .frame(width: 100, height: 40)
                        Text("Done")
                            .foregroundStyle(.black)
                            .font(Font.custom("Hiragino Kaku Gothic StdN", size: 15))
                    }
                })
            }
        }
    }
}

