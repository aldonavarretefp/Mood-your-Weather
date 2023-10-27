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
        self.registers = registers
        self.tips = tips
    }
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(groupedRegisters, id: \.self) { groupedRegister in
                    Text(groupedRegister.month)
                        .font(.largeTitle)
                        .bold()
                        .foregroundStyle(.accent)
                    ScrollView(.horizontal) {
                        LazyHStack(spacing: 12,content: {
                            ForEach(groupedRegister.registers) {
                                RegisterCard(register: $0, tips: tips)
                                    .frame(width: 110)
                            }
                        })
                    }
                    .scrollIndicators(.hidden)
                }
            }
            .padding()
        }
    }
}

#Preview {
    RegistersView(registers: [
        .init(emojis: [], snapshot: UIImage(named: "background")!, date: .now),
        .init(emojis: [], snapshot: UIImage(named: "background")!, date: .now),
        .init(emojis: [], snapshot: UIImage(named: "background")!, date: .now),
        .init(emojis: [], snapshot: UIImage(named: "background")!, date: .now),
        .init(emojis: [], snapshot: UIImage(named: "background")!, date: .now),
        .init(emojis: [], snapshot: UIImage(named: "background")!, date: .now),
        .init(emojis: [], snapshot: UIImage(named: "background")!, date: .now),
        .init(emojis: [], snapshot: UIImage(named: "background")!, date: .now),
    ], tips: [:])
}
