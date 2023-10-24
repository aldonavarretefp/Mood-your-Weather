//
//  Canvas.swift
//  MoodYourWeather
//
//  Created by Aldo Yael Navarrete Zamora on 19/10/23.
//

import SwiftUI

struct Canvas: View {
    
    @ObservedObject var viewModel: HomeViewModel
    
    private let canvasFrame: CGSize = .init(width: 267.0, height: 400.0)
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 30)
                .foregroundColor(.canvasColor)
                .overlay {
                    // Border of the canvas.
                    RoundedRectangle(cornerRadius: 30)
                        .strokeBorder(lineWidth: 2, antialiased: true)
                        .foregroundColor(.accentColor)
                }
            ForEach($viewModel.emojisInCanvas) { emoji in
                EmojiView(emoji: emoji, canvasFrame: canvasFrame)
            }
            
        }
        .frame(width: canvasFrame.width, height: canvasFrame.height)
    }
}

#Preview {
    return Canvas(viewModel: HomeViewModel())
}
