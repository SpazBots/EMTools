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
    
    @IBAction func callEagleMedButton(_ sender: Any) {
        if let url = URL(string: "tel://18005255220") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    @IBAction private func doseTextFieldEditingChanged(_ sender: Any) {
        calculate()
    }
    @IBAction func doseUnitSelectButtonAction(_ sender: Any) {
        presentSelector(dataSource: doseUnit, button: doseUnitSelectButton)
    }
    @IBAction func doseTimeUnitSelectButtonAction(_ sender: Any) {
        presentSelector(dataSource: doseTimeUnit, button: doseTimeUnitSelectButton)
    }
    @IBAction func weightTextFieldEditingChanged(_ sender: Any) {
        calculate()
    }
    @IBAction func weightSwitchDidChange(_ sender: Any) {
        switch weightSwitch.isOn {
        case false:
            kgLabel.text = "/"
        default:
            kgLabel.text = "/ kg /"
        }
        weightTextField.isEnabled = weightSwitch.isOn
        weightUnitSelectButton.isEnabled = weightSwitch.isOn
        calculate()
    }
    @IBAction func weightUnitSelectButtonAction(_ sender: Any) {
        presentSelector(dataSource: weightUnit, button: weightUnitSelectButton)
    }
    @IBAction func concentrationDoseTextFieldEditingChanged(_ sender: Any) {
        calculate()
    }
    @IBAction func concentrationUnitSelectButtonAction(_ sender: Any) {
        presentSelector(dataSource: concentrationUnit, button: concentrationUnitSelectButton)
    }
    @IBAction func concentrationVolumeTextFieldEditingChanged(_ sender: Any) {
        calculate()
    }
    @IBAction func concentrationVolumeUnitSelectButtonAction(_ sender: Any) {
        presentSelector(dataSource: concentrationVolumeUnit, button: concentrationVolumeUnitSelectButton)
    }
    @IBAction func ivRateTimeUnitSelectButtonAction(_ sender: Any) {
        presentSelector(dataSource: ivRateTimeUnit, button: ivRateTimeUnitSelectButton)
    }
    @IBAction func doseTextFieldEditingDidBegin(_ sender: Any) {
        nextBarButton.isEnabled = true
        previousBarButton.isEnabled = false
    }
    @IBAction func weightTextFieldEditingDidBegin(_ sender: Any) {
        nextBarButton.isEnabled = true
        previousBarButton.isEnabled = true
    }
    @IBAction func concentrationDoseTextFieldEditingDidBegin(_ sender: Any) {
        nextBarButton.isEnabled = true
        previousBarButton.isEnabled = true
    }
    @IBAction func concentrationVolumeTextFieldEditingDidBegin(_ sender: Any) {
        nextBarButton.isEnabled = false
        previousBarButton.isEnabled = true
    }
    
    // MARK - Constants and Variables
    
    let doseUnit: [String] = ["mcg", "mg", "grams"]
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
    var dose: Double = 0.0
    var doseMg: Double = 0.0
    var infusionTime: Double = 0.0
    var weight: Double = 0.0
    var weightKg: Double = 0.0
    var concentration: Double = 0.0
    var concentrationMg: Double = 0.0
    var concentrationVolume: Double = 0.0
    var concentrationVolumeCc: Double = 0.0
    var ivRateTime: Double = 0.0
    let keyboardToolbar = UIToolbar()
    let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let previousBarButton = UIBarButtonItem(title: "Previous", style: UIBarButtonItemStyle.plain, target: self, action: #selector(IVInfusionRateViewController.goToPreviousField))
    let nextBarButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action: #selector(IVInfusionRateViewController.goToNextField))
    let doneBarButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(IVInfusionRateViewController.doneEditing))
    
    // MARK: - Actions
    
    func presentSelector(dataSource: [String], button: UIButton) {
        let selectorAlert = UIAlertController(title: "Select Unit", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        for (index, _) in dataSource.enumerated() {
            let title = dataSource[index]
            selectorAlert.addAction(UIAlertAction(title: title, style: UIAlertActionStyle.default, handler: { action in self.setButtonSelection(button, title)}))
        }
        selectorAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        self.present(selectorAlert, animated: true, completion: nil)
    }
    func setButtonSelection(_ button: UIButton, _ title: String) {
        button.setTitleWithOutAnimation(title: title)
        switch button {
        case doseUnitSelectButton:
            selectedDoseUnit = title
        case doseTimeUnitSelectButton:
            selectedDoseTimeUnit = title
        case weightUnitSelectButton:
            selectedWeightUnit = title
        case concentrationUnitSelectButton:
            selectedConcentrationUnit = title
        case concentrationVolumeUnitSelectButton:
            selectedConcentrationVolumeUnit = title
        case ivRateTimeUnitSelectButton:
            selectedIvRateTimeUnit = title
        default:
            break
        }
        calculate()
    }
    func calculate() {
        dose = doseTextField.double
        weight = weightTextField.double
        concentration = concentrationDoseTextField.double
        concentrationVolume = concentrationVolumeTextField.double
        calculateDose()
        calculateConcentration()
        convertWeight()
        switch selectedDoseTimeUnit {
        case "min":
            infusionTime = 1.0
        case "hr":
            infusionTime = 60.0
        default:
            break
        }
        if !weightSwitch.isOn {
            let ivRate = doseMg * infusionTime * concentrationVolume / concentrationMg
            var ivRateFinal: Double = 0.0
            if ivRate.isNaN {
                ivRateLabel.text = "IV Infusion Rate: " + "\(0)"
            } else {
                switch selectedIvRateTimeUnit {
                case "ml/min":
                    ivRateFinal = ivRate * 60
                case "ml/hr":
                    ivRateFinal = ivRate
                case "ml/day":
                    ivRateFinal = ivRate / 24
                default:
                    break
                }
                ivRateLabel.text = "IV Infusion Rate: " + "\(ivRateFinal)"
            }
            
        } else {
            let ivRate = doseMg * weightKg * infusionTime * concentrationVolume / concentrationMg
            var ivRateFinal: Double = 0.0
            if ivRate.isNaN {
                ivRateLabel.text = "IV Infusion Rate: " + "\(0)"
            } else {
                switch selectedIvRateTimeUnit {
                case "ml/min":
                    ivRateFinal = ivRate * 60
                case "ml/hr":
                    ivRateFinal = ivRate
                case "ml/day":
                    ivRateFinal = ivRate / 24
                default:
                    break
                }
                ivRateLabel.text = "IV Infusion Rate: " + "\(ivRateFinal)"
            }
        }
    }
    func calculateDose() {
        switch selectedDoseUnit {
        case "mcg":
            doseMg = dose / 1000.0
        case "mg":
            doseMg = dose
        case "gram":
            doseMg = dose * 1000.0
        default:
            break
        }
    }
    func calculateConcentration() {
        switch selectedConcentrationUnit {
        case "Units":
            concentrationMg = concentration
        case "mcg":
            concentrationMg = concentration / 1000.0
        case "mg":
            concentrationMg = concentration
        case "grams":
            concentrationMg = concentration * 1000.0
        case "Units":
            concentrationMg = concentration
        case "mEq":
            concentrationMg = concentration
        default:
            break
        }
        switch selectedConcentrationVolumeUnit {
        case "ml":
            concentrationVolumeCc = concentrationVolume
        default:
            concentrationVolumeCc = concentrationVolume * 1000
        }
    }
    func convertWeight() {
        switch selectedWeightUnit {
        case "lbs":
            weightKg = weight * 0.453592
        default:
            weightKg = weight
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
        self.view.endEditing(true)
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
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectAllText()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
