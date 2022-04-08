//
//  ViewController.swift
//  Flashcards2
//
//  Created by Yi Yang Wei on 3/18/22.
//

import UIKit

struct Flashcard{
    var question: String
    var answer: String
}
class ViewController: UIViewController {

    @IBOutlet weak var QuestionFrontLabel: UILabel!
    @IBOutlet weak var AnswerBackLabel: UILabel!
    
    @IBOutlet weak var card: UIView!
    
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var prevButton: UIButton!
    // Array to hold flashcards
    var flashcards = [Flashcard]()
    var currentIndex = 0
    var x_val = 0.0
    override func viewDidLoad() {
        super.viewDidLoad()
        readSavedFlashcards()
        QuestionFrontLabel.isHidden = false
        AnswerBackLabel.isHidden = true
        if flashcards.count == 0{
        updateFlashcard(question: "What is the capital the United States", answer: "Washington DC")
        }
        else{
            updateLabels()
            updateNextPrevButtons()
        }
    }

    @IBAction func tapOnFlash(_ sender: Any) {
        flipFlashcard()
    }
    
    func flipFlashcard(){
        QuestionFrontLabel.isHidden = true
        AnswerBackLabel.isHidden = false
        if nextButton.isEnabled{
            UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromRight, animations: {self.QuestionFrontLabel.isHidden = true})
        }
        else if prevButton.isEnabled{
            UIView.transition(with: card, duration: 0.3, options: .transitionFlipFromLeft, animations: {self.QuestionFrontLabel.isHidden = true})
        }
    }
    
    
    func saveAllFlashcardsToDisk(){
        let dictionaryArray = flashcards.map { (card) -> [String: String] in
            return ["question":card.question, "answer":card.answer]
        }
        //Save array on disk using UserDefaults
        UserDefaults.standard.set(dictionaryArray, forKey: "flashcards")
        print("Flashcards saved to UserDefaults")
    }
    func readSavedFlashcards(){
        // Read dictionary array from disk
        if let dictionaryArray = UserDefaults.standard.array(forKey: "flashcards") as? [[String: String]]{
            let saveCards = dictionaryArray.map{ dictionary -> Flashcard in
                return Flashcard(question: dictionary["question"]!, answer: dictionary["answer"]!)
            }
            flashcards.append(contentsOf: saveCards)
        }
    }
    func updateNextPrevButtons(){
        if currentIndex == flashcards.count - 1 {
            nextButton.isEnabled = false
        }
        else{
            nextButton.isEnabled = true
        }
        if currentIndex == 0{
            prevButton.isEnabled = false
        }
        else{
            prevButton.isEnabled = true
        }
    }
    func updateLabels(){
        let currentFlashcard = flashcards[currentIndex]
        QuestionFrontLabel.text = currentFlashcard.question
        AnswerBackLabel.text = currentFlashcard.answer
    }
    
    func updateFlashcard(question: String, answer: String){
        let flashcard = Flashcard(question: question, answer: answer)
//        QuestionFrontLabel.text = question
//        AnswerBackLabel.text = answer
        //Adding flashcard in the flashcards array
        flashcards.append(flashcard)
        QuestionFrontLabel.isHidden = false
        AnswerBackLabel.isHidden = true
        print("Add new flashcards :)")
        print("We now have \(flashcards.count) flashcards")
        currentIndex = flashcards.count - 1
        print("our current index is \(currentIndex)")
        
        updateNextPrevButtons()
        updateLabels()
        saveAllFlashcardsToDisk()
    }
    
    
    func animatedCardOut(){
        UIView.animate(withDuration: 0.1, animations: {
            self.card.transform = CGAffineTransform.identity.translatedBy(x: self.x_val, y: 0.0)
        }, completion: { finished in
            self.updateLabels()
            self.animateCardIn()
        })
    }
    func animateCardIn(){
        card.transform = CGAffineTransform.identity.translatedBy(x: -self.x_val, y: 0.0)
        UIView.animate(withDuration: 0.3){
            self.card.transform = CGAffineTransform.identity
        }
    }
    
    
    
    @IBAction func didTapOnPrev(_ sender: Any) {
        currentIndex = currentIndex - 1
        updateLabels()
        updateNextPrevButtons()
        QuestionFrontLabel.isHidden = false
        AnswerBackLabel.isHidden = true
        x_val = 300.0
        animatedCardOut()
    }
    
    @IBAction func didTapOnNext(_ sender: Any) {
        currentIndex = currentIndex + 1
        updateLabels()
        updateNextPrevButtons()
        QuestionFrontLabel.isHidden = false
        AnswerBackLabel.isHidden = true
        x_val = -300.0
        animatedCardOut()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender:Any?){
        let navigationController = segue.destination as! UINavigationController
        let creationController = navigationController.topViewController as! CreationViewController
        creationController.flashcardsController = self
    }
    
}

