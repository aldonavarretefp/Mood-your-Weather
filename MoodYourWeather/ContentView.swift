//
//  ContentView.swift
//  MoodYourWeather
//
//  Created by Aldo Yael Navarrete Zamora on 18/10/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    var viewModel = MoodsViewModel()

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
                        
                        HStack{
                            canvas
                            Spacer()
                            VStack{
                                ForEach(viewModel.moods) {
                                    mood in
                                    emojiButton(emoji: mood)
                                        
                                }
                            }
                        }
                        
                        
                        Spacer()
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

extension ContentView{
    private var canvas : some View {
        RoundedRectangle(cornerRadius: 30)
            .frame(width: 267.0, height: 400.0)
            .foregroundColor(.white)
            .overlay {
                RoundedRectangle(cornerRadius: 30)
                    .strokeBorder(lineWidth: 2, antialiased: true)
                    .foregroundColor(Color.accentColor)
            }
    }
}
