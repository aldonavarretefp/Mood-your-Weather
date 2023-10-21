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
        HStack {
            EmojiPickerView(viewModel: viewModel)
            VStack {
                ForEach(viewModel.moods){ emoji in
                    Text("Lorem ipsum")
                }
            }
        }
    }
}

#Preview {
    SummaryView()
}
