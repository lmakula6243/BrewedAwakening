//
//  GroupsViewModel.swift
//  BrewedAwakening
//
//  Created by Aleksandra J. Oleksiak on 2/23/26.
//

import FirebaseDatabase
import Foundation
import Combine

class GroupsViewModel: ObservableObject {
    //@Published var groups: [Group] = []
    
    func createGroup(groupName: String){
        let ref = Database.database().reference()
        let groupRef = ref.child("groups").childByAutoId()
        let data: [String: Any] = ["groupName": groupName]
        groupRef.setValue(data)
    }
}
