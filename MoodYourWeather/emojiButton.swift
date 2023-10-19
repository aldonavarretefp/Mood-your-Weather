//
//  emojiButton.swift
//  MoodYourWeather
//
//  Created by Luigi Cirillo on 19/10/23.
//

import SwiftUI

struct emojiButton: View {
    
    var emoji : Moods
    var body: some View {
        
        Text(emoji.emoji)
            .font(.title3)
            .bold()
            .padding(.horizontal, 25)
            .padding(.vertical, 9)
            .background(Color(.systemGray5))
            .clipShape(RoundedRectangle(cornerRadius: 20))
    }
}

#Preview {
    emojiButton(emoji: Moods(name: "Prova", emoji: "❤️"))
}
