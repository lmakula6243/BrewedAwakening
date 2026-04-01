import Foundation
import FirebaseDatabase
import Combine

class StudentsViewModel: ObservableObject {
    @Published var students: [Student] = []
    
    func getData(byField field: String, value: Int) {
        let ref = Database.database().reference()
        
        ref.child("students")
            .queryOrdered(byChild: field)
            .queryEqual(toValue: value)
            .observeSingleEvent(of: .value, with: { snapshot in
                
                print("FULL SNAPSHOT:")
                print(snapshot.value as Any)
                
                var foundStudents: [Student] = []
                
                for child in snapshot.children {
                    guard let snap = child as? DataSnapshot,
                          let data = snap.value as? [String: Any] else { continue }
                    
                    let student = Student(
                        id: snap.key,
                        firstname: data["firstName"] as? String ?? "",
                        idnum: data["id"] as? Int ?? 0,
                        lastname: data["lastName"] as? String ?? "",
                        scannerId: data["scannerId"] as? Int ?? 0
                    )
                    
                    foundStudents.append(student)
                }
                
                
                DispatchQueue.main.async {
                    for s in foundStudents {
                        if !self.students.contains(where: { $0.idnum == s.idnum }) {
                            self.students.append(s)
                        }
                    }
                }
            })
    }

}
