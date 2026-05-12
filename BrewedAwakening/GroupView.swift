//
//  GroupPage.swift
//  BrewedAwakening
//
//  Created by Cassandra Botnari on 1/29/26.
//

import SwiftUI
import FirebaseDatabase


struct GroupView: View {
    @ObservedObject var myViewModel: StudentsViewModel
    @ObservedObject var groupsVM: GroupsViewModel
    @State var showAddGroupSheet = false
    @State var enteredNewGroup: String = ""
    @Binding var groups: [Group]
    @State var selectedPage: String
    @State var showLockedSheet = false
   // @Binding var group: Group
    var body: some View {
        VStack {
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
                
                HeaderPage(
                        selectedPage: $selectedPage,
                        groups: $groupsVM.groups,
                        showLockedSheet: $showLockedSheet
                    )
                
                List {
                    
                    ForEach($groupsVM.groups) { $group in
                        
                        NavigationLink(
                            destination: IDScannerChoicePage(
                                myViewModel: myViewModel,
                                groupsVM: groupsVM,
                                group: $group
                            )
                        ){
                            Text(group.groupName)
                                .font(Font.custom("Hiragino Kaku Gothic StdN", size: 15))
                                .foregroundStyle(.black)
                        }
                        
                        //                        Button {
                        //                            selectedPage = "home"
                        //
                        //                        } label: {
                        //                            Text(group.groupName)
                        //                                .font(Font.custom("Hiragino Kaku Gothic StdN", size: 15))
                        //                                .foregroundStyle(.black)
                        //                        }
                        //                    }
                        //                    .listRowBackground(Color(.systemGray3))
                    }
                    
                    
                    Button(action: {
                        showAddGroupSheet.toggle()
                    }, label: {
                        Text("Don't see your group?")
                            .font(.headline)
                            .foregroundStyle(.black)
                    })
                    .sheet(isPresented: $showAddGroupSheet) {
                        Text("Name Your Group")
                            .font(Font.custom("Hiragino Kaku Gothic StdN", size: 35))
                        Text("(Ex: Mr. Smith)")
                            .font(Font.custom("Hiragino Kaku Gothic StdN", size: 15))
                        TextField("Enter Group Name Here", text: $enteredNewGroup)
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                        Button(action: {
                            
                            let formatter = DateFormatter()
                            formatter.timeStyle = .short
                            
                            groupsVM.createGroup(
                                groupName: enteredNewGroup,
                                time: formatter.string(from: Date())
                            ) { newGroup in
                                groups.append(newGroup)
                            }
                            
                            showAddGroupSheet.toggle()
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
        
    }
}
