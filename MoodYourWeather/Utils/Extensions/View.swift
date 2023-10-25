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
    func border(width: CGFloat, edges: [Edge], color: Color) -> some View {
        overlay(EdgeBorder(width: width, edges: edges).foregroundColor(color))
    }
    
}

struct EdgeBorder: Shape {
    var width: CGFloat
    var edges: [Edge]

    func path(in rect: CGRect) -> Path {
        edges.map { edge -> Path in
            switch edge {
            case .top: return Path(.init(x: rect.minX, y: rect.minY, width: rect.width, height: width))
            case .bottom: return Path(.init(x: rect.minX, y: rect.maxY - width, width: rect.width, height: width))
            case .leading: return Path(.init(x: rect.minX, y: rect.minY, width: width, height: rect.height))
            case .trailing: return Path(.init(x: rect.maxX - width, y: rect.minY, width: width, height: rect.height))
            }
        }.reduce(into: Path()) { $0.addPath($1) }
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
