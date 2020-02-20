//
//  Library.swift
//  TrueFalseStarter
//
//  Created by Brandon Mahoney on 2/19/20.
//  Copyright © 2020 Brandon Mahoney. All rights reserved.
//

import Foundation


struct Library {
    var questions: [Question] = [
        Question(question: "Who was the first person to win a UFC title?", answers: [
            Answer(answer: "Dan Severn", isCorrect: false),
            Answer(answer: "Ken Shamrock", isCorrect: false),
            Answer(answer: "Royce Gracie", isCorrect: true),
            Answer(answer: "Pat Smith", isCorrect: false)
            ]),
        Question(question: "Which 2 UFC fighters have won belts in two different divisions?", answers: [
            Answer(answer: "BJ Penn and Robbie Lawler", isCorrect: false),
            Answer(answer: "BJ Penn and Randy Couture", isCorrect: true),
            Answer(answer: "Robbie Lawler and Randy Couture", isCorrect: false),
            Answer(answer: "BJ Penn and Shawn Sherk", isCorrect: false)
        ]),
        Question(question: "Who is the longest reigning UFC champion in history?", answers: [
            Answer(answer: "Anderson Silva", isCorrect: true),
            Answer(answer: "Joseh Aldo", isCorrect: false),
            Answer(answer: "George St. Pierre", isCorrect: false),
            Answer(answer: "Randy Couture", isCorrect: false)
        ]),
        Question(question: "What fighter didn’t just make waves as a pro MMA fighter but also as a criminal when he committed one of the largest bank heists in history?", answers: [
            Answer(answer: "Nick Diaz", isCorrect: false),
            Answer(answer: "Wanderlei Silva", isCorrect: false),
            Answer(answer: "Lee Murray", isCorrect: true),
            Answer(answer: "Kimbo Slice", isCorrect: false)
        ]),
        Question(question: "What UFC fighter also served in his countries parliament?", answers: [
            Answer(answer: "Michael Bisping", isCorrect: false),
            Answer(answer: "Mirko Cro Cop Filipovic", isCorrect: true),
            Answer(answer: "Mark Hunt", isCorrect: false)
//            Answer(answer: "Dan Hardy", isCorrect: false)
        ]),
        Question(question: "What UFC fighter also served in his countries parliament?", answers: [
            Answer(answer: "Chuck Liddell", isCorrect: false),
            Answer(answer: "Pat Smith", isCorrect: false),
            Answer(answer: "Terry Etim", isCorrect: true)
//            Answer(answer: "Jens Pulver", isCorrect: false)
        ]),
        Question(question: "What does the former parent company of the UFC, ZUFFA mena in Italian?", answers: [
            Answer(answer: "Gladiator", isCorrect: false),
            Answer(answer: "Pugilism", isCorrect: false),
            Answer(answer: "Fight", isCorrect: false),
            Answer(answer: "Scuffle", isCorrect: true)
        ])
    ]
}

struct Question {
    let question: String
    var answers: [Answer]
}

struct Answer {
    let answer: String
    let isCorrect: Bool
}
