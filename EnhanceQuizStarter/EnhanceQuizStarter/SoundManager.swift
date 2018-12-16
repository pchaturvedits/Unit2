
import AudioToolbox
import AVFoundation

struct SoundManager{
var gameSound: SystemSoundID = 0
var gameCorrect: SystemSoundID = 0
var gameIncorrect: SystemSoundID = 0
    
    mutating func loadGameStartSound() {
        let path = Bundle.main.path(forResource: "GameSound", ofType: "wav")
        let soundUrl = URL(fileURLWithPath: path!)
        AudioServicesCreateSystemSoundID(soundUrl as CFURL, &gameSound)
        
    }
    mutating func loadAnswerSound() {
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

}
