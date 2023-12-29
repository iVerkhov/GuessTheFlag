//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Игорь Верхов on 29.07.2023.
// 

import SwiftUI

struct ContentView: View {
    
    @State private var showingScore = false
    @State private var showingTip = false
    @State private var showingEndGame = false
    @State private var scoreTitle = ""
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var totalScore = 0
    @State private var rounds = 0
    var totalRounds = 8
    @State private var isRoundEnded = false
    
    @State private var selectedFlag = -1
    @State private var animationAmount = 0.0
    
    let labels = [
        "Estonia": "Flag with three horizontal stripes of equal size. Top stripe blue, middle stripe black, bottom stripe white",
        "France": "Flag with three vertical stripes of equal size. Left stripe blue, middle stripe white, right stripe red",
        "Germany": "Flag with three horizontal stripes of equal size. Top stripe black, middle stripe red, bottom stripe gold",
        "Ireland": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe orange",
        "Italy": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe red",
        "Nigeria": "Flag with three vertical stripes of equal size. Left stripe green, middle stripe white, right stripe green",
        "Poland": "Flag with two horizontal stripes of equal size. Top stripe white, bottom stripe red",
        "Russia": "Flag with three horizontal stripes of equal size. Top stripe white, middle stripe blue, bottom stripe red",
        "Spain": "Flag with three horizontal stripes. Top thin stripe red, middle thick stripe gold with a crest on the left, bottom thin stripe red",
        "UK": "Flag with overlapping red and white crosses, both straight and diagonally, on a blue background",
        "US": "Flag with red and white stripes of equal size, with white stars on a blue background in the top-left corner"
    ]
    
    struct FlagImage: View {
        var source: String
        
        var body:some View {
            Image(source)
                .renderingMode(.original)
                .clipShape(Capsule())
                .shadow(radius: 5)
        }
    }
    
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 400)
            .ignoresSafeArea()
            VStack {
                Spacer()
                Text("Guess the flag")
                    .font(.largeTitle.bold())
                    .foregroundColor(.white)
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of:")
                            .font(.subheadline.weight(.heavy))
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) {number in
                        Button {
                                flagTapped(number)
                        } label: {
                            FlagImage(source: countries[number])
                                .rotation3DEffect(.degrees(selectedFlag == number ? 360 : 0), axis: (x: 0, y:1, z: 0))
                                .opacity(selectedFlag == -1 || selectedFlag == number ? 1 : 0.25)
                                .scaleEffect(selectedFlag == -1 || selectedFlag == number ? 1 : 0.75)
                                .saturation(selectedFlag == -1 || selectedFlag == number ? 1 : 0)
                                .blur(radius: selectedFlag == -1 || selectedFlag == number ? 0 : 3)
                                .animation(.default, value: selectedFlag)
                                .accessibilityLabel(labels[countries[number], default: "Unknown flag"])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding()
                
                Spacer()
                Spacer()
                
                Text("Score: \(totalScore)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
        } .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: checkRound)
        } message: {
            Text("Your score: \(totalScore)")
        } .alert("Hint", isPresented: $showingTip) {
            Button("OK, thanks", action: checkRound)
        } message: {
            Text("Wrong! That’s the flag of \(countries[correctAnswer])")
        } .alert("Game ended", isPresented: $showingEndGame) {
            Button("New game", action: reset)
            Button("OK") { }
        } message: {
            Text("Your score: \(totalScore)")
        }
    }
    func flagTapped(_ number: Int) {
        selectedFlag = number
        guard !isRoundEnded else {
            showingEndGame = true
            return
        }
        if number == correctAnswer {
            scoreTitle = "Right"
            totalScore += 1
            rounds += 1
            showingScore = true
        } else {
            scoreTitle = "Wrong"
            showingTip = true
        }
        
    }
    
    func checkRound() {
        if rounds < totalRounds {
            askQuestion()
        } else {
            showingEndGame = true
            isRoundEnded = true
        }
    }
    
    func askQuestion() {
            countries.shuffle()
            correctAnswer = Int.random(in: 0...2)
        selectedFlag = -1
    }
    
    func reset() {
        rounds = 0
        totalScore = 0
        isRoundEnded = false
        askQuestion()
    }
}

#Preview {
    ContentView()
}
