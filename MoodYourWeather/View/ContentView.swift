//
//  ContentView.swift
//  MoodYourWeather
//
//  Created by Aldo Yael Navarrete Zamora on 18/10/23.
//

import SwiftUI

struct ContentView: View {
    
    // Model
    @StateObject private var viewModel = HomeViewModel()
    
    // State variables
    @State private var isTargeted = false
    @State private var canvasImage: UIImage? = nil
    
    var body: some View {
        VStack {
            TabView {
                NavigationStack {
                    VStack {
                        instructionsText
                        HStack {
                            Canvas(viewModel: viewModel)
                                .onDrop(
                                    of: ["public.text"],
                                    isTargeted: $isTargeted,
                                    perform: viewModel.dropLogic
                                )
                            Spacer()
                            EmojiPickerView(viewModel: viewModel)
                            Spacer()
                        }
                        Spacer()
                        if !viewModel.emojisInCanvas.isEmpty {
                            resetButton
                                .transition(.opacity)
                        }
                        
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

extension ContentView {
    
    private var resetButton: some View {
        Button {
            withAnimation {
                self.viewModel.emojisInCanvas = []
                self.viewModel.emojisInCanvasSet = Set()
            }
        } label: {
            Text("Reset")
                .buttonStyleModifier(.gray)
            
        }
    }
    
    private var doneButtonView: some View {
        NavigationLink(destination: Support()) {
            ZStack {
                Text("Done")
                    .buttonStyleModifier(.accent)
            }
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



#Preview {
    ContentView()
}
