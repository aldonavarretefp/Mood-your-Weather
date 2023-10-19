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
    @StateObject private var viewModel = ContentViewModel()
    
    // State variables
    @State private var isTargeted = false
    @State private var canvasImage: UIImage? = nil
    @State private var availableEmojiTypes: Set<String> = Set(["😀", "😍", "🚀", "🌈", "🐱", "🎉"])
    
    var body: some View {
        VStack {
            TabView {
                NavigationStack {
                    VStack {
                        instructionsText
                        HStack {
                            Canvas(viewModel: viewModel)
                                .onDrop(of: ["public.text"], isTargeted: $isTargeted) { providers, location in
                                    if let provider = providers.first {
                                        provider.loadObject(ofClass: NSString.self) { item, error in
                                            guard let text = item as? String,!viewModel.emojisInCanvasSet.contains(text)  else { return }
                                            let position = CGPoint(x: location.x, y: location.y)
                                            let emoji = Mood(name: "asdas", emoji: text, position: position)
                                            DispatchQueue.main.async {
                                                viewModel.emojisInCanvas.append(emoji)
                                                viewModel.emojisInCanvasSet.insert(emoji.emoji)
                                                print(location, viewModel.emojisInCanvasSet)
                                            }
                                        }
                                    }
                                    return true
                                }
                            Spacer()
                            EmojiPickerView(viewModel: viewModel)
                            Spacer()
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
