//
//  Tip.swift
//  MoodYourWeather
//
//  Created by Aldo Yael Navarrete Zamora on 26/10/23.
//

import SwiftUI

struct Tip : View {
    let register : Register?
    let tips : Dictionary<String, String>
    
    init(register: Register?, tips: Dictionary<String, String>) {
        self.register = register
        self.tips = tips
    }
    var body : some View {
        if let emojis = register?.emojis.sorted().joined(), let description = tips[emojis]?.description {
            Text(description)
                .font(.italic(.body)())
                .padding()
                .background(.gray.opacity(0.1))
                .foregroundStyle(.accent)
                .border(width: 1.0, edges: [.leading], color: .accent)
        }
    }
}

#Preview {
    Tip(register: .init(emojis: [], snapshot: UIImage(), date: .now), tips: [:])
}
