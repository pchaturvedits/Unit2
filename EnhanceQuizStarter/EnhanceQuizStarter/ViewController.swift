//
//  ViewController.swift
//  EnhanceQuizStarter
//
//  Created by Pasan Premaratne on 3/12/18.
//  Copyright © 2018 Treehouse. All rights reserved.
//

import UIKit

import AudioToolbox
import AVFoundation

class ViewController: UIViewController {
    
    // MARK: - Properties
    var gameManager = GameManager()
    var soundManager = SoundManager()
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion = 0
    
    var playTime = 15
    let staticPlayTime = 15
    
   
    var timer = Timer()
    
  
   
    
    // MARK: - Outlets
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var trueButton: UIButton!
    @IBOutlet weak var falseButton: UIButton!
    @IBOutlet weak var option3Button: UIButton!
    @IBOutlet weak var option4Button: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var answerStatuslabel: UILabel!
    @IBOutlet weak var timerlabel: UILabel!
    

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
      soundManager.loadGameStartSound()
      soundManager.loadAnswerSound()
    soundManager.playGameStartSound()
        displayQuestion()
        runTimer()
        updateTimer()
       
    }
    
   
    // MARK: - Helpers
    
    func displayQuestion() {
        questionsAsked += 1
        resetTimer()
       
        answerStatuslabel.text = ""
       
        
        playAgainButton.setTitle("Next Question", for: UIControlState.normal)
        trueButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        falseButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        option3Button.setTitleColor(UIColor.white, for: UIControlState.normal)
        option4Button.setTitleColor(UIColor.white, for: UIControlState.normal)
        
        
        indexOfSelectedQuestion = gameManager.generateRandomNumber()
        let questionDictionary = gameManager.trivia[indexOfSelectedQuestion]
        questionField.text = questionDictionary.question
       
        trueButton.layer.cornerRadius = 5
        falseButton.layer.cornerRadius = 5
        option3Button.layer.cornerRadius = 5
      option4Button.layer.cornerRadius = 5
        
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
        gameManager.indexDict = []
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
        
        if questionsAsked == gameManager.trivia.count {
            // Game is over
            displayScore()
        } else {
            // Continue game
            displayQuestion()
            answerStatuslabel.isHidden = false
        }
        
    }
    
    
    // MARK: - Actions
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        // Increment the questions asked counter
        let selectedQuestionDict = gameManager.trivia[indexOfSelectedQuestion]
        let correctAnswer = selectedQuestionDict.answer
       
        highlightAnswer(sender)
        
        let isCorrectAnswer = gameManager.checkAnswerForQuestion(selectedQuestionDict: selectedQuestionDict, btnTitle: sender.currentTitle ?? "")
        if isCorrectAnswer {
            correctQuestions+=1
            soundManager.correctAnswerSound()
            highlightAnswer(sender)
            answerStatuslabel.textColor = UIColor.green
            answerStatuslabel.text = "Correct!"

        }else {
            let attrs1 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15), NSAttributedStringKey.foregroundColor : UIColor.orange]
            
            let attrs2 = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 15), NSAttributedStringKey.foregroundColor : UIColor.green]
            
            let attributedString1 = NSMutableAttributedString(string:"Wrong answer!", attributes:attrs1)
            
            let attributedString2 = NSMutableAttributedString(string:"\nCorrect answer is \(correctAnswer)", attributes:attrs2)
            
            
            attributedString1.append(attributedString2)
            self.answerStatuslabel.attributedText = attributedString1
            
            soundManager.incorrectAnswerSound()
            highlightAnswer(sender)
        }
        
    }
    
    func highlightAnswer(_ sender: UIButton) {
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
            // if countdown is 0 time to display next question
            displayQuestion()
        }
        
    }
    
    
    func resetTimer() {
        playTime = staticPlayTime
    }
    
    
    
    
    @IBAction func playAgain(_ sender: Any) {
        
        if playAgainButton.currentTitle == "Next Question"{
          
            nextRound()
            
            
        }else if playAgainButton.currentTitle == "Play Again" {
            gameManager.indexDict = []
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
            
            nextRound()
        }
        
    }
}



