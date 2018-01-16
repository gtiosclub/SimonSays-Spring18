//
//  ViewController.swift
//  Simon Says
//
//  Created by Alejandrina Patron on 1/11/18.
//  Copyright © 2018 Alejandrina Patron. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    
    @IBOutlet weak var greenButton: UIButton!
    @IBOutlet weak var redButton: UIButton!
    @IBOutlet weak var blueButton: UIButton!
    @IBOutlet weak var yellowButton: UIButton!

    let colorHighlightTime = 0.5
    var buttons = [Int : UIButton]()
    
    var gameState: GameState = .NotPlaying
    let maxLevel = 10
    var currentLevel = 1
    
    var pattern = [Int]()
    var playerPattern = [Int]()
    var patternIndex = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        buttons[0] = greenButton
        buttons[1] = redButton
        buttons[2] = blueButton
        buttons[3] = yellowButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    @IBAction func startButtonPressed(_ sender: UIButton) {
        startButton.isHidden = true
        gameState = .PatternPlaying
        startGame()
    }
    
    @IBAction func colorButtonPressed(_ sender: UIButton) {
        if gameState == .UserPlaying {
            playerPattern.append(sender.tag)
            patternIndex += 1
            animateButton(buttonTag: sender.tag, completionHandler: {
                self.verifyPattern()
            })
        }
    }
    
    func startGame() {
        for _ in 1...maxLevel {
            pattern.append(Int(arc4random_uniform(4)))
        }
        playPattern(colorPosition: currentLevel)
    }
    
    func playPattern(colorPosition: Int) {
        if (colorPosition > currentLevel) {
            gameState = .UserPlaying
            return
        }
        let buttonTag = pattern[colorPosition - 1]
        animateButton(buttonTag: buttonTag, completionHandler: {
            self.playPattern(colorPosition: colorPosition + 1)
        })
    }
    
    func animateButton(buttonTag: Int, completionHandler: @escaping () -> ()) {
        let button = buttons[buttonTag]
        UIView.animate(withDuration: colorHighlightTime, animations: {
            button?.alpha = 0.5
        }, completion: { finished in
            button?.alpha = 1.0
            completionHandler()
        })
    }
    
    func verifyPattern() {
        let patternTag = pattern[patternIndex]
        let playerTag = playerPattern[patternIndex]
        if patternTag != playerTag {
            // TODO: show losing alert
            print("You lose!")
            resetGame()
        } else if patternIndex == currentLevel - 1 { // Reached end of pattern
            if currentLevel == maxLevel { // Reached max level, player wins
                // TODO: show winning alert
                resetGame()
                print("You win!")
                return
            }
            levelUp()
        }
    }
    
    func levelUp() {
        gameState = .PatternPlaying
        patternIndex = -1
        scoreLabel.text = "Score: \(currentLevel)"
        currentLevel += 1
        playerPattern = []
        playPattern(colorPosition: 1)
    }

    func resetGame() {
        gameState = .NotPlaying
        startButton.isHidden = false
        scoreLabel.text = "Score: 0"
        currentLevel = 1
        pattern = []
        playerPattern = []
        patternIndex = -1
    }
}

enum GameState {
    case UserPlaying
    case PatternPlaying
    case NotPlaying
}

