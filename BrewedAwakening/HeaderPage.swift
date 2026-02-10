//
//  HeaderPage.swift
//  BrewedAwakening
//
//  Created by Lily P. Makula on 2/10/26.
//
import SwiftUI
import FirebaseCore

struct HeaderPage: View {
    var body: some View {
        VStack {
            Text("Brewed Awakening")
                .font(.largeTitle)
                .bold()
                .padding()
                .alignmentGuide(VerticalAlignment.center) { _ in
                    0.5
                }
        }}
}
