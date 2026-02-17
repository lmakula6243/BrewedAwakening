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
        NavigationStack {
            VStack {
                HStack {
                    NavigationLink {
                        HomePage()
                    } label: {
                        Image(systemName: "house.fill")
                            .resizable()
                            .frame(width: 50, height: 50)
                            .padding()
                        
                    }
                    Spacer()
                    
                    
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                        .overlay {
                            Text("Brewed Awakening")
                                .font(.custom("Hiragino Kaku Gothic StdN", size: 50))
                                .bold()
                                .padding()
                        }
                    Spacer()
                    NavigationLink {
                        workerStatsPage()
                    } label: {
                        Image(systemName: "person.3.fill")
                            .resizable()
                            .frame(width: 60, height: 50)
                            .padding()
                    }
                }
                Divider()
                    .padding()
                
            }
        }
        
    }
}
