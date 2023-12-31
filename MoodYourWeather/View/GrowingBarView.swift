//
//  GrowingBarView.swift
//  MoodYourWeather
//
//  Created by Duilio Barbato on 21/10/23.
//

import SwiftUI

struct GrowingBarView: View {
    
    var value : Int
    var animationDuration: Double = 0.5 // Animation duration in seconds
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(.blue.opacity(0.3))
                    .frame(width: geometry.size.width)
                
                Rectangle()
                    .frame(width: self.calculateWidth(geometry: geometry))
                    .foregroundStyle(.blue)
                    .modifier(BarAnimationModifier(duration: animationDuration))
            }
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding(0)
            
        }
    }
    
    func calculateWidth(geometry: GeometryProxy) -> CGFloat {
        
        let maxWidth = geometry.size.width
        return CGFloat(self.value) / 100 * maxWidth
    }
    
}

struct BarAnimationModifier: AnimatableModifier {
    var width: CGFloat = 0
    var animatableData: CGFloat {
        get { width }
        set { width = newValue }
    }
    
    var duration: Double

    func body(content: Content) -> some View {
        content
            .frame(width: width, alignment: .leading)
            .transition(.slide.animation(.easeIn(duration: 3)))
    }
}





#Preview {
    GrowingBarView(value: 30)
}
