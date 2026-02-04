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
    
    init() {
        getData()
    }

    func getData() {
        let ref = Database.database().reference()
        
        ref.child("students").observe(
            .value,
            with: { snapshot in
                var tempArray: [Student] = []

                for case let snap as DataSnapshot in snapshot.children {
                    guard let dict = snap.value as? [String: Any] else { continue }

                    let firstName = dict["firstName"] as? String ?? ""
                    let lastName = dict["lastName"] as? String ?? ""
                    let scannerId = dict["scannerId"] as? Int ?? 0
                    let id = dict["id"] as? Int ?? 0

                    tempArray.append(
                        Student(
                            skey: snap.key,
                            firstname: firstName,
                            id: id,
                            lastname: lastName,
                            scannerId: scannerId
                            
                            
                           
                        )
                    )
                }

                DispatchQueue.main.async {
                    self.students = tempArray
                }
            },
            withCancel: { error in
                print("Firebase error:", error.localizedDescription)
            }
        )

        }
    }




//
//import FirebaseDatabase
//
//
//class StudentsViewModel: ObservableObject{
//    @Published var students: [Student] = []
//    
//    init() {
//        getData()
//    }
//    
//    func getData(){
//        let ref = Database.database().reference()
//        
//        ref.child("students").observe(.value) { snapshot in
//            var tempArray: [Student] = []
//            
//            for child in snapshot.children {
//                guard let snap = child as? DataSnapshot,
//                      let dict = snap.value as? [String: Any] else { continue }
//                
//                let firstName = dict["firstName"] as? String ?? ""
//                let lastName = dict["lastName"] as? String ?? ""
//                let id = dict["id"] as? String ?? ""
//                let scannerId = dict["scannerId"] as? String ?? ""
//                
//                tempArray.append(Student(firstName: firstName, lastName: lastName, id: id, scannerId: scannerId))
//            }
//            
//            DispatchQueue.main.async {
//                self.students = tempArray
//            }
//        }
//    }
//}
    
    
