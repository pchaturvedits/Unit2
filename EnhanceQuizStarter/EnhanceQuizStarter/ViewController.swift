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

class ViewController: UIViewController {
    
    // MARK: - Properties
    
    let questionsPerRound = 4
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion = 0
    
    var gameSound: SystemSoundID = 0
    
    
    // MARK: - Outlets
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var falseButton: UIButton!
    @IBOutlet weak var option3Button: UIButton!
    @IBOutlet weak var option4Button: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var answerStatuslabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadGameStartSound()
        playGameStartSound()
        displayQuestion()
       
    }
    
    // MARK: - Helpers
    
    func loadGameStartSound() {
        let path = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundUrl = URL(fileURLWithPath: path!)
        AudioServicesCreateSystemSoundID(soundUrl as CFURL, &gameSound)
    }
    
    func playGameStartSound() {
        AudioServicesPlaySystemSound(gameSound)
    }
    
   func displayQuestion() {
   
  answerStatuslabel.text = ""
        indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: trivia.count)
        let questionDictionary = trivia[indexOfSelectedQuestion]
     questionField.text = questionDictionary.question
    
    if questionDictionary.ansType == 2 {
    trueButton.setTitle(questionDictionary.option1, for: UIControlState.normal)
    falseButton.setTitle(questionDictionary.option2, for: UIControlState.normal)
    option3Button.isHidden = true
    option4Button.isHidden = true
    playAgainButton.isHidden = true
    } else if questionDictionary.ansType == 4 {
        trueButton.setTitle(questionDictionary.option1, for: UIControlState.normal)
        falseButton.setTitle(questionDictionary.option2, for: UIControlState.normal)
        option3Button.setTitle(questionDictionary.option3, for: UIControlState.normal)
        option4Button.setTitle(questionDictionary.option4, for: UIControlState.normal)
        playAgainButton.isHidden = true
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
        // Display play again button
        playAgainButton.isHidden = false
        
        questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
        
    }
    
    func nextRound() {
       
        if questionsAsked == questionsPerRound {
            // Game is over
            displayScore()
        } else {
            // Continue game
            displayQuestion()
        }
      //  answerStatuslabel.isHidden = false
    }
    
   func loadNextRound(delay seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer

        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
    
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.nextRound()
        }
    }
   
    // MARK: - Actions
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        // Increment the questions asked counter
        questionsAsked += 1
        
        let selectedQuestionDict = trivia[indexOfSelectedQuestion]
        let correctAnswer = selectedQuestionDict.answer
    
        if (sender === trueButton && trueButton.currentTitle == correctAnswer) ||
        (sender === falseButton && falseButton.currentTitle == correctAnswer) ||
        (sender === option3Button && option3Button.currentTitle == correctAnswer) ||
        (sender === option4Button && option4Button.currentTitle == correctAnswer){
        correctQuestions += 1
            answerStatuslabel.textColor = UIColor.green
           answerStatuslabel.text = "Correct!"
            } else {
            answerStatuslabel.textColor = UIColor.orange
            answerStatuslabel.text = "Sorry, wrong answer!"
                }
    
        loadNextRound(delay: 2)
   
    }
    
    @IBAction func playAgain(_ sender: UIButton) {
        // Show the answer buttons
      trueButton.isHidden = false
      falseButton.isHidden = false
        option3Button.isHidden = false
        option4Button.isHidden = false
      // playAgainButton.isHidden = false
        questionsAsked = 0
        correctQuestions = 0
        nextRound()
    }
    
    
}


