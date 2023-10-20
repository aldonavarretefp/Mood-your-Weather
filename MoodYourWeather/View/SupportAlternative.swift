//
//  SupportAlternative.swift
//  MoodYourWeather
//
//  Created by Aldo Yael Navarrete Zamora on 19/10/23.
//

import SwiftUI

struct SupportAlternative: View {
    
    @Binding var path: [Register]
    let register: Register?
    
    @State private var pickerSelection: String = ""
    
    init(path: Binding<[Register]>, register: Register) {
        self._path = path
        self.register = register
        self.pickerSelection = register.emojis.first ?? ""
    }
    var body: some View {
        if let register {
            ScrollView {
                VStack {
                    Image(uiImage: register.snapshot)
                        .resizable()
                        .offset(y: -60) // Translating the image upwards
                        .scaledToFit()
                        .clipped()
                        .frame(width: 300)
                        .border(.blue)
                    Text("ID of Register")
                        .bold()
                        .font(.headline)
                    Text(register.id.uuidString)
                    Text("Date of Register")
                        .bold()
                        .font(.headline)
                    Text(register.date.formatted(.dateTime))
                    HStack(spacing: 8) {
                        ForEach(register.emojis, id: \.self) { emoji in
                            EmojiButton(emoji: .init(name: "asda", emoji: emoji))
                        }
                    }
                    
                    Picker("", selection: $pickerSelection) {
                        ForEach(0..<register.emojis.count, id: \.self) { index in
                            let emoji = register.emojis[index]
                            Text(emoji).tag(emoji)
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding()
            }
            .navigationTitle("Support")
        }
    }
}

#Preview {
    SupportAlternative(path: .constant([
        .init(emojis: ["🍎"], snapshot: UIImage(), date: Date())
    ]), register: .init(emojis: ["💯"], snapshot: UIImage(systemName: "circle.fill")!, date: .now))
}