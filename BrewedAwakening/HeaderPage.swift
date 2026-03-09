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
    @Binding var showLockedSheet: Bool
    var body: some View {
        VStack(spacing: 0) {
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
                                .foregroundStyle(Color(red: 0.35, green: 0.22, blue: 0.12))
                            
                        }
                        Button {
                            selectedPage = "groups"
                        }label: {
                            Image(systemName: "person.3.fill")
                                .resizable()
                                .frame(width: 75, height: 50)
                                .padding()
                                .foregroundStyle(Color(red: 0.35, green: 0.22, blue: 0.12))
                        }
                        
                        Spacer()
                            .padding(.horizontal)
                            .frame(maxWidth: .infinity)
                        
                        Button {
                            showLockedSheet.toggle()
                        } label: {
                            Image(systemName: "lock.fill")
                                .resizable()
                                .frame(width: 40, height: 50)
                                .padding()
                                .foregroundStyle(Color(red: 0.35, green: 0.22, blue: 0.12))
                        }
                        
                        
                        Button {
                            selectedPage = "stats"
                        } label: {
                            Image(systemName: "chart.bar.xaxis.ascending.badge.clock")
                                .resizable()
                                .frame(width: 70, height: 60)
                                .padding()
                                .foregroundStyle(Color(red: 0.35, green: 0.22, blue: 0.12))
                        }
                    }
                }
                Divider()
                
            }
        .frame(maxWidth: .infinity)
        }
        
    }

