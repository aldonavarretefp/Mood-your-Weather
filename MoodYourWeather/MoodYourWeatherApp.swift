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
                .modelContainer(container)
        }
    }
}
