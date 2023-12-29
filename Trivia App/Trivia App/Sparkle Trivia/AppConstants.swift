//
//  AppConstants.swift
//  Trivia App
//
//  Created by HaroldDavidson on 12/10/23.
//
//#### ##  ##   ##    ####   ####       ####    ## ##   ###  ##  #### ##
//# ## ##  ##   ##     ##     ##         ##    ##   ##   ##  ##  # ## ##
//  ##     ##   ##     ##     ##         ##    ##        ##  ##    ##
//  ##     ## # ##     ##     ##         ##    ##  ###   ## ###    ##
//  ##     # ### #     ##     ##         ##    ##   ##   ##  ##    ##
//  ##      ## ##      ##     ##  ##     ##    ##   ##   ##  ##    ##
// ####    ##   ##    ####   ### ###    ####    ## ##   ###  ##   ####

import UIKit

import UIKit

struct AppConstants {
    static let backgroundColor = UIColor.rgb(red: 50, green: 50, blue: 50, alpha: 1)
    static let gryffindorColor = UIColor.rgb(red: 125, green: 25, blue: 21, alpha: 1)
    static let labelColor       = UIColor.white
    static let backgroundImage = UIImage(named: "PTTBackgroundImage")
    static let backgroundVideo = ""
    static let backgroundMusic = ""
    
    static let prodAdMobsKey = "ca-app-pub-6504174477930496/1611814353"
    static let testingAdMobsKey = "ca-app-pub-3940256099942544/2934735716"
    static var titleFont = UIFont(name: "Harry P", size: 70)
    static var buttonFont = UIFont(name: "Papyrus", size: 30)
    static var instructionLabelFont = UIFont(name: "Papyrus", size: 30)
    
    static let appName = "Sparkle Trivia"
    static let showCategories = [("Harry Potter", "example.json"), ("Fantastic Beasts", "example2.json")]
    
    static let gameCategories: [GameCategory] = [
        GameCategory(name: "Classic", vc: ClassicVC()),
        GameCategory(name: "Blitz", vc: BlitzVC()),
        GameCategory(name: "Survival", vc: SurvivalVC()),
        GameCategory(name: "Potions Class", vc: HangmanVC())
    ]
    
    static let hangmanCategories: [HangmanCategories] = [
        HangmanCategories(name: "Characters", file: "Characters.json"),
        HangmanCategories(name: "Death Eaters", file: "Death Eaters.json"),
        HangmanCategories(name: "Locations", file: "Locations.json"),
        HangmanCategories(name: "Magical Beasts", file: "Magical Beasts.json"),
        HangmanCategories(name: "Order Members", file: "Order Members.json"),
        HangmanCategories(name: "Potions", file: "Potions.json"),
        HangmanCategories(name: "Spells", file: "Spells.json")
    ]
    
}

struct GameCategory {
    let name: String
    let vc: UIViewController
}

struct HangmanCategories {
    let name: String
    let file: String
}
