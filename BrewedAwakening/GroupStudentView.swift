//
//  GroupStudentView.swift
//  BrewedAwakening
//
//  Created by Cassandra Botnari on 3/9/26.
//
import SwiftUI

struct GroupStudentsView: View {
    var group: Group
    var body: some View {
        List(group.students) { student in
            VStack(alignment: .leading) {
                Text(student.firstname)
                Text(student.lastname)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
        .navigationTitle(group.groupName)
    }
}
