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
    
// MARK: Variables
    var trivia = [QuestionDetail]()
    
    let questionsPerRound = 4
    var questionsAsked = 0
    var correctQuestions = 0
    var indexOfSelectedQuestion: Int = 0
    
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
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
// MARK: Outlets
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var button4: UIButton!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var countdownLabel: UILabel!
    

    

    override func viewDidLoad() {
        super.viewDidLoad()
        assignQuestions()
        // Start game
        playSound(resource: startSoundFile, type: soundType, sound: &startSound)
        displayQuestion()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpButtons()
    }
    
    
// MARK: Functions
    // Set size of button font and round corners
    func setUpButtons() {
        let btnArray = [button1, button2, button3, button4, playAgainButton]
        
        for btn in btnArray {
            guard let button = btn else { return }
            button.layer.cornerRadius = button.frame.width * 0.03
            button.titleLabel?.font = button.titleLabel?.font.withSize(button.frame.height * 0.3)
        }
    }
    
    // Populate trivia property with questions
    func assignQuestions() {
        trivia = []
        for questionData in Questions().library {
            let question = QuestionDetail(dictionary: questionData)
            trivia.append(question)
        }
    }
    
    // Display question and set button title labels
    func displayQuestion() {
        // Increment the questions asked counter
        questionsAsked += 1
        
        indexOfSelectedQuestion = GKRandomSource.sharedRandom().nextInt(upperBound: trivia.count)
        let questionDictionary = trivia[indexOfSelectedQuestion]
        resultLabel.text = " "
        checkNumberOfAnswers()
        questionLabel.text = questionDictionary.question
        button1.setTitle(questionDictionary.option1, for: .normal)
        button2.setTitle(questionDictionary.option2, for: .normal)
        button3.setTitle(questionDictionary.option3, for: .normal)
        button4.setTitle(questionDictionary.option4, for: .normal)
        playAgainButton.isHidden = true
        startCountdown()
    }
    
    // Check total number of answer options and set button4 alpha if only 3
    func checkNumberOfAnswers() {
        let questionDictionary = trivia[indexOfSelectedQuestion]
        
        if questionDictionary.option4 == "" {
            self.button4.alpha = 0
        } else {
            self.button4.alpha = 1
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
            assignQuestions()
        } else {
            // Continue game
            trivia.remove(at: indexOfSelectedQuestion)
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
            self.unhighlightButtons()
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
            countdown.invalidate()
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
        let selectedQuestionDict = trivia[indexOfSelectedQuestion]
        let correctAnswer = selectedQuestionDict.answer
        print("correctAnswer: \(String(describing: correctAnswer))")
        
        switch correctAnswer {
            case "1":
                button1.tintColor = .white
                print("case 1 called")
            case "2":
                button2.tintColor = .white
                print("case 2 called")
            case "3":
                button3.tintColor = .white
                print("case 3 called")
            case "4":
                button4.tintColor = .white
                print("case 4 called")
            default: return
        }
    }
    
    // Handle button highlighting
    func highlightButtons() {
        let buttons = [button1, button2, button3, button4]
        
        for button in buttons {
            button?.isUserInteractionEnabled = false
            button?.backgroundColor = self.disabledButtonColor
            button?.tintColor = self.disabledButtonFontColor
        }
    }
    
    
    func unhighlightButtons() {
        let buttons = [button1, button2, button3, button4]
        
        for button in buttons {
            button?.isUserInteractionEnabled = true
            button?.backgroundColor = btnColor
            button?.tintColor = .white
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
        highlightButtons()
        highlightCorrect()
        playSound(resource: incorrectSoundFile, type: soundType, sound: &incorrectSound)
    }
    
    // Check if anwer is correct
    func checkAnswer(sender: UIButton) {
        let selectedQuestionDict = trivia[indexOfSelectedQuestion]
        let correctAnswer = selectedQuestionDict.answer
        if sender.restorationIdentifier == correctAnswer {
            correctQuestions += 1
            resultLabel.textColor = btnColor
            resultLabel.text = "Correct!"
            countdown.invalidate()
            playSound(resource: correctSoundFile, type: soundType, sound: &correctSound)
        } else {
            invalidAnswer(fromTimeExpired: false)
        }
        loadNextRoundWithDelay(seconds: 2)
    }


// MARK: Actions
    @IBAction func checkAnswer(_ sender: UIButton) {
        let selectedQuestionDict = trivia[indexOfSelectedQuestion]
        let correctAnswer = selectedQuestionDict.answer
        
        if sender.restorationIdentifier == correctAnswer {
            print("sender.restorationIdentifier == correctAnswer")
            correctQuestions += 1
            resultLabel.textColor = btnColor
            resultLabel.text = "Correct!"
            
            highlightButtons()
            highlightCorrect()
            
            countdown.invalidate()
            playSound(resource: correctSoundFile, type: soundType, sound: &correctSound)
        } else {
            print("sender.restorationIdentifier != correctAnswer")
            invalidAnswer(fromTimeExpired: false)
        }
        loadNextRoundWithDelay(seconds: 2)
    }

    @IBAction func playAgain() {
        // Show the answer buttons
        buttonsAreHidden(areButtonsHidden: false)
        questionsAsked = 0
        correctQuestions = 0
        nextRound()
        playSound(resource: startSoundFile, type: soundType, sound: &startSound)
    }
}


extension UIColor {
    convenience init(hex: String, alpha: CGFloat = 1) {
        assert(hex[hex.startIndex] == "#", "Expected hex string of format #RRGGBB")
        
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 1  // skip #
        
        var rgb: UInt32 = 0
        scanner.scanHexInt32(&rgb)
        
        self.init(
            red:   CGFloat((rgb & 0xFF0000) >> 16)/255.0,
            green: CGFloat((rgb &   0xFF00) >>  8)/255.0,
            blue:  CGFloat((rgb &     0xFF)      )/255.0,
            alpha: alpha)
    }
}
