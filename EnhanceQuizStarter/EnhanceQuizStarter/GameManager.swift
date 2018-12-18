import GameKit
import AudioToolbox
import AVFoundation

struct ObjectiveType {
    var question: String
    var option1:String
    var option2:String
    var option3:String
    var option4:String
    var answer: String
    var ansType: Int
}

struct GameManager{
    var indexDict = [Int]()
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion = 0
    
    var gameRunTime = 15
    let staticPlayTime = 15
    
    let trivia :[ObjectiveType] =
    [ObjectiveType(question: "Only female koalas can whistle", option1: "True", option2: "False", option3: "None", option4: "None", answer: "False", ansType: 2),
    ObjectiveType(question: "Blue whales are technically whales", option1: "True", option2: "False", option3: "None", option4: "None", answer: "True", ansType: 2),
    ObjectiveType(question: "Camels are cannibalistic",option1: "True", option2: "False", option3: "None", option4: "None", answer: "False", ansType: 2),
    ObjectiveType(question: "All ducks are birds", option1: "True", option2: "False", option3: "None", option4: "None", answer: "True", ansType: 2),
    ObjectiveType(question: "This was the only US President to serve more than two consecutive terms.", option1: "George Washington", option2: "Franklin D. Roosevelt", option3: "Woodrow Wilson", option4: "Andrew Jackson", answer: "Franklin D. Roosevelt", ansType: 4),
    ObjectiveType (question: "Which of the following countries has the most residents?", option1: "Nigeria", option2: "Russia", option3: "Iran", option4: "Vietnam", answer: "Nigeria", ansType: 4),
    ObjectiveType(question: "In what year was the United Nations founded?", option1: "1918", option2: "1919", option3: "1945", option4: "1954", answer: "1945", ansType: 4),
    ObjectiveType(question: "The Titanic departed from the United Kingdom, where was it supposed to arrive?", option1: "Paris", option2: "Washington D.C.", option3: "New York City", option4: "Boston", answer: "New York City", ansType: 4),
    ObjectiveType(question: "Which nation produces the most oil?", option1: "Iran", option2: "Iraq", option3: "Brazil", option4: "Canada", answer: "Canada", ansType: 4),
    ObjectiveType(question: "Which country has most recently won consecutive World Cups in Soccer?", option1: "Italy", option2: "Brazil", option3: "Argetina", option4: "Spain", answer: "Brazil", ansType: 4),
    ObjectiveType(question: "Which of the following rivers is longest?", option1: "Yangtze", option2: "Mississippi", option3: "Congo", option4: "Mekong", answer: "Mississippi", ansType: 4),
    ObjectiveType(question: "Which city is the oldest?", option1: "Mexico City", option2: "Cape Town", option3: "San Juan", option4: "Sydney", answer: "Mexico City", ansType: 4),
    ObjectiveType(question: "Which country was the first to allow women to vote in national elections?", option1: "Poland", option2: "United States", option3: "Sweden", option4: "Senegal", answer: "Poland", ansType: 4),
    ObjectiveType(question: "Which of these countries won the most medals in the 2012 Summer Games?", option1: "France", option2: "Germany", option3: "Japan", option4: "Great Britian", answer: "Great Britian", ansType: 4)]
    

 //   var shouldGenerateRandomNumber: Bool
    
    
    mutating func generateRandomNumber()-> Int{
        var randomNumber:Int = 0
        var shouldGenerateRandomNumber = true
        while shouldGenerateRandomNumber {
            randomNumber = GKRandomSource.sharedRandom().nextInt(upperBound: self.trivia.count)
            
            if indexDict.contains(randomNumber) {
                shouldGenerateRandomNumber = true
            }else {
                indexDict.append(randomNumber)
                shouldGenerateRandomNumber = false
            }
            
        }
        return randomNumber
    }
    
    func checkAnswerForQuestion(selectedQuestionDict:ObjectiveType,  btnTitle: String )-> Bool{
        if selectedQuestionDict.answer == btnTitle {
            return true
        }else {
            return false
        }
        
}
}












































