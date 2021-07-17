//
//  GCSViewController.swift
//  EMTools
//
//  Created by Joel Payne on 4/16/17.
//  Copyright © 2017 Joel Payne. All rights reserved.
//

import UIKit

class GCSViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - StoryBoard Outlets

    @IBOutlet var GCSLabel: UILabel!
    @IBOutlet var eyesLabel: UILabel!
    @IBOutlet var eyesPickerView: UIPickerView!
    @IBOutlet var verbalLabel: UILabel!
    @IBOutlet var verbalPickerView: UIPickerView!
    @IBOutlet var motorLabel: UILabel!
    @IBOutlet var motorPickerView: UIPickerView!

    // MARK: - StoryBoard Actions


    @IBAction func callEagleMedButton(_ sender: Any) {
        if let url = URL(string: "tel://18005255220") {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }
    }

    // MARK: - Constants and Variables

    let eyesArray: [String] = ["Spontaneously +4", "To Verbal Command +3", "To Pain +2", "No Response +1"]
    let eyesScoreArray: [Int] = [4, 3, 2, 1]
    let verbalArray: [String] = ["Oriented +5", "Confused +4", "Inappropriate Words +3", "Incomprehensible Sounds +2", "No Response +1"]
    let verbalScoreArray: [Int] = [5, 4, 3, 2, 1]
    let motorArray: [String] = ["Obeys Commands +6", "Localizes Pain +5", "Withdrawal From Pain +4", "Flexion to Pain +3", "Extension to Pain +2", "No Response +1"]
    let motorScoreArray: [Int] = [6, 5, 4, 3, 2, 1]

    // MARK: - Actions

    func calculateGCS() {
        let eyesScore = eyesScoreArray[eyesPickerView.selectedRow(inComponent: 0)]
        let verbalScore = verbalScoreArray[verbalPickerView.selectedRow(inComponent: 0)]
        let motorScore = motorScoreArray[motorPickerView.selectedRow(inComponent: 0)]
        eyesLabel.text = "Eyes: " + "\(eyesScore)"
        verbalLabel.text = "Verbal: " + "\(verbalScore)"
        motorLabel.text = "Motor: " + "\(motorScore)"
        GCSLabel.text = "\(eyesScore + verbalScore + motorScore)"
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        eyesPickerView.delegate = self
        verbalPickerView.delegate = self
        motorPickerView.delegate = self
        calculateGCS()
    }

    // MARK: - UIPickerView Configuration

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == eyesPickerView {
            return eyesArray.count
        } else if pickerView == verbalPickerView {
            return verbalArray.count
        } else {
            return motorArray.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == eyesPickerView {
            return eyesArray[row]
        } else if pickerView == verbalPickerView {
            return verbalArray[row]
        } else {
            return motorArray[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        calculateGCS()
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
