//
//  IVInfusionRateViewController.swift
//  EMTools
//
//  Created by Joel Payne on 5/5/17.
//  Copyright © 2017 Joel Payne. All rights reserved.
//

import UIKit

class IVInfusionRateViewController: UIViewController, UITextFieldDelegate {
    // MARK: - Storyboard Outlets

    @IBOutlet var doseTextField: UITextField!
    @IBOutlet var doseUnitSelectButton: UIButton!
    @IBOutlet var kgLabel: UILabel!
    @IBOutlet var doseTimeUnitSelectButton: UIButton!
    @IBOutlet var weightSwitch: UISwitch!
    @IBOutlet var weightTextField: UITextField!
    @IBOutlet var weightUnitSelectButton: UIButton!
    @IBOutlet var concentrationDoseTextField: UITextField!
    @IBOutlet var concentrationUnitSelectButton: UIButton!
    @IBOutlet var concentrationVolumeTextField: UITextField!
    @IBOutlet var concentrationVolumeUnitSelectButton: UIButton!
    @IBOutlet var ivRateTimeUnitSelectButton: UIButton!
    @IBOutlet var ivRateLabel: UILabel!

    // MARK: - Storyboard Actions

    @IBAction func calculateButtonAction(_: Any) {
        calculate()
    }

    fileprivate func resetValues() {
        doseTextField.text = ""
        doseUnitSelectButton.setTitleWithOutAnimation(title: "mg")
        kgLabel.text = "/ kg /"
        doseTimeUnitSelectButton.setTitleWithOutAnimation(title: "min")
        weightSwitch.isOn = true
        weightTextField.text = ""
        weightUnitSelectButton.setTitleWithOutAnimation(title: "kg")
        concentrationDoseTextField.text = ""
        concentrationUnitSelectButton.setTitleWithOutAnimation(title: "mg")
        concentrationVolumeTextField.text = ""
        concentrationVolumeUnitSelectButton.setTitleWithOutAnimation(title: "ml")
        ivRateTimeUnitSelectButton.setTitleWithOutAnimation(title: "ml/hr")
        ivRateLabel.text = "IV Infusion Rate: 0"
        dose = 0.0
        infusionTime = 0.0
        weight = 0.0
        concentration = 0.0
        concentrationVolume = 0.0
        concentrationUnitSelectButton.isEnabled = true
        doseUnitSelectButton.isEnabled = true
    }

    @IBAction func clearButtonAction(_: Any) {
        resetValues()
    }

    @IBAction func doseUnitSelectButtonAction(_: Any) {
        presentSelector(dataSource: doseUnit, button: doseUnitSelectButton)
    }

    @IBAction func doseTimeUnitSelectButtonAction(_: Any) {
        presentSelector(dataSource: doseTimeUnit, button: doseTimeUnitSelectButton)
    }

    @IBAction func weightTextFieldEditingChanged(_: Any) {
        //        calculate()
    }

    @IBAction func weightSwitchDidChange(_: Any) {
        switch weightSwitch.isOn {
        case false:
            kgLabel.text = "/"
        default:
            kgLabel.text = "/ kg /"
        }
        weightTextField.isEnabled = weightSwitch.isOn
        weightUnitSelectButton.isEnabled = weightSwitch.isOn
        //        calculate()
    }

    @IBAction func weightUnitSelectButtonAction(_: Any) {
        presentSelector(dataSource: weightUnit, button: weightUnitSelectButton)
    }

    @IBAction func concentrationDoseTextFieldEditingChanged(_: Any) {
        //        calculate()
    }

    @IBAction func concentrationUnitSelectButtonAction(_: Any) {
        presentSelector(dataSource: concentrationUnit, button: concentrationUnitSelectButton)
    }

    @IBAction func concentrationVolumeTextFieldEditingChanged(_: Any) {
        //        calculate()
    }

    @IBAction func concentrationVolumeUnitSelectButtonAction(_: Any) {
        presentSelector(dataSource: concentrationVolumeUnit, button: concentrationVolumeUnitSelectButton)
    }

    @IBAction func ivRateTimeUnitSelectButtonAction(_: Any) {
        presentSelector(dataSource: ivRateTimeUnit, button: ivRateTimeUnitSelectButton)
    }

    @IBAction func doseTextFieldEditingDidBegin(_: Any) {
        nextBarButton.isEnabled = true
        previousBarButton.isEnabled = false
    }

    @IBAction func weightTextFieldEditingDidBegin(_: Any) {
        nextBarButton.isEnabled = true
        previousBarButton.isEnabled = true
    }

    @IBAction func concentrationDoseTextFieldEditingDidBegin(_: Any) {
        nextBarButton.isEnabled = true
        previousBarButton.isEnabled = true
    }

    @IBAction func concentrationVolumeTextFieldEditingDidBegin(_: Any) {
        nextBarButton.isEnabled = false
        previousBarButton.isEnabled = true
    }

    // MARK: - Properties

    let doseUnit: [String] = ["mcg", "mg", "grams", "Units", "mEq"]
    let doseTimeUnit: [String] = ["min", "hr"]
    let weightUnit: [String] = ["kg", "lbs"]
    let concentrationUnit: [String] = ["mcg", "mg", "grams", "Units", "mEq"]
    let concentrationVolumeUnit: [String] = ["ml", "liters"]
    let ivRateTimeUnit: [String] = ["ml/min", "ml/hr", "ml/day"]
    var selectedDoseUnit = "mg"
    var selectedDoseTimeUnit = "min"
    var selectedWeightUnit = "kg"
    var selectedConcentrationUnit = "mg"
    var selectedConcentrationVolumeUnit = "ml"
    var selectedIvRateTimeUnit = "ml/hr"
    var dose = 0.0
    var infusionTime = 60.0
    var weight = 1.0
    var concentration = 0.0
    var concentrationVolume = 0.0
    var ivRateTime = 0.0
    let keyboardToolbar = UIToolbar()
    let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let previousBarButton = UIBarButtonItem(title: "Previous", style: UIBarButtonItem.Style.plain, target: IVInfusionRateViewController.self, action: #selector(IVInfusionRateViewController.goToPreviousField))
    let nextBarButton = UIBarButtonItem(title: "Next", style: UIBarButtonItem.Style.plain, target: IVInfusionRateViewController.self, action: #selector(IVInfusionRateViewController.goToNextField))
    let doneBarButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: IVInfusionRateViewController.self, action: #selector(IVInfusionRateViewController.doneEditing))

    // MARK: - Actions

    func presentSelector(dataSource: [String], button: UIButton) {
        let selectorAlert = UIAlertController(title: "Select Unit", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        for (index, _) in dataSource.enumerated() {
            let title = dataSource[index]
            selectorAlert.addAction(UIAlertAction(title: title, style: UIAlertAction.Style.default, handler: { _ in self.setButtonSelection(button, title) }))
        }
        selectorAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        present(selectorAlert, animated: true, completion: nil)
    }

    func setButtonSelection(_ button: UIButton, _ title: String) {
        button.setTitleWithOutAnimation(title: title)
        switch button {
        case doseUnitSelectButton:
            selectedDoseUnit = title
            if title == "Units" {
                concentrationUnitSelectButton.setTitleWithOutAnimation(title: title)
                selectedConcentrationUnit = title
                concentrationUnitSelectButton.isEnabled = false
            } else if title == "mEq" {
                concentrationUnitSelectButton.setTitleWithOutAnimation(title: title)
                selectedConcentrationUnit = title
                concentrationUnitSelectButton.isEnabled = false
            } else {
                concentrationUnitSelectButton.isEnabled = true
                selectedDoseUnit = title
            }
        case doseTimeUnitSelectButton:
            selectedDoseTimeUnit = title
        case weightUnitSelectButton:
            selectedWeightUnit = title
        case concentrationUnitSelectButton:
            selectedConcentrationUnit = title
            if title == "Units" {
                doseUnitSelectButton.setTitleWithOutAnimation(title: title)
                selectedDoseUnit = title
                doseUnitSelectButton.isEnabled = false
            } else if title == "mEq" {
                doseUnitSelectButton.setTitleWithOutAnimation(title: title)
                selectedDoseUnit = title
                doseUnitSelectButton.isEnabled = false
            } else {
                doseUnitSelectButton.isEnabled = true
                selectedConcentrationUnit = title
            }
        case concentrationVolumeUnitSelectButton:
            selectedConcentrationVolumeUnit = title
        case ivRateTimeUnitSelectButton:
            selectedIvRateTimeUnit = title
        default:
            break
        }
        //        calculate()
    }

    func calculate() {
        dose = doseTextField.double
        weight = weightTextField.double
        concentration = concentrationDoseTextField.double
        concentrationVolume = concentrationVolumeTextField.double

        switch selectedDoseUnit {
        case "mcg":
            dose = dose / 1000.0
        case "grams":
            dose = dose * 1000.0
        default:
            break
        }

        if weightSwitch.isOn {
            switch selectedWeightUnit {
            case "lbs":
                weight = weight * 0.453597
            default:
                break
            }
        } else {
            weight = 1
        }

        switch selectedConcentrationUnit {
        case "grams":
            concentration = concentration * 1000.0
        case "mcg":
            concentration = concentration / 1000.0
                //        case "Units":
                //            concentration = concentration
                //        case "mg":
                //            concentration = concentration
                //        case "mEq":
                //            concentration = concentration
        default:
            break
        }

        switch selectedConcentrationVolumeUnit {
        case "liters":
            concentrationVolume = concentrationVolume * 1000
        default:
            break
        }

        switch selectedDoseTimeUnit {
        case "min":
            infusionTime = 60
        case "hr":
            infusionTime = 1
        default:
            break
        }
        var ivRate = dose * weight * infusionTime * concentrationVolume / concentration

        if ivRate.isNaN {
            ivRateLabel.text = "IV Infusion Rate: 0"
        } else {
            switch selectedIvRateTimeUnit {
            case "ml/min":
                ivRate = ivRate / 60
            case "ml/hr":
                _ = ivRate
            case "ml/day":
                ivRate = ivRate * 24
            default:
                break
            }
            ivRateLabel.text = "IV Infusion Rate: \(ivRate.rounded(toPlaces: 2))"
        }
    }

    @objc func goToPreviousField(_: Any?) {
        if weightTextField.isFirstResponder {
            weightTextField.resignFirstResponder()
            doseTextField.becomeFirstResponder()
        } else if concentrationDoseTextField.isFirstResponder {
            concentrationDoseTextField.resignFirstResponder()
            if !weightSwitch.isOn {
                doseTextField.becomeFirstResponder()
            } else {
                weightTextField.becomeFirstResponder()
            }
        } else if concentrationVolumeTextField.isFirstResponder {
            concentrationVolumeTextField.resignFirstResponder()
            concentrationDoseTextField.becomeFirstResponder()
        }
    }

    @objc func goToNextField() {
        if doseTextField.isFirstResponder {
            doseTextField.resignFirstResponder()
            if !weightSwitch.isOn {
                concentrationDoseTextField.becomeFirstResponder()
            } else {
                weightTextField.becomeFirstResponder()
            }
        } else if weightTextField.isFirstResponder {
            weightTextField.resignFirstResponder()
            concentrationDoseTextField.becomeFirstResponder()
        } else if concentrationDoseTextField.isFirstResponder {
            concentrationDoseTextField.resignFirstResponder()
            concentrationVolumeTextField.becomeFirstResponder()
        }
    }

    @objc func doneEditing(_: Any?) {
        view.endEditing(true)
    }

    func addBarButtons() {
        keyboardToolbar.sizeToFit()
        keyboardToolbar.items = [previousBarButton, nextBarButton, flexBarButton, doneBarButton]
        weightTextField.inputAccessoryView = keyboardToolbar
        doseTextField.inputAccessoryView = keyboardToolbar
        concentrationDoseTextField.inputAccessoryView = keyboardToolbar
        concentrationVolumeTextField.inputAccessoryView = keyboardToolbar
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addBarButtons()
        doseTextField.delegate = self
        weightTextField.delegate = self
        concentrationDoseTextField.delegate = self
        concentrationVolumeTextField.delegate = self
        doseTextField.becomeFirstResponder()
        doseUnitSelectButton.layer.cornerRadius = 5.0
        doseTimeUnitSelectButton.layer.cornerRadius = 5.0
        weightUnitSelectButton.layer.cornerRadius = 5.0
        concentrationUnitSelectButton.layer.cornerRadius = 5.0
        concentrationVolumeUnitSelectButton.layer.cornerRadius = 5.0
        ivRateTimeUnitSelectButton.layer.cornerRadius = 5.0
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectAllText()
    }

    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        view.endEditing(true)
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
