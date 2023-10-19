//
//  View.swift
//  MoodYourWeather
//
//  Created by Aldo Yael Navarrete Zamora on 19/10/23.
//

import SwiftUI

extension View {
    func buttonStyleModifier(_ color: Color, opacity: Double = 1.0) -> some View {
        return self.modifier(ButtonModifier(backgroundColor: color, opacity: opacity))
    }
}

struct ButtonModifier: ViewModifier {
    let backgroundColor: Color
    let opacity: Double
    let opacityRange = 0.0...1.0
    
    init(backgroundColor: Color, opacity: Double = 1.0) {
        self.backgroundColor = backgroundColor
        self.opacity = opacity
    }
    
    func body(content: Content) -> some View {
        content
            .foregroundStyle(.white)
            .font(.subheadline)
            .bold()
            .padding()
            .frame(maxWidth: .infinity)
            .background(backgroundColor.opacity(opacity))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .opacity(opacityRange.contains(opacity) ? opacity : 1.0)
            
    }
}
