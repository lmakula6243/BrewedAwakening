//
//  GroupsViewModel.swift
//  BrewedAwakening
//
//  Created by Aleksandra J. Oleksiak on 2/23/26.
//

import FirebaseDatabase
import Foundation
import Combine
import SwiftUI

class GroupsViewModel: ObservableObject {
    
    @StateObject var myViewModel: StudentsViewModel = StudentsViewModel()
    @StateObject var groupsVM: GroupsViewModel = GroupsViewModel()
    @Published var groups: [Group] = []
    
    init() {
        print("Fetching groups...")
        fetchGroups()
    }
    
    func fetchGroups() {
        
        let ref = Database.database().reference().child("groups")
        
        ref.observe(.value, with: { (snapshot: DataSnapshot) in
            print("SNAPSHOT VALUE:")
            print(snapshot.value as Any)
            
            var loadedGroups: [Group] = []
            
            for case let groupSnap as DataSnapshot in snapshot.children {
                
                let groupId = groupSnap.key
                
                guard let value = groupSnap.value as? [String: Any] else { continue }
                
                let groupName = value["groupName"] as? String ?? ""
                
                var students: [Student] = []
                
                if let members = value["members"] as? [String: [String: Any]] {
                    
                    for (key, data) in members {
                        
                        let student = Student(
                            skey: key,
                            firstname: data["firstName"] as? String ?? "",
                            id: data["id"] as? Int ?? 0,
                            lastname: data["lastName"] as? String ?? "",
                            scannerId: data["scannerId"] as? Int ?? 0
                        )
                        
                        students.append(student)
                    }
                }
                
                let group = Group(
                    id: groupId,
                    groupName: groupName,
                    students: students
                )
                
                loadedGroups.append(group)
            }
            
            DispatchQueue.main.async {
                self.groups = loadedGroups
            }
            
        })
    }
                    
        func createGroup(groupName: String, completion: @escaping (Group) -> Void) {
            let ref = Database.database().reference()
            let groupRef = ref.child("groups").childByAutoId()
            
            let data: [String: Any] = [
                "groupName": groupName
            ]
            
            groupRef.setValue(data)
            
            let group = Group(
                id: groupRef.key ?? UUID().uuidString,
                groupName: groupName
            )
            
            completion(group)
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

