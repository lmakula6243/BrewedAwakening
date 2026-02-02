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
    var body: some View {
        Text("Welcome")
            .font(.largeTitle)
        Text("Start a working session...")
        
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
            }, label: {
                Text("Done")
            })
        }
    }
}
    
