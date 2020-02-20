//
//  NewVC.swift
//  TrueFalseStarter
//
//  Created by Brandon Mahoney on 2/19/20.
//  Copyright © 2020 Brandon Mahoney. All rights reserved.
//

import Foundation
import UIKit
import GameKit
import AudioToolbox


class ViewController: UIViewController {
    
// MARK: - Variables
    var library: [Question] = Library().questions
    
    let questionsPerRound = 4
    var questionsAsked = 0
    var correctQuestions = 0
    
    // Sound Clip File Variables
    let soundType = "wav"
    let startSoundFile = "Boxing Bell Start Round"
    let endSoundFile = "Boxing Bell End Round"
    let correctSoundFile = "CorrectSound"
    let incorrectSoundFile = "IncorrectSound"
    
    // System Sound ID's
    var startSound: SystemSoundID = 0
    var endSound: SystemSoundID = 1
    var correctSound: SystemSoundID = 2
    var incorrectSound: SystemSoundID = 3
    
    // Timer
    var countdown = Timer()
    var count = 15
    
    let btnColor = UIColor.init(hex: "#0C7996")
    let rightAnwserColor = UIColor.init(hex: "#EBEBEB")
    let wrongAnswerColor = UIColor.init(hex: "#F2A66E")
    let disabledButtonColor = UIColor.init(hex: "#1A3D52")
    let disabledButtonFontColor = UIColor.init(hex: "#3F5866")
    
    
// MARK: - Outlets
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var countdownLabel: UILabel!

    
// MARK: - Override Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        shuffleLibrary()
        // Start game
        playSound(resource: startSoundFile, type: soundType, sound: &startSound)
        displayQuestion()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpButtons()
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
// MARK: - Functions
    // Set size of button font and round corners
    func setUpButtons() {
        let btnArray = [button1, button2, button3, button4, playAgainButton]
        
        for btn in btnArray {
            guard let button = btn else { return }
            button.layer.cornerRadius = button.frame.width * 0.03
            button.titleLabel?.font = button.titleLabel?.font.withSize(button.frame.height * 0.3)
        }
    }
    
    func shuffleLibrary() {
        // Shuffle library of quesitons
        library.shuffle()
        
        // Shuffle each questions array of answers
        for (index, _) in library.enumerated() {
            library[index].answers.shuffle()
        }
    }
    
    // Display question and set button title labels
    func displayQuestion() {
        let question = library[questionsAsked]
        
        //Set result label to empty space to prevent label from collapsing and shifting subviews
        resultLabel.text = " "
        
        questionLabel.text = question.question
        
        button1.setTitle(question.answers[0].answer, for: .normal)
        button2.setTitle(question.answers[1].answer, for: .normal)
        button3.setTitle(question.answers[2].answer, for: .normal)
        //Check if there are three or four answers and remove fourth button if necessary or populate it
        checkNumber(of: question.answers)
        
        //Increment the questions asked counter
        questionsAsked += 1
        
        playAgainButton.isHidden = true
        startCountdown()
    }
    
    // Check total number of answer options and set button4 alpha if only 3
    func checkNumber(of answers: [Answer]) {
        if answers.count != 4 {
            self.button4.alpha = 0
        } else {
            self.button4.alpha = 1
            self.button4.setTitle(answers[3].answer, for: .normal)
        }
    }
    
    // Handle hiding of all buttons
    func buttonsAreHidden(areButtonsHidden: Bool) {
        let buttons = [button1, button2, button3, button4]
        for button in buttons {
            button?.isHidden = areButtonsHidden
        }
    }
    
    // Display total score
    func displayScore() {
        // Hide the answer buttons
        buttonsAreHidden(areButtonsHidden: true)
        // Display play again button
        playAgainButton.isHidden = false
        
        questionLabel.text = "Way to go!\nYou got \(correctQuestions) out of \(questionsPerRound) correct!"
    }
    
    // Handle next round
    func nextRound() {
        if questionsAsked == questionsPerRound {
            // Game is over
            resultLabel.text = " "
            displayScore()
            playSound(resource: endSoundFile, type: soundType, sound: &endSound)
            shuffleLibrary()
        } else {
            displayQuestion()
        }
    }
    

    
    // Load the next round after a delay
    func loadNextRoundWithDelay(seconds: Int) {
        // Converts a delay in seconds to nanoseconds as signed 64 bit integer
        let delay = Int64(NSEC_PER_SEC * UInt64(seconds))
        // Calculates a time value to execute the method given current time and delay
        let dispatchTime = DispatchTime.now() + Double(delay) / Double(NSEC_PER_SEC)
        
        // Executes the nextRound method at the dispatch time on the main queue
        DispatchQueue.main.asyncAfter(deadline: dispatchTime) {
            self.resetCount()
            self.nextRound()
            self.handleBtn(isHighlighted: false)
        }
    }
    
    // Countdown Timer
    func startCountdown() {
        countdown = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(ViewController.runCountdown), userInfo: nil, repeats: true)
    }
    
    @objc func runCountdown() {
        if (count > 0){
            count -= 1
            countdownLabel.text = String(count)
        }else{
            invalidAnswer(fromTimeExpired: true)
            loadNextRoundWithDelay(seconds: 2)
        }
    }
    
    func resetCount() {
        countdownLabel.text = "15"
        count = 15
    }
    
    // Highlight correct answer
    func highlightCorrect() {
        let buttons = [button1, button2, button3, button4]
        let question = library[questionsAsked - 1]
        
        for (index, answer) in question.answers.enumerated() {
            if answer.isCorrect {
                buttons[index]?.tintColor = .white
            }
        }
    }
    
    // Handle button highlighting
    func handleBtn(isHighlighted: Bool) {
        let buttons: [UIButton] = [button1, button2, button3, button4]
        
        for button in buttons {
            button.isUserInteractionEnabled = !isHighlighted
            button.backgroundColor = isHighlighted ? disabledButtonColor : btnColor
            button.tintColor = isHighlighted ? disabledButtonFontColor : .white
        }
    }

    //Game Sounds
    func playSound(resource: String, type: String, sound: inout SystemSoundID) {
        let pathToSoundFile = Bundle.main.path(forResource: resource, ofType: type)
        let soundURL = URL(fileURLWithPath: pathToSoundFile!)
        AudioServicesCreateSystemSoundID(soundURL as CFURL, &sound)
        AudioServicesPlaySystemSound(sound)
    }
    
    func invalidAnswer(fromTimeExpired: Bool) {
        resultLabel.textColor = wrongAnswerColor
        if fromTimeExpired {
            resultLabel.text = "You're too slow!"
        } else {
            resultLabel.text = "Sorry, wrong answer!"
        }
        countdown.invalidate()
        handleBtn(isHighlighted: true)
        highlightCorrect()
        playSound(resource: incorrectSoundFile, type: soundType, sound: &incorrectSound)
    }
    
    // Check if anwer is correct
    func checkAnswer(with btn: UIButton) {
        let question = library[questionsAsked - 1]
        
        if question.answers[btn.tag].isCorrect {
            correctQuestions += 1
            resultLabel.textColor = btnColor
            resultLabel.text = "Correct!"
            handleBtn(isHighlighted: true)
            highlightCorrect()
            countdown.invalidate()
            playSound(resource: correctSoundFile, type: soundType, sound: &correctSound)
        } else {
            invalidAnswer(fromTimeExpired: false)
        }
        loadNextRoundWithDelay(seconds: 2)
    }
    
    func playAgain() {
        questionsAsked = 0
        correctQuestions = 0
        nextRound()
        buttonsAreHidden(areButtonsHidden: false)
        playSound(resource: startSoundFile, type: soundType, sound: &startSound)
    }


// MARK: - Actions
    @IBAction func checkAnswer(_ sender: UIButton) {
        checkAnswer(with: sender)
    }

    @IBAction func playAgainTapped(_ sender: UIButton) {
        playAgain()
    }
}
