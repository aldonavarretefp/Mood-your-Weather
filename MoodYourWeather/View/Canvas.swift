//
//  Canvas.swift
//  MoodYourWeather
//
//  Created by Aldo Yael Navarrete Zamora on 19/10/23.
//

import SwiftUI

struct Canvas: View {

    @EnvironmentObject private var homeViewModel: HomeViewModel
    @State private var isTargeted = false
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
            ForEach($homeViewModel.emojisInCanvas) { emoji in
                EmojiView(emoji: emoji, canvasFrame: canvasFrame)
            }
            
        }
        .onDrop(
            of: ["public.text"],
            isTargeted: $isTargeted,
            perform: homeViewModel.dropLogic
        )
        
        .frame(width: canvasFrame.width, height: canvasFrame.height)
    }
}

#Preview {
    return Canvas()
        .environmentObject(HomeViewModel())
}
