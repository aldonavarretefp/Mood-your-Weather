//
//  ViewModel.swift
//  MoodYourWeather
//
//  Created by Luigi Cirillo on 19/10/23.
//

import Foundation

class ContentViewModel {
    var moods : [Mood] = [
        Mood(name: "Sun", emoji: "☀️"),
        Mood(name: "Rainbow", emoji: "🌈"),
        Mood(name: "Cloudy", emoji: "⛅️"),
        Mood(name: "Rainy", emoji: "🌦️"),
        Mood(name: "Tornado", emoji: "🌪️")
    ]
}
