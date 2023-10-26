//
//  DataManager.swift
//  MoodYourWeather
//
//  Created by Duilio Barbato on 25/10/23.
//

import Foundation

class DataManager {
    func fetchData(completion: @escaping (Dictionary<String, String>) -> Void) {
        guard let url = Bundle.main.url(forResource: "tips", withExtension: "json") else {
            print("Failed to find JSON file")
            completion([:])
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                print("Error fetching data: \(error.localizedDescription)")
                completion([:])
                return
            }
            
            guard let jsonData = data else {
                print("No data found")
                completion([:])
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let decodedData = try decoder.decode(Dictionary<String, String>.self, from: jsonData)
                
                // Sort the dictionary by keys
                let sortedData = decodedData.sorted(by: { $0.key < $1.key })
                let sortedDictionary = Dictionary(uniqueKeysWithValues: sortedData)
                
                completion(sortedDictionary)
            } catch {
                print(String(describing: error))
                completion([:])
            }
        }.resume()
    }
}
