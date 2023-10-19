//
//  EmojiView.swift
//  MoodYourWeather
//
//  Created by Aldo Yael Navarrete Zamora on 17/10/23.
//

import SwiftUI

struct EmojiView: View {
    
    @Binding var emoji: Mood
    
    let canvasFrame: CGSize
    
    @State private var dragOffset: CGSize = .zero
    
    var body: some View {
        Text(emoji.emoji)
            .font(.largeTitle)
            .position(
                CGPoint(
                    x: emoji.position.x + dragOffset.width,
                    y: emoji.position.y + dragOffset.height
                )
            )
            .gesture(
                DragGesture()
                    .onChanged { gesture in
                        let newPosition = CGPoint(
                            x: emoji.position.x + gesture.translation.width,
                            y: emoji.position.y + gesture.translation.height
                        )
                        
                        // Prevent dragging outside the canvas boundaries
                        if newPosition.x >= 0 && newPosition.x <= canvasFrame.width && newPosition.y >= 0 && newPosition.y <= canvasFrame.height {
                            dragOffset = gesture.translation
                        }
                    }
                    .onEnded { gesture in
                        // Update the emoji's position within the canvas bounds
                        let newPosition = CGPoint(
                            x: max(0, min(emoji.position.x + gesture.translation.width, canvasFrame.width)),
                            y: max(0, min(emoji.position.y + gesture.translation.height, canvasFrame.height))
                        )
                        emoji.position = newPosition
                        // Reset the drag offset
                        dragOffset = .zero
                    }
            )
    }
}

#Preview {
    EmojiView(emoji: .constant(.init(name: "eas", emoji: "🇮🇹", position: .init(x: 50, y: 50))), canvasFrame: .init(width: 267.0, height: 400.0))
}
