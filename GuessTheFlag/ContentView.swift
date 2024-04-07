//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Johnny Leung on 2024-03-26.
//

import SwiftUI

struct FlagImage: ViewModifier {
    func body(content: Content) -> some View {
        content
            .clipShape(.capsule)
            .shadow(radius: 5)
    }
}

extension View {
    func flagImage() -> some View {
        modifier(FlagImage())
    }
}


struct ContentView: View {
    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    @State var correctAnswer = Int.random(in: 0...2)
    
    @State private var showingScore = false
    @State private var scoreTitle = ""
    @State private var scoreMessage = ""
    @State private var playerScore = 0
    
    @State private var gameOver = false
    @State private var round = 1
    let totalRounds = 8
    
    @State private var animationAmount = [0.0, 0.0, 0.0]
    @State private var opacityAmount = [1.0, 1.0, 1.0]
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(countries[correctAnswer])
                            .foregroundStyle(.primary)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
//                            animationAmount[number] += 360
                            withAnimation {
                                animationAmount[number] += 360
                                for i in 0..<opacityAmount.count {
                                    if i != number {
                                        opacityAmount[i] = 0.25
                                    }
                                }
                            }
                        } label: {
                            Image(countries[number])
                                .background(.red)
                                .flagImage()
                                .opacity(opacityAmount[number])
                                .scaleEffect(/*@START_MENU_TOKEN@*/CGSize(width: 1.0, height: 1.0)/*@END_MENU_TOKEN@*/)
                                .rotation3DEffect(.degrees(animationAmount[number]), axis: /*@START_MENU_TOKEN@*/(x: 0.0, y: 1.0, z: 0.0)/*@END_MENU_TOKEN@*/)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(playerScore)")
                    .foregroundStyle(.white)
                    .font(.title.bold())
                Text("Round: \(round)/\(totalRounds)")
                    .foregroundStyle(.secondary)
                    .font(.subheadline.weight(.heavy))
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text(scoreMessage)
        }
        .alert("Game Complete", isPresented: $gameOver) {
            Button("Restart", action: resetGame)
        } message: {
            Text("Your final score was \(playerScore)/\(totalRounds)")
        }
    }
    
    func flagTapped(_ number: Int) {
        round += 1
        if number == correctAnswer {
            playerScore += 1
            scoreTitle = "Correct"
            scoreMessage = "Your score is \(playerScore)"

        } else {
            scoreTitle = "Incorrect"
            scoreMessage = "Wrong! Thats the flag of \(countries[number])"
        }
        
        if round < totalRounds {
            showingScore = true
        } else {
            gameOver = true
        }
    }
    
    func resetAnimations() {
        animationAmount = [0.0, 0.0, 0.0]
        opacityAmount = [1.0, 1.0, 1.0]
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        resetAnimations()
    }
    
    func resetGame() {
        round = 1
        playerScore = 0
        askQuestion()
    }
}

#Preview {
    ContentView()
}
