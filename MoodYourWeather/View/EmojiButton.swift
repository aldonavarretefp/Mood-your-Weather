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
        ZStack {
            Text(emoji.emoji)
                .font(.title)
                .onDrag {
                    NSItemProvider(object: emoji.emoji as NSString)
                }
                
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 9)
        .background(Color(.systemGray5))
        .clipShape(RoundedRectangle(cornerRadius: 20))
        
        
    }
}

#Preview {
    EmojiButton(emoji: Mood(name: "Prova", emoji: "❤️"))
}
