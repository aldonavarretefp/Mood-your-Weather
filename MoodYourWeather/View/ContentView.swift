//
//  ContentView.swift
//  MoodYourWeather
//
//  Created by Aldo Yael Navarrete Zamora on 18/10/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State private var showOnboarding = true
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem { Label("Mood your weather", systemImage: "cloud") }
            SummaryView()
                .tabItem { Label("Summary", systemImage: "book.pages") }
        }
        .fullScreenCover(isPresented: $showOnboarding, content: {
            OnboardingView(showOnboarding: $showOnboarding)
        })
    }
}




#Preview {
    ContentView()
}
