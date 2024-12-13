//
//  UnitConversionViewController.swift
//  EMTools
//
//  Created by Joel Payne on 4/16/17.
//  Copyright © 2017 Joel Payne. All rights reserved.
//

import UIKit

class UnitConversionViewController: UIViewController {

    // MARK: - Storyboard Outlets

    @IBOutlet var weightTextField: UITextField!
    @IBOutlet var weightSegementedControl: UISegmentedControl!
    @IBOutlet var weightLabel: UILabel!
    @IBOutlet var tempTextField: UITextField!
    @IBOutlet var tempSegementedControl: UISegmentedControl!
    @IBOutlet var tempLabel: UILabel!

    // MARK: - StoryBoard Actions

    @IBAction func weightEditingChanged(_ sender: Any) {
        convert()
    }

    @IBAction func weightSegementedControlChanged(_ sender: Any) {
        convert()
    }

    @IBAction func tempEditingChanged(_ sender: Any) {
        convert()
    }

    @IBAction func tempSegementedControlChanged(_ sender: Any) {
        convert()
    }

    // MARK: - Actions

    func convert() {
        if !weightTextField.double.isZero {
            if weightSegementedControl.selectedSegmentIndex == 0 {
                let rounded: Double = weightTextField.double * 0.453592
                weightLabel.text = rounded.roundToOne() + " kg"
            } else {
                let rounded: Double = weightTextField.double / 0.453592
                weightLabel.text = rounded.roundToOne() + " lbs"
            }
        }
        if !tempTextField.double.isZero {
            if tempSegementedControl.selectedSegmentIndex == 0 {
                let rounded: Double = (tempTextField.double - 32) / 1.8
                tempLabel.text = rounded.roundToOne() + " °C"
            } else {
                let rounded: Double = tempTextField.double * 1.8 + 32
                tempLabel.text = rounded.roundToOne() + " °F"
            }
        }
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectAllText()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
