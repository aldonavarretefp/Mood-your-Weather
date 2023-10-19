//
//  ContentView.swift
//  MoodYourWeather
//
//  Created by Aldo Yael Navarrete Zamora on 18/10/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    // Model
    var viewModel: ContentViewModel = ContentViewModel()
    
    // State variables
    @State private var isTargeted = false
    @State private var emojisInCanvas: [Mood] = []
    @State private var canvasImage: UIImage? = nil
    @State private var availableEmojiTypes: Set<String> = Set(["😀", "😍", "🚀", "🌈", "🐱", "🎉"])
    
    var body: some View {
        VStack {
            TabView {
                NavigationStack {
                    VStack {
                        instructionsText
                        HStack {
                            canvas
                            Spacer()
                            EmojiPickerView()
                        }
                        Spacer()
                        doneButtonView
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

extension ContentView {
    
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
    
    private var doneButtonView: some View {
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
    
    private var instructionsText: some View {
        Text("Drag and drop the emojis to express yourself and mood your weather.")
            .font(.headline)
            .fontWeight(.regular)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(.accent)
    }
}
