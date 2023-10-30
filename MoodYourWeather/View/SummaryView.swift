//
//  SummaryView.swift
//  MoodYourWeather
//
//  Created by Luigi Cirillo on 18/10/23.
//

import SwiftUI
import SwiftData

extension SummaryView {
    
    @Observable
    class SummaryViewModel: ObservableObject {
        var modelContext: ModelContext
        var selectedDateFilter: DateFilter = .last7Days
        var startDate = Date()
        var endDate = Date()
        var customStartDate = Date()
        var customEndDate = Date()
        var filteredRegisters: [Register] = []
        var emojiCounts: Dictionary<String, Int> = [:]
        var registers = [Register]()
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
        
        init(modelContext: ModelContext) {
            self.modelContext = modelContext
            fetchData()
        }
        
         private func fetchData() {
            do {
                let descriptor = FetchDescriptor<Register>()
                registers = try modelContext.fetch(descriptor)
            } catch {
                print("Fetch failed")
            }
        }
        func calculateBarValue(_ mood: Mood) -> (Int, Int) {
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
            self.calculateEmojiCounts(for: filteredRegisters)
            
        }
        func calculateEmojiCounts(for registers: [Register]) {
            for register in filteredRegisters {
                // Populate dictionary
                let emojis: [String] = register.emojis
                for emoji in emojis {
                    emojiCounts[emoji, default: 0] += 1
                }
            }
            print(emojiCounts)
        }
        
        
    }
    
}

struct SummaryView: View {
    
    @StateObject private var homeViewModel = HomeViewModel()
    @State private var summaryViewModel: SummaryViewModel
    
    private var dataManager = DataManager()
    @State private var tips: Dictionary<String, String> = [:]
    
    init(modelContext: ModelContext) {
        let summaryViewModel = SummaryViewModel(modelContext: modelContext)
        _summaryViewModel = State(initialValue: summaryViewModel)
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 25) {
                    Picker("Date Filter", selection: $summaryViewModel.selectedDateFilter) {
                        ForEach(SummaryViewModel.DateFilter.allCases, id: \.self) { filter in
                            Text(filter.filterLabel).tag(filter)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    
                    if summaryViewModel.selectedDateFilter == .customDates {
                        HStack {
                            Text("From")
                                .bold()
                                .font(.body)
                                .foregroundStyle(.accent)
                            DatePicker("Start Date",
                                       selection: $summaryViewModel.customStartDate,
                                       in: ...summaryViewModel.customEndDate,
                                       displayedComponents: [.date]
                            )
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            Spacer()
                            Text("To")
                                .bold()
                                .font(.body)
                                .foregroundStyle(.accent)
                            DatePicker("End Date",
                                       selection: $summaryViewModel.customEndDate,
                                       in: summaryViewModel.customStartDate...Date(),
                                       displayedComponents: .date
                            )
                            .datePickerStyle(.compact)
                            .labelsHidden()
                        }
                    }
                    VStack(spacing: 30) {
                        ForEach(homeViewModel.moods) {
                            mood in
                            let (value, emojiCount) = summaryViewModel.calculateBarValue(mood)
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
                    NavigationLink(destination:
                                    RegistersView(registers: summaryViewModel.filteredRegisters, tips: tips)
                        .environmentObject(homeViewModel)
                    ) {
                        Text("View registers")
                            .buttonStyleModifier(.accentColor)
                    }
                }
                .onAppear {
                    summaryViewModel.filterRegisters()
                    dataManager.fetchData { jsonTips in
                        self.tips = jsonTips
                    }
                }
                .onChange(of: [summaryViewModel.selectedDateFilter]) { oldValue, newValue in
                    withAnimation {
                        summaryViewModel.filterRegisters()
                    }
                }
                .onChange(of: [summaryViewModel.customStartDate, summaryViewModel.customEndDate], {
                    withAnimation {
                        summaryViewModel.filterRegisters()
                    }
                })
            }
            .padding()
            .navigationTitle("Summary")
        }
    }
    
    
    
}

