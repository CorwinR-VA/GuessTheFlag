//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Corwin Rainier on 6/14/22.
//

import SwiftUI

struct ContentView: View {
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var tappedButton = 0
    @State private var scoreShow = false
    @State private var scoreType = ""
    @State private var scoreTotal = 0
    @State private var turnTotal = 1
    @State private var gameOver = false
    
    @State private var flagNations = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var animationAmount = [0.0, 0.0, 0.0]
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)], center: .top, startRadius: 200, endRadius: 400)
                .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the Flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)
                            .font(.subheadline.weight(.heavy))
                        Text(flagNations[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3) { number in
                        Button {
                            performButtonAction(number)
                        } label: {
                            Image(flagNations[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                                .rotation3DEffect(.degrees(animationAmount[number]), axis: (x: 0, y: 1, z: 0))
                                .opacity(scoreShow && number != tappedButton ? 0.25 : 1)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("Score: \(scoreTotal)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }
        .alert(scoreType, isPresented: $scoreShow) {
            Button("Continue", action: mainGameLoop)
        } message: {
            Text("Your score is \(scoreTotal)")
        }
        .alert("Game Over", isPresented: $gameOver) {
            Button("Play Again", action: restartFromZero)
        } message: {
            Text("Your score is \(scoreTotal)")
        }
    }
    func performButtonAction(_ number: Int) {
        withAnimation {
            tappedButton = number
            animationAmount[number] += 360.0
        }
        if number == correctAnswer {
            scoreType = "Correct"
            scoreTotal += 1
        } else { scoreType = "That is the flag of \(flagNations[number])"}
        scoreShow = true
    }
    func mainGameLoop() {
        animationAmount = [0.0, 0.0, 0.0]
        if turnTotal < 8 {
            flagNations.shuffle()
            correctAnswer = Int.random(in: 0...2)
            turnTotal += 1
        } else {
            gameOver = true
        }
    }
    func restartFromZero() {
        turnTotal = 0
        scoreTotal = 0
        mainGameLoop()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
