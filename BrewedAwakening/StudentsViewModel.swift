//
//  StudentsViewModel.swift
//  BrewedAwakening
//
//  Created by Lily P. Makula on 1/21/26.
//


import Foundation
import FirebaseDatabase
import Combine

class StudentsViewModel: ObservableObject{
    @Published var students: [Student] = []
    
    
    func getData(
        byField field: String,
        value: Int
    ) {
        let ref = Database.database().reference()
        
        ref.child("students")
            .queryOrdered(byChild: field)
            .queryEqual(toValue: value)
            .observeSingleEvent(of: .value) { snapshot in
                print("FULL SNAPSHOT:")
                print(snapshot.value as Any)
                
                guard let result = snapshot.value as? [String: Any],
                      let (key, dict) = result.first,
                      let data = dict as? [String: Any]
                else {
                    print("Student not found")
                    return
                }
                
                let student = Student(
                    skey: key,
                    firstname: data["firstName"] as? String ?? "",
                    id: data["id"] as? Int ?? 0,
                    lastname: data["lastName"] as? String ?? "",
                    scannerId: data["scannerId"] as? Int ?? 0
                )
                print("Scanned student:", student.firstname, student.lastname)

                DispatchQueue.main.async {
                    self.students = [student]
                }
            }
    }
}




