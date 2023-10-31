//
//  HomeView.swift
//  MoodYourWeather
//
//  Created by Aldo Yael Navarrete Zamora on 25/10/23.
//

import SwiftUI

struct HomeView: View {
    @Environment(\.modelContext) var context
    
    // Model
    @StateObject private var homeViewModel = HomeViewModel()
    // State variables
    @State private var canvasImage: UIImage? = nil
    @State private var path: [Register] = []
    @State private var isAlertPresented: Bool = false
    
    
    var body: some View {
        NavigationStack(path: $path) {
            VStack(alignment: .leading, spacing: 30) {
                    instructionsText
                HStack {
                    Canvas()
                        .shadow(radius: 10)
                        .environmentObject(homeViewModel)
                    Spacer()
                    EmojiPickerView(viewModel: homeViewModel)
                    
                }
                Spacer()
                VStack {
                    if !homeViewModel.emojisInCanvas.isEmpty {
                        resetButton
                    }
                    doneButtonView
                        
                }
            }
            .padding()
            .navigationTitle("Mood Your Weather")
            .navigationDestination(for: Register.self) { register in
                SupportAlternative(path: $path, register: register)
                    .environmentObject(homeViewModel)
            }
            .alert(isPresented: $isAlertPresented) {
                Alert(title: Text("We are so sorry! "), message: Text("You at least need to have one emoji."))
            }
        }
    }
    
}

extension HomeView {
    
    private var resetButton: some View {
        Button {
            withAnimation {
                homeViewModel.resetHomeView()
            }
        } label: {
            Text("Reset")
                .buttonStyleModifier(.gray)
            
        }
        .transition(.opacity)
    }
    
    private var doneButtonView: some View {
        Button {
            DispatchQueue.main.async {
                if homeViewModel.emojisInCanvas.isEmpty {
                    isAlertPresented = true
                    return
                }
                canvasImage = homeViewModel.snapshot(Canvas().environmentObject(homeViewModel))
                guard let canvasImage else {
                    print("ERROR: Couldn't generate image from canvas.")
                    return
                }
                let newRegister: Register = .init(emojis: Array(homeViewModel.emojisInCanvasSet), snapshot: canvasImage, date: .now)
                path.append(newRegister)
            }
        } label: {
            Text("Done")
                .buttonStyleModifier(.accent)
        }
    }
    
    private var instructionsText: some View {
        Text("Drag and drop the emojis to express yourself and mood your weather.")
            .font(.title2)
            .fontWeight(.regular)
            .foregroundStyle(.accent)
            
    }
}

#Preview {
    HomeView()
}
