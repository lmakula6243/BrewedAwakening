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
                
                if let rawArray = snapshot.value as? [Any] {
                    // Case: Firebase returned array (possibly with <null> holes)
                    for item in rawArray {
                        guard let data = item as? [String: Any] else { continue }
                        
                        let student = Student(
                            skey: UUID().uuidString,
                            firstname: data["firstName"] as? String ?? "",
                            id: data["id"] as? Int ?? 0,
                            lastname: data["lastName"] as? String ?? "",
                            scannerId: data["scannerId"] as? Int ?? 0
                        )
                        foundStudents.append(student)
                    }
                } else if let dict = snapshot.value as? [String: [String: Any]] {
                    // Case: Firebase returned dictionary keyed by index
                    for (key, data) in dict {
                        let student = Student(
                            skey: key,
                            firstname: data["firstName"] as? String ?? "",
                            id: data["id"] as? Int ?? 0,
                            lastname: data["lastName"] as? String ?? "",
                            scannerId: data["scannerId"] as? Int ?? 0
                        )
                        foundStudents.append(student)
                    }
                } else {
                    print("No students found")
                    return
                }
                
                DispatchQueue.main.async {
                    for s in foundStudents {
                        if !self.students.contains(where: { $0.id == s.id }) {
                            self.students.append(s)
                        }
                    }
                }
            })
    }

}
