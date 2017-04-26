//
//  ViewController.swift
//  MMA Trivia
//
//  Created by William Mahoney on 9/21/16.
//

import UIKit
import GameKit
import AudioToolbox

class ViewController: UIViewController {
    
    var trivia = [QuestionDetail]()
    
    let questionsPerRound = 4
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion: Int = 0
    
    //Sound Clip File Variables//
    let soundType = "wav"
    let startSoundFile = "Boxing Bell Start Round"
    let endSoundFile = "Boxing Bell End Round"
    let correctSoundFile = "CorrectSound"
    let incorrectSoundFile = "IncorrectSound"
    
    //System Sound ID's//
    var startSound: SystemSoundID = 0
    var endSound: SystemSoundID = 1
    var correctSound: SystemSoundID = 2
    var incorrectSound: SystemSoundID = 3
    
    
    var countdown = Timer()
    var count = 15
    
    
    @IBOutlet weak var questionField: UILabel!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var buttonTimeOut: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var countdownLabel: UILabel!
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        assignQuestions()
        // Start game
//        loadGameSound(resource: startSoundFile, type: soundType, sound: &startSound)
//        playSound(sound: startSound)
        playSound(resource: startSoundFile, type: soundType, sound: &startSound)
        displayQuestion()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func assignQuestions() {
        for questionData in Questions().library {
            let question = QuestionDetail(dictionary: questionData)
            trivia.append(question)
        }
    }
    
    func displayQuestion() {
        indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: trivia.count)
        let questionDictionary = trivia[indexOfSelectedQuestion]
        questionField.text = questionDictionary.question
        button1.setTitle(questionDictionary.option1, for: .normal)
        button2.setTitle(questionDictionary.option2, for: .normal)
        button3.setTitle(questionDictionary.option3, for: .normal)
        button4.setTitle(questionDictionary.option4, for: .normal)
        playAgainButton.isHidden = true
        startCountdown()
    }
    
    func displayScore() {
        // Hide the answer buttons
        button1.isHidden = true
        button2.isHidden = true
        button3.isHidden = true
        button4.isHidden = true
        // Display play again button
        playAgainButton.isHidden = false
        
        questionField.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
    }
    
    @IBAction func checkAnswer(_ sender: UIButton) {
        // Increment the questions asked counter
        questionsAsked += 1
        
        let selectedQuestionDict = trivia[indexOfSelectedQuestion]
        let correctAnswer = selectedQuestionDict.answer

        if (sender === button1 &&  correctAnswer == "1") || (sender === button2 && correctAnswer == "2") || (sender === button3 && correctAnswer == "3") || (sender === button4 && correctAnswer == "4") {
            correctQuestions += 1
            questionField.text = "Correct!"
            countdown.invalidate()
            playSound(resource: correctSoundFile, type: soundType, sound: &correctSound)
        } else {
            questionField.text = "Sorry, wrong answer!"
            countdown.invalidate()
            highlightCorrect()
            playSound(resource: incorrectSoundFile, type: soundType, sound: &incorrectSound)
        }
        loadNextRoundWithDelay(seconds: 2)
//        self.trivia.remove(at: self.indexOfSelectedQuestion)
    }
    
    func nextRound() {
        if questionsAsked == questionsPerRound {
            // Game is over
            displayScore()
            playSound(resource: endSoundFile, type: soundType, sound: &endSound)
            assignQuestions()
        } else {
            // Continue game
            displayQuestion()
        }
    }
    
    @IBAction func playAgain() {
        // Show the answer buttons
        button1.isHidden = false
        button2.isHidden = false
        button3.isHidden = false
        button4.isHidden = false
        
        questionsAsked = 0
        correctQuestions = 0
        nextRound()
        playSound(resource: startSoundFile, type: soundType, sound: &startSound)
    }
    

    
// MARK: Helper Methods
    
    func loadNextRoundWithDelay(seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.resetCount()
            self.nextRound()
            self.unhighlightButtons()
        }
    }
    
//Countdown Timer
    func startCountdown() {
    countdown = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.runCountdown), userInfo: nil, repeats: true)
    }
    
    func runCountdown() {
        if (count > 0){
            count -= 1
            countdownLabel.text = String(count)
        }else{
            countdown.invalidate()
            checkAnswer(buttonTimeOut)
        }
    }
    
    func resetCount() {
        countdownLabel.text = "15"
        count = 15
    }
    
//Highlight correct answer
    func highlightCorrect() {
        let selectedQuestionDict = trivia[indexOfSelectedQuestion]
        let correctAnswer = selectedQuestionDict.answer
        if correctAnswer == "1" {
            button1.isSelected = true
        }else if correctAnswer == "2" {
            button2.isSelected = true
        }else if correctAnswer == "3" {
            button3.isSelected = true
        }else{
            button4.isSelected = true
        }
    }
    
    func unhighlightButtons() {
        button1.isSelected = false
        button2.isSelected = false
        button3.isSelected = false
        button4.isSelected = false
    }
    
    
    
    
    
//Game Sounds
    func playSound(resource: String, type: String, sound: inout SystemSoundID) {
        let pathToSoundFile = Bundle.main.path(forResource: resource, ofType: type)
        let soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &sound)
        AudioServicesPlaySystemSound(sound)
    }
    
}

