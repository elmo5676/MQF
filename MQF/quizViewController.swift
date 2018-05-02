//
//  quizViewController.swift
//  MQF
//
//  Created by elmo on 4/27/18.
//  Copyright © 2018 elmo. All rights reserved.
//

import UIKit

class quizViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        assignMQF()
        userDefaultsGet()
        questionNumberArray_()
        setQuestion()
        setAnswerButtonTitles()
        isVisable(answersDisplayed)
        previousQuestionButtonOutlet.alpha = 0.0
        markQuestionButtonOutlet.layer.cornerRadius = 3
        clearQuestionButtonOutlet.layer.cornerRadius = 3
        questionCounter.text = String(questionNumberArray.count)
        self.title = t38OrU2
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isToolbarHidden = false
    }

    //passed in
    var numberOfQuestions = ""
    var answersDisplayed = true
    var t38OrU2 = ""
    var questionSet = "Random"
    
    //Specific to this viewController
    var currentQuestion = 0
    var questionNumberArray = [Int]()
    var markedQuestionT38 = [Int]()
    var markedQuestionU2 = [Int]()
    var incorrectQuestionT38 = [Int]()
    var incorrectQuestionU2 = [Int]()
    
    func questionNumberArray_() {
        if questionSet == "Random" {
            questionNumberArray = numberOfQuestions(mqf.count, numberOfQuestionsIntoInt(numberOfQuestions))
        } else if questionSet == "Marked" {
            if t38OrU2 == "T-38"{
                questionNumberArray = Array(Set(markedQuestionT38)).sorted()
                print(questionNumberArray)
            } else if t38OrU2 == "U-2" {
                questionNumberArray = Array(Set(markedQuestionU2)).sorted()
                print(questionNumberArray)
            }
        } else if questionSet == "Incorrect" {
            if t38OrU2 == "T-38"{
                questionNumberArray = Array(Set(incorrectQuestionT38)).sorted()
                print(questionNumberArray)
            } else if t38OrU2 == "U-2" {
                questionNumberArray = Array(Set(incorrectQuestionU2)).sorted()
                print(questionNumberArray)
            }
        }
    }
    
    func userDefaultsGet(){
        if let markedQuestionT38_ = UserDefaults.standard.object(forKey: "markedQuestionT38") {
            markedQuestionT38 = markedQuestionT38_ as! [Int]
        }
        if let markedQuestionU2_ = UserDefaults.standard.object(forKey: "markedQuestionU2") {
            markedQuestionU2 = markedQuestionU2_ as! [Int]
        }
        if let incorrectQuestionT38_ = UserDefaults.standard.object(forKey: "incorrectQuestionT38") {
            incorrectQuestionT38 = incorrectQuestionT38_ as! [Int]
        }
        if let incorrectQuestionU2_ = UserDefaults.standard.object(forKey: "incorrectQuestionU2") {
            incorrectQuestionU2 = incorrectQuestionU2_ as! [Int]
        }
        
        
    }
    func userDefaultSet(){
        UserDefaults.standard.set(markedQuestionT38, forKey: "markedQuestionT38")
        UserDefaults.standard.set(markedQuestionU2, forKey: "markedQuestionU2")
        UserDefaults.standard.set(incorrectQuestionT38, forKey: "incorrectQuestionT38")
        UserDefaults.standard.set(incorrectQuestionU2, forKey: "incorrectQuestionU2")
    }
    
    //MQF Declaration
    let mqf_T38 = MQF().T38_MQF
    let mqf_U2 = MQF().U2_MQF
    var mqf = [Int: [String : String]]()
    
    
    
    @IBOutlet weak var questionCounter: UILabel!
    @IBOutlet weak var referenceButtonOutlet: UIButton!
//    @IBAction func referenceButton(_ sender: UIButton) {
//    }
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerButton_01_Outlet: UIButton!
    @IBOutlet weak var answerButton_02_Outlet: UIButton!
    @IBOutlet weak var answerButton_03_Outlet: UIButton!
    @IBOutlet weak var answerButton_04_Outlet: UIButton!
    @IBOutlet weak var answerButton_05_Outlet: UIButton!
    @IBAction func answerButton(_ sender: UIButton) {
        isCorrectAnswer()
        let dict = mqf[questionNumberArray[currentQuestion]]!
        let keyOfAnswer = [(dict.filter {$0.value == sender.currentTitle}).keys]
        if keyOfAnswer[0].contains("CA") == false {
            markIncorrectAnswers()
        }
        
        
    }
    
    //Previous and Next buttons
    @IBOutlet weak var nextQuestionButtonOutlet: UIButton!
    @IBAction func nextQuestionButton(_ sender: UIButton) {
        currentQuestion += 1
        resetButtonColors()
        isVisable(answersDisplayed)
        setQuestion()
        setAnswerButtonTitles()
        questionCounter.text = String(questionNumberArray.count - currentQuestion)
        if currentQuestion > 0 {
            previousQuestionButtonOutlet.alpha = 1.0
            //previousQuestionButtonOutlet.isEnabled = true
        }
        if currentQuestion == questionNumberArray.count - 1 {
            nextQuestionButtonOutlet.alpha = 0.0
            //nextQuestionButtonOutlet.isEnabled = false
        }
    }
    @IBOutlet weak var previousQuestionButtonOutlet: UIButton!
    @IBAction func previousQuestionButton(_ sender: UIButton) {
        currentQuestion -= 1
        resetButtonColors()
        isVisable(answersDisplayed)
        setQuestion()
        setAnswerButtonTitles()
        questionCounter.text = String(questionNumberArray.count - currentQuestion)
        if currentQuestion == 0 {
            previousQuestionButtonOutlet.alpha = 0.0
            //previousQuestionButtonOutlet.isEnabled = false
        }
        if currentQuestion < (questionNumberArray.count - 1) {
            nextQuestionButtonOutlet.alpha = 1.0
            //nextQuestionButtonOutlet.isEnabled = true
        }
    }
    
    
    //sets the chosen MQF T-38 or U-2
    func assignMQF() {
        if t38OrU2 == "T-38" {
            mqf = mqf_T38
        } else if t38OrU2 == "U-2" {
            mqf = mqf_U2
        }
    }
    
    //Makes sure the number of questions passed from start page is an Int
    func numberOfQuestionsIntoInt(_ numberOfQuestions: String) -> Int {
        var number = 0
        if numberOfQuestions == "All" {
            number = mqf.count
        } else {
            if let numbOfQ = Int(numberOfQuestions) {
                number = numbOfQ
            }
        }
        return number
    }

    //creates an array of Ints to pull corresponding questions from the MQF
    func numberOfQuestions(_ totalQuestInMQF: Int, _ numOfQuestDesired: Int) -> [Int] {
        let totalNumber = totalQuestInMQF
        var numberArray = [Int]()
        let numberIWant = numOfQuestDesired
        var numberIwantArray = [Int]()
        for i in 1...totalNumber {
            numberArray.append(i)
        }
        for _ in 1...(numberIWant) {
            let arrayKey = Int(arc4random_uniform(UInt32(numberArray.count)))
            numberIwantArray.append(numberArray[arrayKey])
            numberArray.remove(at: arrayKey)
        }
        
        numberIwantArray = Set(numberIwantArray).sorted()
        return numberIwantArray
    }

    //returns the answer for corresponding quesion number (questionNumber is the Dictionary Number NOT the current question array position
    //returns true if the answer is correct or fals if it's not
    func answer(_ questionNumber: Int,_ abOrc: String) -> (answer: String, isCorrect: Bool) {
        var answer  = ""
        var isCorrect = true
        if mqf[questionNumber]!["CA"]!.prefix(1) == abOrc {
            answer = mqf[questionNumber]!["CA"]!
            isCorrect = true
        } else if mqf[questionNumber]!["IC_1"]!.prefix(1) == abOrc {
            answer = mqf[questionNumber]!["IC_1"]!
            isCorrect = false
        } else if mqf[questionNumber]!["IC_2"]!.prefix(1) == abOrc {
            answer = mqf[questionNumber]!["IC_2"]!
            isCorrect = false
        } else if mqf[questionNumber]!["IC_3"]!.prefix(1) == abOrc {
            answer = mqf[questionNumber]!["IC_3"]!
            isCorrect = false
        } else if mqf[questionNumber]!["IC_4"]!.prefix(1) == abOrc {
            answer = mqf[questionNumber]!["IC_4"]!
            isCorrect = false
        } else if mqf[questionNumber]!["REF_"]!.prefix(1) == abOrc {
            answer = mqf[questionNumber]!["REF_"]!
            isCorrect = false
        }
        return (answer, isCorrect)
    }
    
    //sets question label corresponding question from the dictionary
    func setQuestion() {
        let questionNumber = questionNumberArray[currentQuestion]
        questionLabel.text = mqf[questionNumber]!["Q"]!
    }
    
    //sets answets to corresponding answers from the dictionary
    func setAnswerButtonTitles() {
        answerButton_01_Outlet.setTitle(answer(questionNumberArray[currentQuestion], "A").answer, for: .normal)
        answerButton_02_Outlet.setTitle(answer(questionNumberArray[currentQuestion], "B").answer, for: .normal)
        answerButton_03_Outlet.setTitle(answer(questionNumberArray[currentQuestion], "C").answer, for: .normal)
        answerButton_04_Outlet.setTitle(answer(questionNumberArray[currentQuestion], "D").answer, for: .normal)
        answerButton_05_Outlet.setTitle(answer(questionNumberArray[currentQuestion], "E").answer, for: .normal)
        referenceButtonOutlet.setTitle(answer(questionNumberArray[currentQuestion], "R").answer, for: .normal)
        answerButton_01_Outlet.contentHorizontalAlignment = .left
        answerButton_02_Outlet.contentHorizontalAlignment = .left
        answerButton_03_Outlet.contentHorizontalAlignment = .left
        answerButton_04_Outlet.contentHorizontalAlignment = .left
        answerButton_05_Outlet.contentHorizontalAlignment = .left
        referenceButtonOutlet.contentHorizontalAlignment = .left

    }

    //returns tuple: color for answer text and true/false if answer is correct
    func correctAnswerButtonTitleColor(_ currentQuestion: Int,_ abOrc: String) -> (color: UIColor, isCorrect: Bool) {
        var isCorrect = true
        var color = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        if mqf[currentQuestion]!["CA"]!.prefix(1) == abOrc {
            isCorrect = true
            color = #colorLiteral(red: 0.2745098174, green: 0.4862745106, blue: 0.1411764771, alpha: 1)
        } else {
            isCorrect = false
            color = #colorLiteral(red: 1, green: 0.1476880014, blue: 0, alpha: 1)
        }
        return (color, isCorrect)
    }
    
    func markIncorrectAnswers(){
        if t38OrU2 == "T-38" {
            incorrectQuestionT38.append(questionNumberArray[currentQuestion])
        } else if t38OrU2 == "U-2" {
            incorrectQuestionU2.append(questionNumberArray[currentQuestion])
        }
        userDefaultSet()
    }

    func isCorrectAnswer() {
        answerButton_01_Outlet.setTitleColor(correctAnswerButtonTitleColor(questionNumberArray[currentQuestion], "A").color, for: .normal)
        answerButton_02_Outlet.setTitleColor(correctAnswerButtonTitleColor(questionNumberArray[currentQuestion], "B").color, for: .normal)
        answerButton_03_Outlet.setTitleColor(correctAnswerButtonTitleColor(questionNumberArray[currentQuestion], "C").color, for: .normal)
        answerButton_04_Outlet.setTitleColor(correctAnswerButtonTitleColor(questionNumberArray[currentQuestion], "D").color, for: .normal)
        answerButton_05_Outlet.setTitleColor(correctAnswerButtonTitleColor(questionNumberArray[currentQuestion], "E").color, for: .normal)
    }
    
    func resetButtonColors() {
        let resetColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        answerButton_01_Outlet.setTitleColor(resetColor, for: .normal)
        answerButton_02_Outlet.setTitleColor(resetColor, for: .normal)
        answerButton_03_Outlet.setTitleColor(resetColor, for: .normal)
        answerButton_04_Outlet.setTitleColor(resetColor, for: .normal)
        answerButton_05_Outlet.setTitleColor(resetColor, for: .normal)
    }
    
    func isVisable(_ allVisable: Bool) {
        if allVisable == false {
            if answer(questionNumberArray[currentQuestion], "A").isCorrect == true {
                answerButton_01_Outlet.isHidden = false
                answerButton_02_Outlet.isHidden = true
                answerButton_03_Outlet.isHidden = true
                answerButton_04_Outlet.isHidden = true
                answerButton_05_Outlet.isHidden = true
            } else if answer(questionNumberArray[currentQuestion], "B").isCorrect == true {
                answerButton_01_Outlet.isHidden = true
                answerButton_02_Outlet.isHidden = false
                answerButton_03_Outlet.isHidden = true
                answerButton_04_Outlet.isHidden = true
                answerButton_05_Outlet.isHidden = true
            } else if answer(questionNumberArray[currentQuestion], "C").isCorrect == true {
                answerButton_01_Outlet.isHidden = true
                answerButton_02_Outlet.isHidden = true
                answerButton_03_Outlet.isHidden = false
                answerButton_04_Outlet.isHidden = true
                answerButton_05_Outlet.isHidden = true
            } else if answer(questionNumberArray[currentQuestion], "D").isCorrect == true {
                answerButton_01_Outlet.isHidden = true
                answerButton_02_Outlet.isHidden = true
                answerButton_03_Outlet.isHidden = true
                answerButton_04_Outlet.isHidden = false
                answerButton_05_Outlet.isHidden = true
            } else if answer(questionNumberArray[currentQuestion], "E").isCorrect == true {
                answerButton_01_Outlet.isHidden = true
                answerButton_02_Outlet.isHidden = true
                answerButton_03_Outlet.isHidden = true
                answerButton_04_Outlet.isHidden = true
                answerButton_05_Outlet.isHidden = false
            }
        }
    }
    
    func markQuestions(){
        if t38OrU2 == "T-38" {
            markedQuestionT38.append(questionNumberArray[currentQuestion])
        } else if t38OrU2 == "U-2" {
            markedQuestionU2.append(questionNumberArray[currentQuestion])
        }
        userDefaultSet()
    }
    
    @IBOutlet weak var markQuestionButtonOutlet: UIButton!
    @IBOutlet weak var clearQuestionButtonOutlet: UIButton!
    @IBAction func markQuestionButton(_ sender: UIButton) {
        markQuestions()
    }
    
    @IBAction func clearMarkedU2QuestionsButton(_ sender: UIBarButtonItem) {
        markedQuestionU2.removeAll()
        userDefaultSet()
    }
    @IBAction func clearMarkedT38QuestionsButton(_ sender: UIBarButtonItem) {
        markedQuestionT38.removeAll()
        userDefaultSet()
    }
    @IBAction func clearIncorrectU2Button(_ sender: Any) {
        incorrectQuestionU2.removeAll()
        userDefaultSet()
    }
    @IBAction func clearIncorrectT38Button(_ sender: Any) {
        incorrectQuestionT38.removeAll()
        userDefaultSet()
    }
    @IBAction func clearAllButton(_ sender: UIButton) {
        markedQuestionU2.removeAll()
        markedQuestionT38.removeAll()
        incorrectQuestionU2.removeAll()
        incorrectQuestionT38.removeAll()
        userDefaultSet()
    }
    
    

    




























}
