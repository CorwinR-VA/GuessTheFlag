//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Corwin Rainier on 6/14/22.
//

import SwiftUI

struct ContentView: View {
    @State private var answer = Int.random(in: 0...2)
    @State private var scoreShow = false
    @State private var scoreType = ""
    @State private var score = 0
    @State private var turn = 1
    @State private var end = false
    
    @State private var flags = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    
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
                        Text(flags[answer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3) { number in
                        Button {
                            button(number)
                        } label: {
                            Image(flags[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
                Spacer()
                Text("Score: \(score)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                Spacer()
            }
            .padding()
        }
        .alert(scoreType, isPresented: $scoreShow) {
            Button("Continue", action: main)
        } message: {
            Text("Your score is \(score)")
        }
        .alert("Game Over", isPresented: $end) {
            Button("Play Again", action: restart)
        } message: {
            Text("Your score is \(score)")
        }
    }
    func button(_ number: Int) {
        if number == answer {
            scoreType = "Correct"
            score += 1
        } else { scoreType = "That is the flag of \(flags[number])"}
        scoreShow = true
    }
    func main() {
        if turn < 8 {
            flags.shuffle()
            answer = Int.random(in: 0...2)
            turn += 1
        } else {
            end = true
        }
    }
    func restart() {
        turn = 0
        score = 0
        main()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
