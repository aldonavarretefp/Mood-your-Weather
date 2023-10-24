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
        VStack {
            ForEach(viewModel.moods) {
                mood in
                HStack {
                    EmojiButton(emoji: mood)
                    VStack(alignment: .center) {
                        GrowingBarView(value: 10)
                            .padding(.top)
                    }
                    Text("12")
                        .bold()
                }
                .frame(height: 60)
                
            }
            Spacer()
        }
        .padding()
    }
}

#Preview {
    SummaryView()
}
