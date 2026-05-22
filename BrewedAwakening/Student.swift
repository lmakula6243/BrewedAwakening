//
//  Students.swift
//  BrewedAwakening
//
//  Created by Lily P. Makula on 1/21/26.
//

import SwiftUI

struct Student: Identifiable{
    let id: String
    var firstname: String
    var idnum: Int
    var lastname: String
    var scannerId: Int
    var clockInTime: Double
    var clockOutTime: Double
    
    var hoursWorked: Double {
            let secondsWorked = clockOutTime - clockInTime
            return secondsWorked / 3600
        }
}
