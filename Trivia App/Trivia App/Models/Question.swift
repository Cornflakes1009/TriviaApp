//
//  Question.swift
//  Trivia App
//
//  Created by HaroldDavidson on 12/24/23.
//

import Foundation

//@Observable
class ClassicModelData {
    var json = ""
    var questions: [Question]
    init(json: String) {
        self.json = json
        self.questions = load(self.json)
    }
}

func load<T: Decodable>(_ filename: String) -> T {
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
    let answer: Int?
    let optionZero: Int?
    let optionOne: Int?
    let optionTwo: Int?
    let optionThree: Int?
}
