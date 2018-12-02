//
//  ViewController.swift
//  EnhanceQuizStarter
//
//  Created by Pasan Premaratne on 3/12/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import UIKit
import GameKit
import AudioToolbox
import AVFoundation

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    let questionsPerRound = trivia.count
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion = 0
    var indexDict = [Int]()
    var playTime = 40
    let staticPlayTime = 40
    
    var gameSound: SystemSoundID = 0
    var gameCorrect: SystemSoundID = 1
    var gameIncorrect: SystemSoundID = 2
    
    
    //  var playTime = 40  // Seconds
    //let staticPlayTime = 40 // Seconds
    //var timer = Timer()
    
    // MARK: - Outlets
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var falseButton: UIButton!
    @IBOutlet weak var option3Button: UIButton!
    @IBOutlet weak var option4Button: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var answerStatuslabel: UILabel!
    @IBOutlet weak var timerlabel: UILabel!
    
    var timer = Timer()//Timer(fire: Date(), interval: 0, repeats: true, block: {_ in })
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadGameStartSound()
        loadAnswerSound()
        playGameStartSound()
        displayQuestion()
        runTimer()
        updateTimer()
        //runTimer()
    }
    
    // MARK: - Helpers
    
    func loadGameStartSound() {
        let path = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundUrl = URL(fileURLWithPath: path!)
        AudioServicesCreateSystemSoundID(soundUrl as CFURL, &gameSound)
        
    }
    func loadAnswerSound() {
        let path2 = Bundle.main.path(forResource: "GameCorrect" , ofType: "wav")
        let soundUrl1 = URL(fileURLWithPath: path2!)
        AudioServicesCreateSystemSoundID(soundUrl1 as CFURL, &gameCorrect)
        let path3 = Bundle.main.path(forResource: "GameIncorrect", ofType: "wav")
        let soundUrl2 = URL(fileURLWithPath: path3!)
        AudioServicesCreateSystemSoundID(soundUrl2 as CFURL, &gameIncorrect)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
    
    func correctAnswerSound() {
        AudioServicesPlaySystemSound(gameCorrect)
    }
    func incorrectAnswerSound(){
        AudioServicesPlaySystemSound(gameIncorrect)
    }
    
    func displayQuestion() {
        
        answerStatuslabel.text = ""
        playAgainButton.isHidden = false
        
        playAgainButton.setTitle("Next Question", for: UIControlState.normal)
        trueButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        falseButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        option3Button.setTitleColor(UIColor.white, for: UIControlState.normal)
        option4Button.setTitleColor(UIColor.white, for: UIControlState.normal)
        
  //  if indexDict.count <= trivia.count {
            var isduplicateFound = true
            while isduplicateFound {
                indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: trivia.count)

                if indexDict.contains(indexOfSelectedQuestion) {
                    
                    isduplicateFound = true
                }else {
                    indexDict.append(indexOfSelectedQuestion)
                    isduplicateFound = false
                }

            }
//       }
       
    //  indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: trivia.count)
//
//        var duplicateFound = false
//        if indexDict.count > 0 {
//            for value in indexDict {
//                if value == indexOfSelectedQuestion {
//                    indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: trivia.count)
//                    duplicateFound = true
//                }
//
//            }
//            if !duplicateFound {
//                indexDict.append(indexOfSelectedQuestion)
//            }
//        }else {
//            indexDict.append(indexOfSelectedQuestion)
//
//        }
        
              let questionDictionary = trivia[indexOfSelectedQuestion]
                questionField.text = questionDictionary.question
                
         
        
        if questionDictionary.ansType == 2 {
            trueButton.setTitle(questionDictionary.option1, for: UIControlState.normal)
            falseButton.setTitle(questionDictionary.option2, for: UIControlState.normal)
            option3Button.isHidden = true
            option4Button.isHidden = true
            
        } else if questionDictionary.ansType == 4 {
            trueButton.setTitle(questionDictionary.option1, for: UIControlState.normal)
            falseButton.setTitle(questionDictionary.option2, for: UIControlState.normal)
            option3Button.setTitle(questionDictionary.option3, for: UIControlState.normal)
            option4Button.setTitle(questionDictionary.option4, for: UIControlState.normal)
            
            trueButton.isHidden = false
            falseButton.isHidden = false
            option3Button.isHidden = false
            option4Button.isHidden = false
        }
        
        
    }
    func displayScore() {
        // Hide the answer uttons
        trueButton.isHidden = true
        falseButton.isHidden = true
        option3Button.isHidden = true
        option4Button.isHidden = true
        answerStatuslabel.text = ""
        playAgainButton.setTitle("Play Again", for: UIControlState.normal)
        timerlabel.isHidden = true
        questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsAsked) correct!"
    }
    
    func nextRound() {
        
        if questionsAsked == questionsPerRound {
            // Game is over
            displayScore()
        } else {
            // Continue game
            displayQuestion()
            answerStatuslabel.isHidden = false
        }
        
    }
    
    func loadNextRound(delay seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
        }
    }
    
    // MARK: - Actions
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        // Increment the questions asked counter
        let selectedQuestionDict = trivia[indexOfSelectedQuestion]
        let correctAnswer = selectedQuestionDict.answer
       //  answerStatuslabel.text =
        
        answerStatuslabel.font =  UIFont.boldSystemFont(ofSize: 20)
        
        func highlightAnswer() {
            if (sender === trueButton){
                falseButton.setTitleColor(UIColor.lightText, for: UIControlState.normal)
                option3Button.setTitleColor(UIColor.lightText, for: UIControlState.normal)
                option4Button.setTitleColor(UIColor.lightText, for: UIControlState.normal)
                
                
            }else if (sender === falseButton){
                trueButton.setTitleColor(UIColor.lightText, for: UIControlState.normal)
                option3Button.setTitleColor(UIColor.lightText, for: UIControlState.normal)
                option4Button.setTitleColor(UIColor.lightText, for: UIControlState.normal)
            }else if(sender === option3Button){
                falseButton.setTitleColor(UIColor.lightText, for: UIControlState.normal)
                trueButton.setTitleColor(UIColor.lightText, for: UIControlState.normal)
                option4Button.setTitleColor(UIColor.lightText, for: UIControlState.normal)
            }else if (sender === option4Button){
                falseButton.setTitleColor(UIColor.lightText, for: UIControlState.normal)
                option3Button.setTitleColor(UIColor.lightText, for: UIControlState.normal)
                trueButton.setTitleColor(UIColor.lightText, for: UIControlState.normal)
            }
        }
        
        if (sender === trueButton && trueButton.currentTitle == correctAnswer) ||
            (sender === falseButton && falseButton.currentTitle == correctAnswer) ||
            (sender === option3Button && option3Button.currentTitle == correctAnswer) ||
            (sender === option4Button && option4Button.currentTitle == correctAnswer){
            correctQuestions += 1
            correctAnswerSound()
            highlightAnswer()
            answerStatuslabel.textColor = UIColor.green
            answerStatuslabel.text = "Correct!"
        } else {
            answerStatuslabel.textColor = UIColor.orange
            answerStatuslabel.text = "Sorry, wrong answer!"
            incorrectAnswerSound()
            highlightAnswer()
        }
        loadNextRound(delay: 2)
        
        
    }
    
    
    // Helper functions for lighting round
    // The main countdown timer for the game
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(ViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    // Showing the countdown on screen
    @objc func updateTimer(){
        
        if playTime > 0 {
            playTime -= 1
            timerlabel.text = "\(playTime)"
        } else if playTime == 0 {
            // if countdown is 0 game is over and display score
            displayScore()
        }
        
    }
    
    
    func resetTimer() {
        playTime = staticPlayTime
    }
    
    
    
    
    @IBAction func playAgain(_ sender: Any) {
        if playAgainButton.currentTitle == "Next Question"{
            questionsAsked += 1
          //  displayQuestion()
            nextRound()
            
            
        }else if playAgainButton.currentTitle == "Play Again" {
            
            indexDict = []
            trueButton.isHidden = false
            falseButton.isHidden = false
            option3Button.isHidden = false
            option4Button.isHidden = false
            
            playAgainButton.isHidden = false
            timerlabel.isHidden = false
            questionsAsked = 0
            correctQuestions = 0
            resetTimer()
            updateTimer()
            
            displayQuestion()
            nextRound()
        }
        
    }
    
    
    
    
}
