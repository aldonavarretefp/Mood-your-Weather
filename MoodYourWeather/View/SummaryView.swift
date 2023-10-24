//
//  SummaryView.swift
//  MoodYourWeather
//
//  Created by Luigi Cirillo on 18/10/23.
//

import SwiftUI
import SwiftData

//class SummaryViewModel: ObservableObject {
//    @Query fileprivate var registers: [Register]
//}

struct SummaryView: View {
    
    enum DateFilter: Int, CaseIterable {
        case last7Days
        case lastMonth
        case customDates
        
        var filterLabel: String {
            switch self {
            case .last7Days: return "Last 7 Days"
            case .lastMonth: return "Last Month"
            case .customDates: return "Custom Dates"
            }
        }
    }
    
    @Environment(\.modelContext) private var context
    
    @EnvironmentObject private var userDataModel : UserDataModel
    @StateObject private var homeViewModel = HomeViewModel()
    
    @Query fileprivate var registers: [Register]
    
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var filteredRegisters: [Register] = []
    @State private var emojiCounts: Dictionary<String, Int> = [:]
    
    @State private var selectedDateFilter: DateFilter = .last7Days
    
    var body: some View {
        NavigationStack {
            VStack {
                Picker("Date Filter", selection: $selectedDateFilter) {
                    ForEach(DateFilter.allCases, id: \.self) { filter in
                        Text(filter.filterLabel).tag(filter)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                if selectedDateFilter == .customDates {
                    VStack {
                        HStack {
                            Text("From:")
                                .bold()
                                .font(.body)
                            DatePicker("Start Date", selection: $startDate, displayedComponents: [.date, .hourAndMinute])
                                .datePickerStyle(.compact)
                                .labelsHidden() // Hide the label if needed
                        }
                        HStack {
                            Text("To:")
                                .bold()
                                .font(.body)
                            DatePicker("End Date", selection: $endDate, displayedComponents: [.date, .hourAndMinute])
                                .datePickerStyle(.compact)
                                .labelsHidden() // Hide the label if needed
                        }
                    }
                    
                }
                ForEach(homeViewModel.moods) {
                    mood in
                    let emojiCount = emojiCounts[mood.emoji] ?? 0
                    let totalOfRegisters = filteredRegisters.count != 0 ? filteredRegisters.count : 1
                    let value = emojiCount * 100 / totalOfRegisters
                    HStack {
                        EmojiButton(emoji: mood)
                        VStack(alignment: .center) {
                            // 100 -> filteredRegisters.count
                            // value -> emojisCount[emoji.emoji[
                            GrowingBarView(value: value)
                                .padding(.top)
                        }
                        Text("\(emojiCount)")
                            .bold()
                    }
                    .frame(height: 60)
                    
                }
                HStack {
                    Text("Registers")
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(.accent)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                List {
                    ForEach(filteredRegisters) { register in
                        NavigationLink(register.date.formatted(date: .long, time: .omitted), destination: RegisterDetailView(register: register)
                            .environmentObject(homeViewModel)
                        )
                    }
                }
                .listStyle(.grouped)
                Spacer()
                
                
            }
            .padding()
            .onAppear {
                filterRegisters()
            }
            .onChange(of: [selectedDateFilter]) { oldValue, newValue in
                filterRegisters()
        }
        }
    }
    func filterRegisters () {
        emojiCounts = [:]
        switch selectedDateFilter {
        case .last7Days:
            let last7Days = Calendar.current.date(byAdding: .day, value: -7, to: Date())!
            startDate = last7Days
            endDate = Date()
        case .lastMonth:
            let lastMonth = Calendar.current.date(byAdding: .month, value: -1, to: Date())!
            startDate = lastMonth
            endDate = Date()
        default:
            break
        }
        self.filteredRegisters = registers.filter { $0.date >= startDate && $0.date <= endDate }
        self.calculateEmojiCounts(for: filteredRegisters)
        
    }
    func filterChanged(to newValue: DateFilter) {
            selectedDateFilter = newValue
            filterRegisters()
        }
    func calculateEmojiCounts(for registers: [Register]) {
        //        emojiCounts = Dictionary(uniqueKeysWithValues: filteredRegisters.map { ($0.emojis, 0) })
        for register in filteredRegisters {
            print(register.emojis)
            // Populate dictionary
            let emojis: [String] = register.emojis
            for emoji in emojis {
                emojiCounts[emoji, default: 0] += 1
            }
        }
        print(emojiCounts)
    }
}

struct RegisterDetailView: View {
    @EnvironmentObject private var homeViewModel: HomeViewModel
    var register: Register
    var body: some View {
        VStack {
            if let snapshot = register.snapshot, let uiImage = UIImage(data: snapshot) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                    .shadow(radius: 2)
            }
            ForEach(homeViewModel.moods) {
                mood in
//                let emojiCount = emojiCounts[mood.emoji] ?? 0
//                let totalOfRegisters = filteredRegisters.count != 0 ? filteredRegisters.count : 1
//                let value = emojiCount * 100 / totalOfRegisters
                HStack {
                    EmojiButton(emoji: mood)
                    VStack(alignment: .center) {
                        // 100 -> filteredRegisters.count
                        // value -> emojisCount[emoji.emoji[
                        GrowingBarView(value: 10)
                            .padding(.top)
                    }
                    Text("\(10)")
                        .bold()
                }
                .frame(height: 60)
                
            }
            
        }
        .navigationTitle("Recap on \(register.date.formatted())")
    }
}

#Preview {
    SummaryView()
}
