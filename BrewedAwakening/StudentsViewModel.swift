//
//  StudentsViewModel.swift
//  BrewedAwakening
//
//  Created by Lily P. Makula on 1/21/26.
//

import Foundation

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
    
    
