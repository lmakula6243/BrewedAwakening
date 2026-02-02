//
//  GroupViewModel.swift
//  BrewedAwakening
//
//  Created by Cassandra Botnari on 2/2/26.
//
import SwiftUI

struct Group: Identifiable {
    let id = UUID()
    var name: String
    var students: [Student] = []
}
