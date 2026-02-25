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
    @State var groups: [Group] = []
    var body: some View {
            VStack {
                ZStack {
                    Text("Brewed Awakening")
                        .font(.custom("Hiragino Kaku Gothic StdN", size: 50))
                        .bold()
                        .padding()
                    HStack {
                        Button {
                            selectedPage = "home"
                        } label: {
                            Image(systemName: "house.fill")
                                .resizable()
                                .frame(width: 50, height: 50)
                                .padding()
                                .foregroundStyle(.brown)
                            
                        }
                        Button {
                            selectedPage = "groups"
                        }label: {
                            Image(systemName: "person.3.fill")
                                .resizable()
                                .frame(width: 75, height: 50)
                                .padding()
                                .foregroundStyle(.brown)
                        }
                        
                        Spacer()
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity)
                        
                        Button {
                            selectedPage = "stats"
                        } label: {
                            Image(systemName: "chart.bar.xaxis.ascending.badge.clock")
                                .resizable()
                                .frame(width: 70, height: 60)
                                .padding()
                                .foregroundStyle(Color(.systemBrown))
                        }
                    }
                }
                Divider()
                    
                
            }
        }
        
    }

