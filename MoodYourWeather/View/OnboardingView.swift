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
    @State private var isShowingText = false
    
    var body: some View {
        ZStack{
            LinearGradient(colors: [ .blue, .cyan, .teal], startPoint: .top, endPoint: .bottom)
                .ignoresSafeArea()
            
            VStack{
                if isShowingText {
                    Text("Mood \n your \n weather")
                        .font(.system(size: 60))
                        .bold()
                        .foregroundStyle(.white)
                        .padding(.top, 100.0)
                        .multilineTextAlignment(.center)
                        .lineSpacing(15)
                }
                
                Spacer()
                ZStack {
                    Image(.cloud)
                        .resizable()
                        .frame(height: 330)
                        .offset(x:-offset, y: -100)
                        .opacity(opacity)
                        .onAppear() {
                            withAnimation(.easeInOut(duration: 1.0).delay(1.8).repeatForever(autoreverses: true)) {
                                offset = UIScreen.main.bounds.width
                                opacity=0.5
                            }
                        }
                    Image(.cloud)
                        .resizable()
                        .frame(height: 330)
                        .offset(x:offset, y: 0)
                        .opacity(opacity)
                        .onAppear() {
                            withAnimation(.easeInOut(duration: 6.0).delay(0.5).repeatForever(autoreverses: true)) {
                                offset = UIScreen.main.bounds.width
                                opacity=0.5
                            }
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
        .onAppear(){
                Timer.scheduledTimer(withTimeInterval: 5.0, repeats: false) { _ in
                    withAnimation {
                        self.isShowingText = true
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

