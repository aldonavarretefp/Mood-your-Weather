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
    @State private var savedAlert: Bool = false
    var body: some View {
        NavigationStack(path: $path) {
            VStack(spacing: 30) {
                instructionsText
                HStack {
                    Canvas()
                        .environmentObject(homeViewModel)
                    Spacer()
                    EmojiPickerView(viewModel: homeViewModel)
                    Spacer()
                }
                Spacer()
                VStack {
                    if !homeViewModel.emojisInCanvas.isEmpty {
                        resetButton
                    }
                    doneButtonView
                        .alert(isPresented: $isAlertPresented) {
                            Alert(title: Text("We are so sorry! "), message: Text("You at least need to have one emoji."))
                        }
                }
            }
            .navigationTitle("Mood Your Weather")
            .navigationDestination(for: Register.self) { register in
                SupportAlternative(path: $path, register: register, savedAlert: $savedAlert)
                    .environmentObject(homeViewModel)
            }
            .padding()
            
            .alert(isPresented: $savedAlert) {
                Alert(title: Text("Tracking saved!"))
            }
        }
    }
}

extension HomeView {
    
    private var resetButton: some View {
        Button {
            withAnimation {
                self.homeViewModel.emojisInCanvas = []
                self.homeViewModel.emojisInCanvasSet = Set()
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
                print(homeViewModel.emojisInCanvas, homeViewModel.emojisInCanvasSet)
                if homeViewModel.emojisInCanvas.count == 0 {
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
            .font(.headline)
            .fontWeight(.regular)
            .frame(maxWidth: .infinity, alignment: .leading)
            .foregroundStyle(.accent)
    }
}

#Preview {
    HomeView()
}
