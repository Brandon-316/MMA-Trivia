//
//  QuestionDetail.swift
//  TrueFalseStarter
//
//  Created by William Mahoney on 9/21/16.
//

import Foundation
import UIKit

struct QuestionDetail {
    
    var question: String?
    var option1: String?
    var option2: String?
    var option3: String?
    var option4: String?
    var answer: String?
    
    init(dictionary: [String: String]) {
        
        question = dictionary["Question"]
        option1 = dictionary["Option1"]
        option2 = dictionary["Option2"]
        option3 = dictionary["Option3"]
        option4 = dictionary["Option4"]
        answer = dictionary["Answer"]
    }
}
