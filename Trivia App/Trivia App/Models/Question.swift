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
        self.questions = Array(questions.prefix(numberOfQuestions))
        questions = randomizeAnswers(questions: questions)
    }
    
    fileprivate func randomizeAnswers(questions: [Question]) -> [Question] {
        self.questions = questions.shuffled()
        for var question in self.questions {
            var answerArray = [question.optionZero, question.optionOne, question.optionTwo, question.optionThree]
            let answer = answerArray[question.answer ?? 0]
            answerArray.shuffle()
            question.answer = answerArray.firstIndex(where: {
                $0 == answer
            })
        }
        return questions
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
    let optionZero: String?
    let optionOne: String?
    let optionTwo: String?
    let optionThree: String?
}
