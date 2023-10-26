//
//  RegistersView.swift
//  MoodYourWeather
//
//  Created by Aldo Yael Navarrete Zamora on 25/10/23.
//
import SwiftUI

struct RegistersView: View {
    // MARK: Public vars
    let registers: [Register]
    let tips : Dictionary<String, String>
    
    // MARK: Private vars
    @Environment(\.modelContext) private var context
    @EnvironmentObject private var homeViewModel: HomeViewModel
    private var dataManager: DataManager = DataManager()
    
    struct GroupedRegisters: Hashable {
        var month: String
        var registers: [Register]
    }
    
    private var groupedRegisters: [GroupedRegisters] {
        let grouped = Dictionary(grouping: registers) { register in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MMM yyyy"
            return dateFormatter.string(from: register.date)
        }
        return grouped.sorted { $0.key > $1.key }.map { GroupedRegisters(month: $0.key, registers: $0.value) }
    }
    
    init(registers: [Register], tips: Dictionary<String, String>) {
        print(tips)
        print("=========")
        self.registers = registers
        self.tips = tips
    }
    
    var body: some View {
        List {
            ForEach(groupedRegisters, id: \.self) { groupedRegister in
                Section(header:
                            Text(groupedRegister.month)
                    .font(.largeTitle)
                ) {
                    ForEach(groupedRegister.registers) { register in
                        NavigationLink(register.emojis.joined(separator: ""), destination:
                                        RegisterDetailView(register: register, tips: tips)
                            .environmentObject(homeViewModel)
                        )
                    }
                    .onDelete(perform: { indexSet in
                        for index in indexSet {
                            context.delete(registers[index])
                        }
                    })
                }
            }
        }
    }
    
    
}

