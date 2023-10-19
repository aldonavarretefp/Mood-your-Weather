//
//  emojiButton.swift
//  MoodYourWeather
//
//  Created by Luigi Cirillo on 19/10/23.
//

import SwiftUI

struct EmojiButton: View {
    var emoji : Mood
    var body: some View {
        Text(emoji.emoji)
            .font(.title3)
            .bold()
            .padding(.horizontal, 25)
            .padding(.vertical, 9)
            .background(Color(.systemGray5))
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
    
    var position: CGPoint = .init(x: 0, y: 0)
}

#Preview {
    EmojiButton(emoji: Mood(name: "Prova", emoji: "❤️"))
}
