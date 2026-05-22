import FirebaseDatabase
import Foundation
import Combine

class GroupsViewModel: ObservableObject {
    
    @Published var groups: [Group] = []
    
    init() {
        print("Fetching groups...")
        fetchGroups()
    }
    
    func fetchGroups() {
        
        let ref = Database.database().reference().child("groups")
        
        ref.observe(.value) { snapshot in
            
            var loadedGroups: [Group] = []
            
            for case let groupSnap as DataSnapshot in snapshot.children {
                
                let groupId = groupSnap.key
                
                guard let value = groupSnap.value as? [String: Any] else { continue }
                
                let groupName = value["groupName"] as? String ?? ""
                let time = value["time"] as? String ?? ""
                
                var students: [Student] = []
                
                if let members = value["members"] as? [String: [String: Any]] {
                    
                    for (key, data) in members {
                        
                        let student = Student(
                            id: key,
                            firstname: data["firstName"] as? String ?? "",
                            idnum: data["id"] as? Int ?? 0,
                            lastname: data["lastName"] as? String ?? "",
                            scannerId: data["scannerId"] as? Int ?? 0,
                            clockInTime: data["clockInTime"] as? Double ?? 0
                        )
                        students.append(student)
                       
                    }
                }
                
                let group = Group(
                    id: groupId,
                    groupName: groupName,
                    students: students,
                    time: time
                )
                
                loadedGroups.append(group)
            }
            
            DispatchQueue.main.async {
                self.groups = loadedGroups
            }
        }
    }
    
    func createGroup(groupName: String, time: String ,completion: @escaping (Group) -> Void) {
        
        let ref = Database.database().reference()
        let groupRef = ref.child("groups").childByAutoId()
        
        let data: [String: Any] = [
            "groupName": groupName,
            "time": time
        ]
        
        groupRef.setValue(data)
        
        let group = Group(
            id: groupRef.key ?? UUID().uuidString,
            groupName: groupName,
            students: [],
            time: time
        )
        
        completion(group)
    }
    
    func addStudentToGroup(
        groupId: String,
        student: Student
    ) {

        let ref = Database.database().reference()

        ref.child("groups")
            .child(groupId)
            .child("members")
            .child("\(student.idnum)")
            .setValue([

                "firstName": student.firstname,
                "lastName": student.lastname,
                "id": student.idnum,
                "scannerId": student.scannerId,
                "clockInTime": Date().timeIntervalSince1970
            ])
    }
    
    func deleteGroup(group: Group) {

        let ref = Database.database().reference()

        
        ref.child("groups")
            .child(group.id)
            .removeValue()

        
        groups.removeAll {
            $0.id == group.id
        }
    }
    
    
    func removeStudentFromGroup(groupId: String, student: Student) {

        let ref = Database.database().reference()

        ref.child("groups")
            .child(groupId)
            .child("members")
            .child("\(student.idnum)")
            .removeValue()

        if let groupIndex = groups.firstIndex(where: { $0.id == groupId }) {

            groups[groupIndex].students.removeAll {
                $0.idnum == student.idnum
            }
        }
    }
}
