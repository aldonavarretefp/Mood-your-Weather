//
//  SupportAlternative.swift
//  MoodYourWeather
//
//  Created by Aldo Yael Navarrete Zamora on 19/10/23.
//

import SwiftUI

struct SupportAlternative: View {
    let register: Register?
    @EnvironmentObject private var homeViewModel: HomeViewModel
    @EnvironmentObject private var notificationsManager: NotificationsManager
    @Binding var path: [Register]
    @Environment(\.modelContext) private var context
    
    @State private var tips : Dictionary<String, String> = [:]
    private var dataManager: DataManager = DataManager()
    
    init(path: Binding<[Register]>, register: Register) {
        self._path = path
        self.register = register
    }
    
    var body: some View {
        if let register {
            ScrollView {
                VStack(spacing: 25) {
                    RegisterSummaryView(register: register, tips: tips)
                    Button {
                        saveRegisterInDB(register)
                        notificationsManager.createNotification()
                    } label: {
                        Text("Save")
                            .buttonStyleModifier(.accent)
                    }
                    Button {
                        let registers = generateMockData()
                        for r in registers {
                            context.insert(r)
                        }
                    } label: {
                        Text("Mock Data")
                            .buttonStyleModifier(.accent)
                    }
                }
                .padding()
            }
            .navigationTitle("Support")
            .onAppear() {
                dataManager.fetchData { jsonTips in
                    tips = jsonTips
                }
            }
        }
    }
    
    
    private func saveRegisterInDB(_ register: Register) {
        context.insert(register) /// Save data in DB.
        self.homeViewModel.resetHomeView()
        path = [] /// Pop to root view
    }
    func generateMockData() -> [Register] {
            var mockData: [Register] = []
            
            // Load the background image from the assets
            let backgroundImage = UIImage(named: "background")!
            
            // Create a date range from 2018 to 2023
            let calendar = Calendar.current
            let startDate = calendar.date(from: DateComponents(year: 2018, month: 1, day: 1))!
            let endDate = calendar.date(from: DateComponents(year: 2023, month: 12, day: 31))!
            
            // Generate mock data with random dates
            for _ in 0..<10 { // Adjust the number of mock data entries as needed
                let emojis = ["☀️", "🌧️", "🌈"] // Sample emojis
                let randomDate = Date.randomBetween(start: startDate, end: endDate)
                
                // Create a new register with the background image, random date, and emojis
                let newRegister = Register(emojis: emojis, snapshot: backgroundImage, date: randomDate)
                
                mockData.append(newRegister)
            }
            
            return mockData
        }
}

#Preview {
    Group {
        SupportAlternative(path: .constant([
            .init(emojis: ["🍎"], snapshot: UIImage(), date: Date())
        ]), register: .init(emojis: ["🌧️","☀️"], snapshot: UIImage(systemName: "circle.fill")!, date: .now))
    }
    
}

extension Date {
    
    static func randomBetween(start: String, end: String, format: String = "yyyy-MM-dd") -> String {
        let date1 = Date.parse(start, format: format)
        let date2 = Date.parse(end, format: format)
        return Date.randomBetween(start: date1, end: date2).dateString(format)
    }

    static func randomBetween(start: Date, end: Date) -> Date {
        var date1 = start
        var date2 = end
        if date2 < date1 {
            let temp = date1
            date1 = date2
            date2 = temp
        }
        let span = TimeInterval.random(in: date1.timeIntervalSinceNow...date2.timeIntervalSinceNow)
        return Date(timeIntervalSinceNow: span)
    }

    func dateString(_ format: String = "yyyy-MM-dd") -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }

    static func parse(_ string: String, format: String = "yyyy-MM-dd") -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = NSTimeZone.default
        dateFormatter.dateFormat = format

        let date = dateFormatter.date(from: string)!
        return date
    }
}
