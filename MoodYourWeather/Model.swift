//
//  Model.swift
//  MoodYourWeather
//
//  Created by Luigi Cirillo on 19/10/23.
//

import Foundation

import SwiftUI

struct Moods : Identifiable {
    var id : UUID = UUID()
    var name : String
    var emoji : String
}
