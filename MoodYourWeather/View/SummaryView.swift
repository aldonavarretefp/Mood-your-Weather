//
//  SummaryView.swift
//  MoodYourWeather
//
//  Created by Luigi Cirillo on 18/10/23.
//

import SwiftUI

struct SummaryView: View {
    
    @EnvironmentObject private var userDataModel : UserDataModel
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
<<<<<<< HEAD
        ForEach(viewModel.moods) { mood in
            HStack {
                EmojiButton(emoji: mood)
                VStack() {
                    GrowingBarView(value: 1)
                }
                .frame(minHeight: .infinity)
            }
            .frame(height: 60)
=======
        HStack {
            EmojiPickerView(viewModel: viewModel)
            VStack {
                ForEach(viewModel.moods){ emoji in
                    Text("Lorem ipsum")
                }
            }
>>>>>>> main
        }
    }
}
    #Preview {
        SummaryView()
    }
