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

                var students: [Student] = []

                if let members = value["members"] as? [String: [String: Any]] {

                    for (key, data) in members {

                        let student = Student(
                            id: key,
                            firstname: data["firstName"] as? String ?? "",
                            idnum: data["id"] as? Int ?? 0,
                            lastname: data["lastName"] as? String ?? "",
                            scannerId: data["scannerId"] as? Int ?? 0
                        )

                        students.append(student)
                        print("STUDENT:", student.firstname)
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
        }
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
            .child(student.id)
            .setValue([
                "firstName": student.firstname,
                "lastName": student.lastname,
                "id": student.idnum,
                "scannerId": student.scannerId
            ])
    }

    func removeStudentFromGroup(groupId: String, student: Student) {

        let ref = Database.database().reference()

        ref.child("groups")
            .child(groupId)
            .child("members")
            .child(student.id)
            .removeValue()
    }
}
