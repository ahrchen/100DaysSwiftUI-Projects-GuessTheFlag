//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Raymond Chen on 2/4/22.
//

import SwiftUI


struct FlagImage: View {
    var imageName: String
    
    var body: some View {
        Image(imageName)
            .renderingMode(.original)
            .clipShape(Capsule())
            .shadow(radius: 5)
    }
    
    init(_ imageName: String) {
        self.imageName = imageName
    }
}

struct ContentView: View {
    @State private var userScore = 0
    @State private var userGuesses = 0
    @State private var showingScore = false
    @State private var gameOver = false
    
    @State private var scoreTitle = ""
    @State private var alertMessage = ""
    @State private var gameOverMessage = ""
    
    @State var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State var correctAnswer = Int.random(in: 0...2)
    
    let numberOfGames = 8
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [.init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3), .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3),], center: .top, startRadius: 200, endRadius:  700)
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
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)
                        } label: {
                            FlagImage(countries[number])
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.thinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(userScore)")
                    .foregroundColor(.white)
                    .font(.title.bold())
                
                Spacer()
            }
            .padding()
        }
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text(alertMessage)
        }
        .alert("Game Over", isPresented: $gameOver) {
            Button("Reset", action: reset)
        } message: {
            Text(gameOverMessage)
        }
    }
    
    func flagTapped(_ number: Int) {
        userGuesses += 1
        
        if number == correctAnswer {
            userScore += 1
            scoreTitle = "Correct"
            alertMessage = "Your score is \(userScore)"
        } else {
            scoreTitle = "Wrong"
            alertMessage = "Wrong! That's the flag for \(countries[number])"
        }
        
        
        
        if userGuesses == numberOfGames {
            if  Double(userScore) / Double(userGuesses) == 1.0 {
                gameOverMessage = "You got \(userScore) / \(numberOfGames). That is 100%. Great Job!"
            } else if Double(userScore) / Double(userGuesses) > 0.8 {
                gameOverMessage = "You got \(userScore) / \(numberOfGames). That is more than 80%. Good Job!"
            } else if Double(userScore) / Double(userGuesses) > 0.6 {
                gameOverMessage = "You got \(userScore) / \(numberOfGames). That is more than 60%. You are getting better!"
            } else {
                gameOverMessage = "You got \(userScore) / \(numberOfGames). That is less than 60%. Keep it up!"
            }
            
            gameOver = true
        } else {
            showingScore = true
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
    
    func reset() {
        userScore = 0
        userGuesses = 0
        askQuestion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
