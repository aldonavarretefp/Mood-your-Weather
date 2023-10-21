//
//  GrowingBarView.swift
//  MoodYourWeather
//
//  Created by Duilio Barbato on 21/10/23.
//

import SwiftUI

struct GrowingBarView: View {
    
    var value : Int
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: self.calculateWidth(geometry: geometry), height: 30)
                    .foregroundStyle(.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
            }
        }
    }
    
    func calculateWidth(geometry: GeometryProxy) -> CGFloat {
        let maxWidth = geometry.size.width
        return CGFloat(self.value) / 100 * maxWidth
    }
}

#Preview {
    GrowingBarView(value: 30)
}
