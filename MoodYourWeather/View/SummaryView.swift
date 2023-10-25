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
    
    @Query(sort: \Register.date) private var registers: [Register]
    
    @State private var startDate = Date()
    @State private var endDate = Date()
    @State private var customStartDate = Date()
    @State private var customEndDate = Date()
    @State private var filteredRegisters: [Register] = []
    @State private var emojiCounts: Dictionary<String, Int> = [:]
    
    @State private var selectedDateFilter: DateFilter = .last7Days
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    Picker("Date Filter", selection: $selectedDateFilter) {
                        ForEach(DateFilter.allCases, id: \.self) { filter in
                            Text(filter.filterLabel).tag(filter)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if selectedDateFilter == .customDates {
                        HStack {
                            Text("From")
                                .bold()
                                .font(.body)
                                .foregroundStyle(.accent)
                            DatePicker("Start Date", 
                                       selection: $customStartDate,
                                       in: ...customEndDate,
                                       displayedComponents: [.date]
                            )
                                .datePickerStyle(.compact)
                                .labelsHidden() // Hide the label if needed
                            
                            Spacer()
                            Text("To")
                                .bold()
                                .font(.body)
                                .foregroundStyle(.accent)
                            DatePicker("End Date", 
                                       selection: $customEndDate,
                                       in: customStartDate...Date(),
                                       displayedComponents: .date
                            )
                                .datePickerStyle(.compact)
                                .labelsHidden() // Hide the label if needed
                        }
                        
                        
                    }
                    VStack(spacing: 30) {
                        ForEach(homeViewModel.moods) {
                            mood in
                            let (value, emojiCount) = calculateBarValue(mood)
                            HStack(alignment: .center) {
                                EmojiButton(emoji: mood, hasBackground: false)
                                VStack {
                                    GrowingBarView(value: value)
                                        .offset(x:-12.0)
                                        .padding([.top, .bottom])
                                }
                                Text("\(emojiCount)")
                                    .bold()
                                    .font(.title3)
                            }
                            .frame(height: 60)
                            .padding(.trailing, 10)
                        }
                    }
                    .padding()
                    .background(.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 20.0))
                    NavigationLink(destination: RegistersView(registers: filteredRegisters)) {
                        Text("View registers")
                            .buttonStyleModifier(.accentColor)
                    }
                }
                .padding()
                .onAppear {
                    filterRegisters()
                }
                .onChange(of: [selectedDateFilter]) { oldValue, newValue in
                    withAnimation {
                        filterRegisters()
                    }
                }
                .onChange(of: [customStartDate, customEndDate], {
                    withAnimation {
                        filterRegisters()
                    }
                    
                })
                .navigationTitle("Summary")
            }
        }
    }
    
    private func calculateBarValue(_ mood: Mood) -> (Int, Int) {
        let emojiCount = emojiCounts[mood.emoji] ?? 0
        let totalOfRegisters = filteredRegisters.count != 0 ? filteredRegisters.count : 1
        let value = emojiCount * 100 / totalOfRegisters
        return (value, emojiCount)
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
            startDate = customStartDate
            endDate = customEndDate
        }
        self.filteredRegisters = registers.filter { $0.date >= startDate && $0.date <= endDate }.sorted(by:{ $0.date < $1.date } )
        for reg in registers {
            print(reg.date)
        }
        print("=======")
        for reg in filteredRegisters {
            print(reg.date)
        }
        self.calculateEmojiCounts(for: filteredRegisters)
        
    }
    func calculateEmojiCounts(for registers: [Register]) {
        for register in filteredRegisters {
            //            print(register.emojis)
            // Populate dictionary
            let emojis: [String] = register.emojis
            for emoji in emojis {
                emojiCounts[emoji, default: 0] += 1
            }
        }
        print(emojiCounts)
    }
    
}

struct RegistersView: View {
    @Environment(\.modelContext) private var context
    var registers: [Register]
    var body: some View {
        List {
            ForEach(registers) { register in
                Text(register.date.formatted()  )
            }
            .onDelete(perform: { indexSet in
                for index in indexSet {
                    context.delete(registers[index])
                }
            })
        }
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
