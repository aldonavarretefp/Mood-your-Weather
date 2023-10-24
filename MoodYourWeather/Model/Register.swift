//
//  Register.swift
//  MoodYourWeather
//
//  Created by Aldo Yael Navarrete Zamora on 24/10/23.
//

import Foundation
import SwiftData
import UIKit

@Model
class Register: Identifiable, Hashable {
    @Attribute(.unique) var id: String
    var emojis: [String]
    let snapshot: Data?
    let date: Date
    
    init(id: UUID = UUID(), emojis: [String], snapshot: UIImage, date: Date) {
        self.id = id.uuidString
        self.emojis = emojis
        self.snapshot = snapshot.pngData()
        self.date = date
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
}
