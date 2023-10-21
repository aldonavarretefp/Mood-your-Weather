//
//  OnboardingView.swift
//  MoodYourWeather
//
//  Created by Luigi Cirillo on 21/10/23.
//

import SwiftUI

struct OnboardingView: View {
    @State var effect = false
    @Binding var showOnboarding : Bool
    @State var transition = true
    @State private var bounceSize: CGFloat = 1
    @State private var offset: CGFloat = -UIScreen.main.bounds.width
    @State private var opacity: Double = 1
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [ .blue, .cyan, .teal], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack{
                Text("Mood \n your \n weather")
                    .font(.largeTitle)
                    .bold()
                    .foregroundStyle(.white)
                    .padding(.top, 100.0)
                    .multilineTextAlignment(.center)
                    .lineSpacing(25)
                Spacer()
                Image(.cloud)
                    .resizable()
                    .frame(height: 330)
                    .offset(x:offset, y: 0)
                    .opacity(opacity)
                    .onAppear() {
                        withAnimation(.easeInOut(duration: 4.0).delay(1.0)) {
                            offset = UIScreen.main.bounds.width
                            opacity=0
                            }
                        }
                Text("Tap to continue")
                    .padding()
                    .font(.title2)
                    .bold()
                    .foregroundStyle(.white)
                    .opacity(0.6)
                    .scaleEffect(bounceSize)
                    .onAppear(){
                        withAnimation(Animation.easeInOut(duration: 1.4).repeatForever(autoreverses: true)) {
                            bounceSize = 1.15
                        }
                    }
            }
        }
        .onTapGesture(perform: {
            showOnboarding.toggle()
        })
    }
}
       
#Preview {
    OnboardingView(showOnboarding: .constant(true))
}

