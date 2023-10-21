//
//  UserDataModel.swift
//  MoodYourWeather
//
//  Created by Duilio Barbato on 21/10/23.
//

import Foundation
import SwiftUI

class UserDataModel: ObservableObject {
    @Published var userDataModel: User
    
    init() {
        self.userDataModel = User(id: UUID(), registers: [Register(emojis: ["😀"], snapshot: UIImage(systemName: "circle.fill")!, date: .now)])
    }
}
