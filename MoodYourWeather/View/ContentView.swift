//
//  ContentView.swift
//  MoodYourWeather
//
//  Created by Aldo Yael Navarrete Zamora on 18/10/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) var context
    // Model
    @StateObject private var homeViewModel = HomeViewModel()
    // State variables
    @State private var isTargeted = false
    @State private var canvasImage: UIImage? = nil
    @State private var path: [Register] = []
    @State private var isAlertPresented: Bool = false
    @State private var savedAlert: Bool = false
    @State private var showOnboarding = true
    
    var body: some View {
        VStack {
            TabView {
                NavigationStack(path: $path) {
                    VStack {
                        instructionsText
                        HStack {
                            Canvas(viewModel: homeViewModel)
                                .onDrop(
                                    of: ["public.text"],
                                    isTargeted: $isTargeted,
                                    perform: homeViewModel.dropLogic
                                )
                                
                            Spacer()
                            EmojiPickerView(viewModel: homeViewModel)
                            Spacer()
                        }
                        Spacer()
                        if !homeViewModel.emojisInCanvas.isEmpty {
                            resetButton
                                .transition(.opacity)
                        }
                        doneButtonView
                    }
                    .navigationTitle("Mood Your Weather")
                    .navigationDestination(for: Register.self) { register in
                        SupportAlternative(path: $path, register: register, savedAlert: $savedAlert)
                            .environmentObject(homeViewModel)

                    }
                    .padding()
                    .alert(isPresented: $isAlertPresented) {
                        Alert(title: Text("We are so sorry! "), message: Text("You at least need to have one emoji."))
                    }
                    .alert(isPresented: $savedAlert) {
                        Alert(title: Text("Tracking saved!"))
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
        let clearBackground = Color.clear.background
            
        let controller = UIHostingController(rootView: view.background(.clear))
        
        // Transparent background
        controller.view.backgroundColor = .clear
        
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
                self.homeViewModel.emojisInCanvas = []
                self.homeViewModel.emojisInCanvasSet = Set()
            }
        } label: {
            Text("Reset")
                .buttonStyleModifier(.gray)
            
        }
    }
    
    private var doneButtonView: some View {
        Button {
            if homeViewModel.emojisInCanvas.isEmpty {
                self.isAlertPresented = true
                return
            }
            DispatchQueue.main.async {
                canvasImage = snapshot(Canvas(viewModel: homeViewModel))
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
    ContentView()
}
