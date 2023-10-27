//
//  ViewModel.swift
//  MoodYourWeather
//
//  Created by Luigi Cirillo on 19/10/23.
//
import SwiftUI

class HomeViewModel: ObservableObject {
    @Published var moods : [Mood] = [
        Mood(name: "Sun", emoji: "☀️"),
        Mood(name: "Rainbow", emoji: "🌈"),
        Mood(name: "Cloudy", emoji: "⛅️"),
        Mood(name: "Rainy", emoji: "🌧️"),
        Mood(name: "Tornado", emoji: "🌪️")
    ]
    @Published var originalMoods : [Mood] = [
        Mood(name: "Sun", emoji: "☀️"),
        Mood(name: "Rainbow", emoji: "🌈"),
        Mood(name: "Cloudy", emoji: "⛅️"),
        Mood(name: "Rainy", emoji: "🌧️"),
        Mood(name: "Tornado", emoji: "🌪️")
    ]
    @Published var emojisInCanvas: Array<Mood> = []
    @Published var emojisInCanvasSet: Set<String> = Set()
    
    func dropLogic(providers: [NSItemProvider], location: CGPoint) -> Bool {
        guard let provider = providers.first else { return false }
        provider.loadObject(ofClass: NSString.self) { item, error in
            if let error = error {
                print("ERROR: \(error.localizedDescription)")
                return
            }
            guard let text = item as? String, !self.emojisInCanvasSet.contains(text) else {
                return
            }
            let position = CGPoint(x: location.x, y: location.y)
            /*
             * Appending emojisInCanvas array the new emoji and insert the actual String into the set in order
             * to compare
             */
            DispatchQueue.main.async {
                withAnimation {
                    let emoji = Mood(name: "asdas", emoji: text, position: position)
                    self.moods = self.moods.filter({$0.emoji != emoji.emoji })
                    self.emojisInCanvas.append(emoji)
                    self.emojisInCanvasSet.insert(emoji.emoji)
                    print(location, self.emojisInCanvasSet)
                    
                }
            }
            
        }
        return true
    }
    
    func snapshot<Content: View>(_ view: Content, asImageWithScale scale: CGFloat = 1.0) -> UIImage {
        let controller = UIHostingController(rootView: view.background(.clear))
        
        // Transparent background
        controller.view.backgroundColor = .clear
        
        let viewSize = controller.view.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize, withHorizontalFittingPriority: .defaultLow, verticalFittingPriority: .defaultHigh)
        controller.view.bounds = CGRect(origin: .zero, size: CGSize(width: viewSize.width, height: viewSize.height + 60))
        return controller.view.asImage()
    }
    
    func resetHomeView() {
        self.emojisInCanvas = []
        self.emojisInCanvasSet = Set()
        self.moods = self.originalMoods
    }
}
