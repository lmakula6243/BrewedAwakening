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
    @State var payPerHour : Double = 0.0
    @State var enteredPay = ""
    @State var hoursWorked : Int = 0
    @ObservedObject var myViewModel: StudentsViewModel
    @ObservedObject var groupsVM: GroupsViewModel
   

    var filteredGroups: [Group] {
        groupsVM.groups
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
                    
                    VStack {
                        Text("Calculate Pay")
                            .font(.largeTitle)
                        
                        TextField("Hourly Pay", text: $enteredPay)
                            .keyboardType(.decimalPad)
                            .textFieldStyle(.roundedBorder)
                            .padding()
                            .onSubmit {
                                payPerHour = Double(enteredPay) ?? 0
                            }
                        
                        List {
                            ForEach(groupsVM.groups) { group in
                                
                                Section(header: Text(group.groupName)) {
                                    ForEach(group.students) { student in
                                        let hoursWorked = (student.clockOutTime - student.clockInTime) / 3600
                                        let totalPay = hoursWorked * payPerHour
                                        VStack(alignment: .leading) {
                                            Text("\(student.firstname) \(student.lastname)")
                                                .font(.headline)
                                            Text("Hours Worked: \(hoursWorked, specifier: "%.2f")")
                                            Text("Total Pay: $\(totalPay, specifier: "%.2f")")
                                                .foregroundColor(.orange)
                                        }
                                    }
                                }
                            }
                        }
                        .navigationTitle("Calculate Pay")
                    }
                }
            }
        }
        
    }
    
    
    
}
