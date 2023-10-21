//
//  ContentView.swift
//  MoodYourWeather
//
//  Created by Aldo Yael Navarrete Zamora on 18/10/23.
//

import SwiftUI

struct Register: Identifiable, Hashable {
    var id: UUID = UUID()
    let emojis: [String]
    let snapshot: UIImage
    let date: Date
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}

struct ContentView: View {
    
    // Model
    @StateObject private var viewModel = HomeViewModel()
    
    // State variables
    @State private var isTargeted = false
    @State private var canvasImage: UIImage? = nil
    @State private var path: [Register] = []
    @State private var isAlertPresented: Bool = false
    @State private var showOnboarding = true

    
    var body: some View {
        VStack {
            TabView {
                NavigationStack(path: $path) {
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
                    .navigationTitle("Mood Your Weather")
                    .navigationDestination(for: Register.self) { register in
                        SupportAlternative(path: $path, register: register)
                    }
                    .padding()
                    .alert(isPresented: $isAlertPresented) {
                        Alert(title: Text("We are so sorry! "), message: Text("You at least need to have one emoji."))
                    }
                }
                .tabItem { Label("Mood your weather", systemImage: "cloud") }
                SummaryView()
                    .tabItem { Label("Summary", systemImage: "book.pages") }
            }
        }
        .fullScreenCover(isPresented: $showOnboarding, content: {
            OnboardingView(showOnboarding: $showOnboarding)
        })
    }
        
    
    func snapshot<Content: View>(_ view: Content, asImageWithScale scale: CGFloat = 1.0) -> UIImage {
        let controller = UIHostingController(rootView: view)
        let viewSize = controller.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize, withHorizontalFittingPriority: .defaultLow, verticalFittingPriority: .defaultHigh)
        controller.view.bounds = CGRect(origin: .zero, size: CGSize(width: viewSize.width, height: viewSize.height + 60))
        return controller.view.asImage()
    }
}

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        return renderer.image { _ in drawHierarchy(in: bounds, afterScreenUpdates: true) }
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
        Button {
            if viewModel.emojisInCanvas.isEmpty {
                self.isAlertPresented = true
                return
            }
            DispatchQueue.main.async {
                canvasImage = snapshot(Canvas(viewModel: viewModel))
                guard let canvasImage else {
                    print("ERROR: Couldn't generate image from canvas.")
                    return
                }
                let newRegister: Register = .init(emojis: Array(viewModel.emojisInCanvasSet), snapshot: canvasImage, date: .now)
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
    ContentView()
}
