//
//  Model.swift
//  MoodYourWeather
//
//  Created by Luigi Cirillo on 19/10/23.
//
import SwiftUI

struct Mood: Identifiable {
    var id : UUID = UUID()
    var name : String
    var emoji : String
    var position: CGPoint = .init(x: 0, y: 0)
}
