//
//  RegisterSummaryView.swift
//  MoodYourWeather
//
//  Created by Aldo Yael Navarrete Zamora on 27/10/23.
//

import SwiftUI

struct RegisterSummaryView: View {
    var register: Register
    @State private var pickerSelection: String
    var tips : Dictionary<String, String> = [:]
    
    init(register: Register, tips: Dictionary<String, String> = [:], pickerSelection: String = "") {
        self.register = register
        self.pickerSelection = register.emojis.first!
        self.tips = tips
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 25) {
                if let snapshot = register.snapshot, let uiImage = UIImage(data: snapshot)  {
                    Image(uiImage: uiImage)
                        .resizable()
                        .offset(y: -60) // Translating the image upwards
                        .scaledToFit()
                        .clipped()
                        .frame(width: 300)
                        .padding(.bottom, -55)
                }
                if register.emojis.count != 1 {
                    Picker("", selection: $pickerSelection) {
                        ForEach(0..<register.emojis.count, id: \.self) { index in
                            let emoji = register.emojis[index]
                            Text(emoji).tag(emoji)
                        }
                    }
                    .pickerStyle(.segmented)
                    Text(Constants.emojisDescription[pickerSelection] ?? "")
                        .transition(.opacity)
                }
                Tip(register: register, tips: self.tips)
            }
            .padding()
        }
        
    }
}

#Preview {
    RegisterSummaryView(register: .init(emojis: [], snapshot: UIImage(named: "background")!, date: .now))
}
