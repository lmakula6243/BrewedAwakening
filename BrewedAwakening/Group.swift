//
//  GroupViewModel.swift
//  BrewedAwakening
//
//  Created by Cassandra Botnari on 2/2/26.
//
import SwiftUI

struct Group: Identifiable {
    let id = UUID()
    var groupName: String
    var students: [Student] = []
}
