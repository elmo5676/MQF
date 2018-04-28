//
//  ViewController.swift
//  MQF
//
//  Created by elmo on 4/26/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        dropDownMenus()
        userDefaults()
        numberOfQuestionsDD.isHidden = true
        
    }
    
    var numberOfQuestions = "All"
    var answersDisplayed = true
    var t38OrU2 = "T-38"
    var questionSet = "Random"
    
    var markedQuestionT38 = [Int]()
    var markedQuestionU2 = [Int]()
    
    func userDefaults(){
        if let markedQuestionT38_ = UserDefaults.standard.object(forKey: "markedQuestionT38") {
            markedQuestionT38 = markedQuestionT38_ as! [Int]
        }
        if let markedQuestionU2_ = UserDefaults.standard.object(forKey: "markedQuestionU2") {
            markedQuestionU2 = markedQuestionU2_ as! [Int]
        }
    }
    
    func alertIfMarkedIsEmpty() {
        if t38OrU2 == "T-38" {
            if markedQuestionT38.isEmpty {
                let alertController = UIAlertController(title: "No Marked Questions", message:
                    "You haven't stored any marked questions", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            } else {
            }
        } else if t38OrU2 == "U-2" {
            if markedQuestionU2.isEmpty {
                let alertController = UIAlertController(title: "No Marked Questions", message:
                    "You haven't stored any marked questions", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default,handler: nil))
            } else {
            }
        }
    }
    
    
    
    @IBOutlet weak var mqfLabel: UILabel!
    
    @IBAction func wichMQFSelectedButton(_ sender: UIButton) {
        if let title = sender.titleLabel {
            if title.text == "T-38" {
                t38OrU2 = "T-38"
                mqfLabel.text = "T-38"
            } else if title.text == "U-2" {
                t38OrU2 = "U-2"
                mqfLabel.text = "U-2"
            }
        }
    }
    
    
    
    func dropDownMenus(){
        numberOfQuestionsDD.initMenu(["All", "100", "50", "25"], actions: [
            ({ self.numberOfQuestions = "All" }),
            ({ self.numberOfQuestions = "100" }),
            ({ self.numberOfQuestions = "50" }),
            ({ self.numberOfQuestions = "25" })
            ])
    
        answersDisplayedDD.initMenu(["All Answers", "Correct Answers"], actions: [
            ({ self.answersDisplayed = true }),
            ({ self.answersDisplayed = false })
            ])
        
        questionSetDD.initMenu(["Random","Marked","Incorrect"], actions: [
            ({ self.questionSet = "Random"; self.numberOfQuestionsDD.isHidden = false }),
            ({ self.questionSet = "Marked"; self.numberOfQuestionsDD.isHidden = true }),
            ({ self.questionSet = "Incorrect"; self.numberOfQuestionsDD.isHidden = true })
            ])
    }
    
    @IBOutlet var questionSetDD: DropMenuButton!
    @IBOutlet var numberOfQuestionsDD: DropMenuButton!
    @IBOutlet var answersDisplayedDD: DropMenuButton!
    @IBOutlet var startQuiz: UIButton!
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch segue.identifier {
        case "startQuizSeque"?:
            let destinationViewController = segue.destination as! quizViewController
            destinationViewController.numberOfQuestions = numberOfQuestions
            destinationViewController.answersDisplayed = answersDisplayed
            destinationViewController.t38OrU2 = t38OrU2
            destinationViewController.questionSet = questionSet
        default:
            preconditionFailure("Unexpected segue identifier")
        }
    }
    
}






