//
//  Question.swift
//  Trivia App
//
//  Created by HaroldDavidson on 12/24/23.
//

import Foundation

class QuestionModelData {
    var json = ""
    var questions: [Question]
    init(json: String, numberOfQuestions: Int) {
        self.json = json
        self.questions = loadQuestions(self.json)
        questions = randomizeAnswers(questions: questions, numberOfQuestions: numberOfQuestions)
    }
    
    fileprivate func randomizeAnswers(questions: [Question], numberOfQuestions: Int) -> [Question] {
        
//        Finding the longest answer text to test against
//        self.questions = self.questions.sorted(by: { $0.optionZero!.count > $1.optionZero!.count })
//        print(self.questions[0].optionZero!)
//        
//        self.questions = self.questions.sorted(by: { $0.optionOne!.count > $1.optionOne!.count })
//        print(self.questions[0].optionOne!)
//        
//        self.questions = self.questions.sorted(by: { $0.optionTwo!.count > $1.optionTwo!.count })
//        print(self.questions[0].optionTwo!)
//        
//        self.questions = self.questions.sorted(by: { $0.optionThree!.count > $1.optionThree!.count })
//        print(self.questions[0].optionThree!)
        
        self.questions = questions.shuffled()
        self.questions = Array(self.questions.prefix(numberOfQuestions))
//        var longestQuestion = ""
        for var question in self.questions {
//            finding the longest question
//            if question.question?.count ?? 0 > longestQuestion.count {
//                longestQuestion = question.question ?? ""
//            }
            var answerArray = [question.optionZero, question.optionOne, question.optionTwo, question.optionThree]
            let answer = answerArray[question.answer ?? 0]
            answerArray.shuffle()
            question.optionZero = answerArray[0]
            question.optionOne = answerArray[1]
            question.optionTwo = answerArray[2]
            question.optionThree = answerArray[3]
            question.answer = answerArray.firstIndex(where: {
                $0 == answer
            })
        }
//        print(longestQuestion)
        return self.questions
    }
}

func loadQuestions<T: Decodable>(_ filename: String) -> T {
    let data: Data
    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }
    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }
    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

struct Question: Codable {
    let category: String?
    let question: String?
    var answer: Int?
    var optionZero: String?
    var optionOne: String?
    var optionTwo: String?
    var optionThree: String?
}
