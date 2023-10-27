//
//  RegisterCard.swift
//  MoodYourWeather
//
//  Created by Aldo Yael Navarrete Zamora on 26/10/23.
//

import SwiftUI

struct RegisterCard: View {
    
    let register: Register
    let tips: Dictionary<String, String>
    
    private let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEE, MMM d"
        return dateFormatter
    }()
    
    var body: some View {
        NavigationLink(destination:
                        RegisterSummaryView(register: register, tips: tips)
                            .navigationTitle("\(formatter.string(from: register.date))")
        ) {
            ZStack(alignment: .bottomLeading) {
                if let snapshot = register.snapshot, let uiImage = UIImage(data: snapshot) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .overlay(
                            Color.black.opacity(0.8)
                                .clipShape(RoundedRectangle(cornerRadius: 10.0))
                                .mask(LinearGradient(gradient: Gradient(colors: [.black, .clear]), startPoint: .bottom, endPoint: .center))
                        )
                }
                Text("\(formatter.string(from: register.date))")
                    .font(.body)
                    .bold()
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)
                    .padding()
            }
        }
        
        
    }
}

#Preview {
    RegisterCard(register: .init(emojis: [], snapshot: UIImage(named: "background")!, date: .now), tips: [:])
}
