//
//  CanvaAndEmojisView.swift
//  MoodYourWeather
//
//  Created by Rosa Laura Vernieri on 18/10/23.
//

import SwiftUI

struct CanvaAndEmojisView: View {
    
    var body: some View {
        
        HStack {
            
            RoundedRectangle(cornerRadius: 30)
                .frame(width: 267.0, height: 400.0)
                .foregroundColor(.white)
                .overlay {
                    RoundedRectangle(cornerRadius: 30)
                        .strokeBorder(lineWidth: 2, antialiased: true)
                        .foregroundColor(Color.blue)
                }
        
            
            VStack {  RoundedRectangle(cornerRadius: 20)
                    .frame(maxWidth: 70, maxHeight: 40)
                    .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.899))
                    .overlay(Text("☀️"))
                    .padding(5)
                
                RoundedRectangle(cornerRadius: 20)
                    .frame(maxWidth: 70, maxHeight: 40)
                    .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.899))
                    .overlay(Text("🌈"))
                    .padding(5)
                
                RoundedRectangle(cornerRadius: 20)
                    .frame(maxWidth: 70, maxHeight: 40)
                    .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.899))
                    .overlay(Text("⛅️"))
                    .padding(5)
                
                RoundedRectangle(cornerRadius: 20)
                    .frame(maxWidth: 70, maxHeight: 40)
                    .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.899))
                    .overlay(Text("🌧️"))
                    .padding(5)
                
                RoundedRectangle(cornerRadius: 20)
                    .frame(maxWidth: 70, maxHeight: 40)
                    .foregroundColor(Color(hue: 1.0, saturation: 0.0, brightness: 0.899))
                    .overlay(Text("🌪️"))
                    .padding(5)
            }
            
            }
        }
}

#Preview {
    CanvaAndEmojisView()
}
