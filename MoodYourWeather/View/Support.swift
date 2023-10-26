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
    @Binding var path: [Register]
    @State private var pickerSelection: String = ""
    @Binding private var savedAlert: Bool
    @Environment(\.modelContext) private var context
    
    @State private var tips : Dictionary<String, String> = [:]
    private var dataManager: DataManager = DataManager()
    
    init(path: Binding<[Register]>, register: Register, savedAlert: Binding<Bool>) {
        self._path = path
        self.register = register
        self.pickerSelection = register.emojis.first ?? ""
        self._savedAlert = savedAlert
    }
    
    var body: some View {
        if let register {
            ScrollView {
                VStack(spacing: 25) {
                    RegisterSummaryView(register: register, tips: tips)
                    Spacer()
                    Button {
                        saveRegisterInDB(register)
                    } label: {
                        Text("Save")
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
        // Saving the container (DB in SwiftData)
        context.insert(register)
        // Reseting the emojis displayed in the contentview canvas.
        homeViewModel.emojisInCanvas = []
        homeViewModel.emojisInCanvasSet = Set()
        // Pop to root view
        path = []
        // Asyncronously activating the saved alert because it should appear ~10ms after
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
            savedAlert = true;
        }
    }
}

struct RegisterSummaryView: View {
    
    var register: Register
    @State private var pickerSelection: String = ""
    var tips : Dictionary<String, String> = [:]
    
    var body: some View {

        if let snapshot = register.snapshot, let uiImage = UIImage(data: snapshot)  {
            Image(uiImage: uiImage)
                .resizable()
                .offset(y: -60) // Translating the image upwards
                .scaledToFit()
                .clipped()
                .frame(width: 300)
                .padding(.bottom, -55)
        }
        Picker("", selection: $pickerSelection) {
            ForEach(0..<register.emojis.count, id: \.self) { index in
                let emoji = register.emojis[index]
                Text(emoji).tag(emoji)
            }
        }
        .pickerStyle(.segmented)
        if !(register.emojis.count == 1) {
            Text(Constants.emojisDescription[pickerSelection] ?? "")
        }
        Tip(register: register, tips: self.tips)
    }
}

#Preview {
    Group {
        SupportAlternative(path: .constant([
            .init(emojis: ["🍎"], snapshot: UIImage(), date: Date())
        ]), register: .init(emojis: ["🌧️","☀️"], snapshot: UIImage(systemName: "circle.fill")!, date: .now), savedAlert: .constant(false))
    }
    
}
