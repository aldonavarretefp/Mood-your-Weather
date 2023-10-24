//
//  UIView.swift
//  MoodYourWeather
//
//  Created by Aldo Yael Navarrete Zamora on 25/10/23.
//

import Foundation
import SwiftUI

extension UIView {
    func asImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(size: self.bounds.size)
        return renderer.image { _ in drawHierarchy(in: bounds, afterScreenUpdates: true) }
    }
}
