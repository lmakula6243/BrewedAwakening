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
    
    
    func createGroup(groupName: String){
        let ref = Database.database().reference()
        let groupRef = ref.child("groups").childByAutoId()
        let data: [String: Any] = ["groupName": groupName]
        groupRef.setValue(data)
    }
    
    
    func addStudentToGroup(groupId: String, student: Student) {
        let ref = Database.database().reference()
        ref.child("groups")
            .child(groupId)
            .child("members")
            .child(student.skey)
            .setValue([
                "firstName": student.firstname,
                "lastName": student.lastname,
                "id": student.id,
                "scannerId": student.scannerId
            ])
    }
    
    func removeStudentFromGroup(groupId: String, student: Student) {
        let ref = Database.database().reference()
        ref.child("groups")
            .child(groupId)
            .child("members")
            .child(student.skey)
            .removeValue()
    }
}
