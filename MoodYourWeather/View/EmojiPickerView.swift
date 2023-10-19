//
//  EmojiPickerView.swift
//  MoodYourWeather
//
//  Created by Aldo Yael Navarrete Zamora on 19/10/23.
//

import SwiftUI

struct EmojiPickerView: View {
    
    var viewModel: ContentViewModel = ContentViewModel()
    
    var body: some View {
        VStack {
            ForEach(viewModel.moods) {
                mood in
                EmojiButton(emoji: mood)
                    
            }
        }
    }
}

#Preview {
    EmojiPickerView()
}
