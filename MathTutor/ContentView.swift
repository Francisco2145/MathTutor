//
//  ContentView.swift
//  MathTutor
//
//  Created by Student2 on 5/5/25.
//

import SwiftUI
import AVFAudio

struct ContentView: View {
    @State private var firstNumber = 0
    @State private var secondNumber = 0
    @State private var firstNumberEmojis = ""
    @State private var secondNumberEmojis = ""
    @State private var answer = ""
    @State private var audioPlayer : AVAudioPlayer!
    @State private var textFieldIsDisabled = false
    @State private var buttonIsDisabled = false
    @State private var message = ""
    @FocusState private var isFocused: Bool
    
    private let emojis = ["🍕", "🍎", "🍏", "🐵", "👽", "🧠", "🧜🏽‍♀️", "🧙🏿‍♂️", "🥷", "🐶", "🐹", "🐣", "🦄", "🐝", "🦉", "🦋", "🦖", "🐙", "🦞", "🐟", "🦔", "🐲", "🌻", "🌍", "🌈", "🍔", "🌮", "🍦", "🍩", "🍪"]
    
    var body: some View {
        VStack {
            Group{
                Text(firstNumberEmojis)
                Text("+")
                Text(secondNumberEmojis)
            }
            .font(Font.system(size: 80))
            .multilineTextAlignment(.center)
            .minimumScaleFactor(0.5)
            .animation(.default, value: message)
            
            Spacer()
            
            Text("\(firstNumber)+ \(secondNumber) =")
                .font(.largeTitle)
                .animation(.default, value: message)
            
            TextField("", text: $answer)
                .font(.largeTitle)
                .frame(width: 60)
                .textFieldStyle(.roundedBorder)
                .overlay{
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.gray, lineWidth: 2)
                }
                .multilineTextAlignment(.center)
                .keyboardType(.numberPad)
                .focused($isFocused)
                .disabled(textFieldIsDisabled)
            
            Button("Guess"){
                isFocused = false
                guard let answerValue = Int(answer) else{ //invalid answer entered
                    return
                }
                if answerValue == firstNumber + secondNumber {
                    playSound(SoundName: "correct")
                    message = "Correct!"
                } else{
                    playSound(SoundName: "wrong")
                    message = "Sorry, the correct answer is \(firstNumber+secondNumber)"
                }
                textFieldIsDisabled = true
                buttonIsDisabled = true
            }
            .buttonStyle(.borderedProminent)
            .disabled(answer.isEmpty || buttonIsDisabled)
            
            Spacer()
            
            Text(message)
                .font(.largeTitle)
                .fontWeight(.black)
                .multilineTextAlignment(.center)
                .foregroundStyle(message == "Correct!" ? .green :.red)
                .animation(.default, value: message)
            
            if message != ""{
                Button("Play Again?"){
                    message = ""
                    answer = ""
                    textFieldIsDisabled = false
                    buttonIsDisabled = false
                    generateEquation()
                }
            }
        }
        .padding()
        .onAppear(){
            generateEquation()
        }
    }
    
    func playSound(SoundName: String){
        guard let soundFile = NSDataAsset(name: SoundName) else{
            print ("😡 ERROR: Could not read file named \(SoundName)")
            return
        }
        do{
            audioPlayer = try AVAudioPlayer(data: soundFile.data)
            audioPlayer.play()
        } catch{
            print("😡 ERROR: \(error.localizedDescription) creating audio player")
        }
    }
    func generateEquation(){
        firstNumber = Int.random(in: 1...10)
        secondNumber = Int.random(in: 1...10)
        firstNumberEmojis = String(repeating: emojis.randomElement()!, count: firstNumber)
        secondNumberEmojis = String(repeating: emojis.randomElement()!, count: secondNumber)
    }
}

    #Preview {
        ContentView()
    }
