//
//  ContentView.swift
//  MoodYourWeather
//
//  Created by Aldo Yael Navarrete Zamora on 18/10/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    

    var body: some View {
        VStack{
            TabView{
                NavigationStack{
                    VStack{
                        
                        Text("Drag and drop the emojis to express yourself and mood your weather.")
                            .font(.headline)
                            .fontWeight(.regular)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .foregroundStyle(.accent)
                        
                        NavigationLink(destination: Support()) {
                            ZStack(content: {
                                Text("Done")
                                    .foregroundStyle(.white)
                                    .font(.subheadline)
                                    .bold()
                                    .padding()
                                    .frame(maxWidth: .infinity)
                                    .background(.accent)
                                    .clipShape(RoundedRectangle(cornerRadius: 10))
                            })
                        }
                        
                        Spacer()
                    }
                    .navigationTitle("Mood your wheater")
                    .padding()
                    
                    
                }
                .tabItem { Label("Mood your weather", systemImage: "cloud") }
                
                SummaryView()
                    .tabItem { Label("Summary", systemImage: "book.pages") }
            }
        }
    }
}

#Preview {
    ContentView()
}
