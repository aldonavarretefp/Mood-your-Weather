//
//  MoodYourWeatherApp.swift
//  MoodYourWeather
//
//  Created by Aldo Yael Navarrete Zamora on 18/10/23.
//

import SwiftUI
import SwiftData

@main
struct MoodYourWeatherApp: App {
    
    @StateObject private var userDataModel = UserDataModel()
//    @StateObject private var summaryViewModel = SummaryViewModel()
    
    let container: ModelContainer = {
        let schema = Schema([Register.self]);
        let container = try! ModelContainer(for: schema, configurations: []);
        return container;
    }();
    
    init() {
        // Large and inline navigation title appereance.
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.accent]
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: UIColor.accent]
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(userDataModel)
                .modelContainer(container)
        }
    }
}
