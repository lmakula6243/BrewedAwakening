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
        HStack {
            NavigationLink {
                
            } label: {
                Image(systemName: "home")
            }

            Text("Brewed Awakening")
                .font(.custom("Hiragino Kaku Gothic StdN", size: 50))
                .bold()
                .padding()
                .alignmentGuide(VerticalAlignment.center) { _ in
                    0.5
                }
            Divider()
        }}
   
}
