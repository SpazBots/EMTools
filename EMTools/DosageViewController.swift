//
//  DosageViewController.swift
//  EMTools
//
//  Created by Joel Payne on 5/7/17.
//  Copyright © 2017 Joel Payne. All rights reserved.
//

import UIKit

class DosageViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Storyboard Outlets

    @IBOutlet var ivInfusionRateTextField: UITextField!
    @IBOutlet var ivRateTimeUnitSelectButton: UIButton!
    @IBOutlet var weightSwitch: UISwitch!
    @IBOutlet var weightTextField: UITextField!
    @IBOutlet var weightUnitSelectButton: UIButton!
    @IBOutlet var concentrationDoseTextField: UITextField!
    @IBOutlet var concentrationUnitSelectButton: UIButton!
    @IBOutlet var concentrationVolumeTextField: UITextField!
    @IBOutlet var concentrationVolumeUnitSelectButton: UIButton!
    @IBOutlet var dosageLabel: UILabel!
    @IBOutlet var doseUnitSelectButton: UIButton!
    @IBOutlet var kgLabel: UILabel!
    @IBOutlet var doseTimeUnitSelectButton: UIButton!

    // MARK: - Storyboard Actions

    @IBAction func callEagleMedButton(_ sender: Any) {
        if let url = URL(string: "tel://18005255220") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    @IBAction private func ivInfusionRateEditingChanged(_ sender: Any) {
        //        calculate()
    }

    @IBAction func doseUnitSelectButtonAction(_ sender: Any) {
        presentSelector(dataSource: doseUnit, button: doseUnitSelectButton)
    }

    @IBAction func doseTimeUnitSelectButtonAction(_ sender: Any) {
        presentSelector(dataSource: doseTimeUnit, button: doseTimeUnitSelectButton)
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
        //        calculate()
    }

    @IBAction func weightTextFieldEditingChanged(_ sender: Any) {
        //        calculate()
    }

    @IBAction func weightUnitSelectButtonAction(_ sender: Any) {
        presentSelector(dataSource: weightUnit, button: weightUnitSelectButton)
    }

    @IBAction func concentrationDoseTextFieldEditingChanged(_ sender: Any) {
        //        calculate()
    }

    @IBAction func concentrationUnitSelectButtonAction(_ sender: Any) {
        presentSelector(dataSource: concentrationUnit, button: concentrationUnitSelectButton)
    }

    @IBAction func concentrationVolumeTextFieldEditingChanged(_ sender: Any) {
        //        calculate()
    }

    @IBAction func concentrationVolumeUnitSelectButtonAction(_ sender: Any) {
        presentSelector(dataSource: concentrationVolumeUnit, button: concentrationVolumeUnitSelectButton)
    }

    @IBAction func ivRateTimeUnitSelectButtonAction(_ sender: Any) {
        presentSelector(dataSource: ivRateTimeUnit, button: ivRateTimeUnitSelectButton)
    }

    @IBAction func ivInfusionRateEditingDidBegin(_ sender: Any) {
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
    var ivRate: Double = 0.0
    var dose: Double = 0.0
    var finalDose: Double = 0.0
    var finalDoseTime: Double = 0.0
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
    let previousBarButton = UIBarButtonItem(title: "Previous", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DosageViewController.goToPreviousField))
    let nextBarButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action: #selector(DosageViewController.goToNextField))
    let doneBarButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(DosageViewController.doneEditing))

    // MARK: - Actions
    @IBAction func calculateButtonAction(_ sender: Any) {
        calculate()
    }

    fileprivate func resetValues() {
        ivInfusionRateTextField.text = ""
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
        dosageLabel.text = "Dosage: 0"
        ivRate = 0.0
        dose = 0.0
        finalDose = 0.0
        finalDoseTime = 0.0
        infusionTime = 0.0
        weight = 0.0
        weightKg = 0.0
        concentration = 0.0
        concentrationMg = 0.0
        concentrationVolume = 0.0
        concentrationVolumeCc = 0.0
        ivRateTime = 0.0
        concentrationUnitSelectButton.isEnabled = true
        doseUnitSelectButton.isEnabled = true
    }

    @IBAction func clearButtonAction(_ sender: Any) {
        resetValues()
    }

    func presentSelector(dataSource: [String], button: UIButton) {
        let selectorAlert = UIAlertController(title: "Select Unit", message: nil, preferredStyle: UIAlertControllerStyle.actionSheet)
        for (index, _) in dataSource.enumerated() {
            let title = dataSource[index]
            selectorAlert.addAction(UIAlertAction(title: title, style: UIAlertActionStyle.default, handler: { action in self.setButtonSelection(button, title) }))
        }
        selectorAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
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
        weight = weightTextField.double
        concentration = concentrationDoseTextField.double
        concentrationVolume = concentrationVolumeTextField.double
        calculateConcentration()
        convertWeight()
        calculateInfusionTime()
        let ivRate = ivInfusionRateTextField.double
        dose = ivRate * ((concentrationMg / concentrationVolumeCc) / (weightKg * infusionTime))
        calculateDoseUnit()
        calculateDoseTime()
        if !(finalDose * finalDoseTime).isNaN {
            dosageLabel.text = "Dosage: " + "\((finalDose * finalDoseTime).rounded(toPlaces: 2))"
        }
        printValues()
    }

    func calculateDoseUnit() {
        switch selectedDoseUnit {
        case "mcg":
            finalDose = dose * 1000
        case "mg":
            finalDose = dose
        case "gram":
            finalDose = dose / 1000
        default:
            break
        }
    }

    func calculateDoseTime() {
        switch selectedDoseTimeUnit {
        case "min":
            finalDoseTime = 1.0
        case "hr":
            finalDoseTime = 60.0
        default:
            break
        }
    }

    func calculateInfusionTime() {
        switch selectedIvRateTimeUnit {
        case "ml/min":
            infusionTime = 1.0
        case "ml/hr":
            infusionTime = 60.0
        case "ml/day":
            infusionTime = 60.0 * 24.0
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
            ivInfusionRateTextField.becomeFirstResponder()
        } else if concentrationDoseTextField.isFirstResponder {
            concentrationDoseTextField.resignFirstResponder()
            if weightSwitch.isOn {
                weightTextField.becomeFirstResponder()
            } else {
                ivInfusionRateTextField.becomeFirstResponder()
            }
        } else if concentrationVolumeTextField.isFirstResponder {
            concentrationVolumeTextField.resignFirstResponder()
            concentrationDoseTextField.becomeFirstResponder()
        }
    }

    @objc func goToNextField() {
        if ivInfusionRateTextField.isFirstResponder {
            ivInfusionRateTextField.resignFirstResponder()
            if weightSwitch.isOn {
                weightTextField.becomeFirstResponder()
            } else {
                concentrationDoseTextField.becomeFirstResponder()
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
        ivInfusionRateTextField.inputAccessoryView = keyboardToolbar
        concentrationDoseTextField.inputAccessoryView = keyboardToolbar
        concentrationVolumeTextField.inputAccessoryView = keyboardToolbar
    }

    func printValues() {
        print("ivInfusionRateTextField.double: " + "\(ivInfusionRateTextField.double)")
        print("weightKg: " + "\(weightKg)")
        print("concentrationMg: " + "\(concentrationMg)")
        print("concentrationVolumeCc: " + "\(concentrationVolumeCc)")
        print("(concentrationMg / concentrationVolumeCc): " + "\((concentrationMg / concentrationVolumeCc))")
        print("(weightKg * infusionTime): " + "\((weightKg * infusionTime))")
        print("((concentrationMg / concentrationVolumeCc) / (weightKg * infusionTime)): " + "\(((concentrationMg / concentrationVolumeCc) / (weightKg * infusionTime)))")
        print("ivInfusionRateTextField.double * ((concentrationMg / concentrationVolumeCc) / (weightKg * infusionTime)): " + "\(ivInfusionRateTextField.double * ((concentrationMg / concentrationVolumeCc) / (weightKg * infusionTime)))")
        print("dose: " + "\(dose)")
        print("finalDose: " + "\(finalDose)")
        print("finalDoseTime: " + "\(finalDoseTime)")
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addBarButtons()
        ivInfusionRateTextField.delegate = self
        weightTextField.delegate = self
        concentrationDoseTextField.delegate = self
        concentrationVolumeTextField.delegate = self
        ivInfusionRateTextField.becomeFirstResponder()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectAllText()
    }

    func buttonPressed(_ button: UIButton, sender: Any) {
        print("success")
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
}
