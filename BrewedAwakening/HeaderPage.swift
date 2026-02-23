//
//  HeaderPage.swift
//  BrewedAwakening
//
//  Created by Lily P. Makula on 2/10/26.
//
import SwiftUI
import FirebaseCore

struct HeaderPage: View {
    @Binding var selectedPage: String
    var body: some View {
            VStack {
                HStack {
                    Button {
                        selectedPage = "home"
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
                    Button {
                        selectedPage = "stats"
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

