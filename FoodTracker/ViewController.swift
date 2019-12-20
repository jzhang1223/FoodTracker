//
//  ViewController.swift
//  FoodTracker
//
//  Created by Justin Zhang on 7/11/19.
//

import UIKit

class ViewController: UIViewController {

    // Reorganize labels for tutorial and my own stuff, maybe set some pragmas or marks
    var currentSliderValue: Int = 0
    var currentTargetValue: Int = 0
    var score: Int = 0
    var highScore: Int = 0
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var currentSliderLabel: UILabel!
    @IBOutlet weak var currentTargetLabel: UILabel!
    @IBOutlet weak var showSliderValueSwitch: UISwitch!
    @IBOutlet weak var currentScoreLabel: UILabel!
    @IBOutlet weak var currentHighScoreLabel: UILabel!
    //    @IBOutlet weak var sliderStackView: UIStackView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupValues()
        setupLabels()
        setupShowSliderValueSwitch()
//        setupSliderStackView()
    }

    fileprivate func setupValues() {
        let roundedValue = slider.value.rounded()
        currentSliderValue = Int(roundedValue)

        // TODO: is there a better way than to call both of these setters every single time?... should be
        currentTargetValue = generateNewTargetValue()
    }

    fileprivate func setupLabels() {
        setupCurrentTargetLabel()
        setupCurrentSliderLabel()
        setupCurrentScoreLabel()
        setupCurrentHighScoreLabel()
    }

    fileprivate func setupCurrentTargetLabel() {
        currentTargetLabel.text = "Target Value: \(currentTargetValue)"
        currentTargetLabel.sizeToFit()
    }

    fileprivate func setupCurrentSliderLabel() {
        currentSliderLabel.text = ""
        currentSliderLabel.center.x = self.view.center.x
        currentSliderLabel.sizeToFit()
    }

    fileprivate func setupShowSliderValueSwitch() {
        showSliderValueSwitch.isOn = false
    }

    fileprivate func setupCurrentScoreLabel() {
        setScore()
    }

    fileprivate func setupCurrentHighScoreLabel() {
        setHighScore()
    }

//    fileprivate func setupSliderStackView() {
//        sliderStackView.center.x = self.view.center.x
//        sliderStackView.center.y = self.view.center.y
//    }

    @IBAction func addFood() {
        // The window with a title and message
        let alert = UIAlertController(title: "Hello", message: "Something has been done", preferredStyle: .alert)

        // The button that you tap on to "take action"
        let action = UIAlertAction(title: "Eeek!", style: .default, handler: nil)

        alert.addAction(action)

        present(alert, animated:true, completion: nil)
    }

    @IBAction func practiceButton() {

        let alert = UIAlertController(title: "Practice Alert!", message: "This is just a drill.", preferredStyle: .alert)

        let action = UIAlertAction(title: "This is a button", style: .destructive, handler: nil)
        let secondAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)

        alert.addAction(action)
        alert.addAction(secondAction)

        present(alert, animated: false, completion: nil)
    }

    @IBAction func makeSuggestion() {

        let alert = UIAlertController(title: "You should try adding...", message: suggestRandomFood(), preferredStyle: .alert)

        let acceptAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        let declineAction = UIAlertAction(title: "No thanks", style: .default, handler: nil)


        alert.addAction(declineAction)
        alert.addAction(acceptAction)

        present(alert, animated: true, completion: nil)
    }

    /// Generates a random price of food.
    func suggestRandomFood() -> String {

        // Temporarily hardcoded foods with a bit of variety
        enum Food : String, CaseIterable {
            case Broccoli
            case Meat
            case Tofu
            case Watermelon
            case Milk
            case Bread
        }
        let suggestedFood = Food.allCases.randomElement()
        return suggestedFood!.rawValue
    }

    /// Handles what happens when the slider moves.
    @IBAction func sliderMoved(_ slider: UISlider) {
        slider.isContinuous = true
        currentSliderValue = Int(slider.value.rounded())
        showSliderLabelText(shouldShowText: showSliderValueSwitch.isOn)
    }

    /// Handles what happens when the button to check the slider is hit.
    @IBAction func checkSlider() {
        let scoreResult = getScoreResult(sliderValue: currentSliderValue, targetValue: currentTargetValue)
        let alert = UIAlertController(title: "Result", message: getMessage(scoreResult: scoreResult), preferredStyle: .alert)

        let acknowledge = UIAlertAction(title: "Ok", style: .default) { (alert: UIAlertAction!) in
            self.currentTargetValue = self.generateNewTargetValue()
            self.setupCurrentTargetLabel()
            self.score += scoreResult.getPoints()
            self.setScore()
        }

        alert.addAction(acknowledge)
        present(alert, animated: true, completion: nil)
    }

    /// Handles the action on the show/hide current slider value switch
    @IBAction func switchFlipped(_ uiSwitch: UISwitch) {
        showSliderLabelText(shouldShowText: uiSwitch.isOn)
    }

    /// Show or hide the slider label.
    private func showSliderLabelText(shouldShowText: Bool) {
        currentSliderLabel.text = shouldShowText ? "Current Slider Value: \(currentSliderValue)" : ""
        currentSliderLabel.sizeToFit()
        currentSliderLabel.center.x = self.view.center.x
    }

    private func setScore() {
        currentScoreLabel.text = "Score: \(score)"
        currentScoreLabel.sizeToFit()
    }

    // TODO: implement high scores
    private func setHighScore() {
        currentHighScoreLabel.text = "High Score: \(highScore)"
        currentHighScoreLabel.sizeToFit()
    }

    /// Returns the proper message based on the score of the user and the target value.
    public func getMessage(scoreResult: Scoring) -> String {
        return scoreResult.getMessage()
    }

    public func getScoreResult(sliderValue: Int, targetValue: Int) -> Scoring {
        let difference = abs(sliderValue - targetValue)
        return Scoring(difference: difference)
    }

    /// Generates a new target value based on the min and max of the slider.
    private func generateNewTargetValue() -> Int {
        return Int.random(in: Int(slider.minimumValue)...Int(slider.maximumValue))
    }
}

