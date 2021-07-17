//
//  CPOTViewController.swift
//  EMTools
//
//  Created by Joel Payne on 4/17/17.
//  Copyright © 2017 Joel Payne. All rights reserved.
//

import UIKit

class CPOTViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    // MARK: - StoryBoard Outlets

    @IBOutlet var intubatedSegementedControl: UISegmentedControl!
    @IBOutlet var CpotLabel: UILabel!
    @IBOutlet var ventilatorCompliancePickerView: UIPickerView!
    @IBOutlet var vocalizationPickerView: UIPickerView!
    @IBOutlet var vocalizationLabel: UILabel!
    @IBOutlet var facialExpressionPickerView: UIPickerView!
    @IBOutlet var facialExpressionLabel: UILabel!
    @IBOutlet var bodyMovementsPickerView: UIPickerView!
    @IBOutlet var bodyMovementsLabel: UILabel!
    @IBOutlet var muscleTensionPickerView: UIPickerView!
    @IBOutlet var muscleTensionLabel: UILabel!

    // MARK: StoryBoard Actions

    @IBAction func callEagleMedButton(_ sender: Any) {
        if let url = URL(string: "tel://18005255220") {
            UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
        }
    }

    @IBAction func intubatedSegementedControlChanged(_ sender: Any) {
        if intubatedSegementedControl.selectedSegmentIndex == 0 {
            ventilatorCompliancePickerView.isHidden = true
            vocalizationPickerView.isHidden = false
            vocalizationLabel.text = "Vocalization: 0"
            ventilatorCompliancePickerView.selectRow(0, inComponent: 0, animated: false)
        } else {
            ventilatorCompliancePickerView.isHidden = false
            vocalizationPickerView.isHidden = true
            vocalizationLabel.text = "Ventilator Compliance: 0"
            vocalizationPickerView.selectRow(0, inComponent: 0, animated: false)
        }
        calculateCPOT()
    }

    // MARK: - Constants and Vairables

    let ventilatorComplianceArray: [String] = ["Tolerating Ventilator or Movement +0", "Coughing but Tolerating +1", "Fighting Ventilator +2"]
    let vocalizationArray: [String] = ["Normal Talking +0", "Sighing, Moaning +1", "Crying Out, Sobbing +2"]
    let facialExpressionArray: [String] = ["Relaxed +0", "Tense +1", "Grimacing +2"]
    let bodyMovementsArray: [String] = ["Absence of Movements +0", "Protection +1", "Restlessness +2"]
    let muscleTensionArray: [String] = ["Relaxed +0", "Tense, Rigid +1", "Very Tense or Rigid +2"]

    // MARK: - Actions

    func calculateCPOT() {
        switch intubatedSegementedControl.selectedSegmentIndex {
        case 0:
            let vocalizationScore = vocalizationPickerView.selectedRow(inComponent: 0)
            let facialExpressionScore = facialExpressionPickerView.selectedRow(inComponent: 0)
            let bodyMovementsScore = bodyMovementsPickerView.selectedRow(inComponent: 0)
            let muscleTensionScore = muscleTensionPickerView.selectedRow(inComponent: 0)
            vocalizationLabel.text = "Vocalization: " + "\(vocalizationScore)"
            facialExpressionLabel.text = "Facial Expression: " + "\(facialExpressionScore)"
            bodyMovementsLabel.text = "Body Movements: " + "\(bodyMovementsScore)"
            muscleTensionLabel.text = "Muscle Tension: " + "\(muscleTensionScore)"
            CpotLabel.text = "\(vocalizationScore + facialExpressionScore + bodyMovementsScore + muscleTensionScore)"
        case 1:
            let ventilatorComplianceScore = ventilatorCompliancePickerView.selectedRow(inComponent: 0)
            let facialExpressionScore = facialExpressionPickerView.selectedRow(inComponent: 0)
            let bodyMovementsScore = bodyMovementsPickerView.selectedRow(inComponent: 0)
            let muscleTensionScore = muscleTensionPickerView.selectedRow(inComponent: 0)
            vocalizationLabel.text = "Ventilator Compliance: " + "\(ventilatorComplianceScore)"
            facialExpressionLabel.text = "Facial Expression: " + "\(facialExpressionScore)"
            bodyMovementsLabel.text = "Body Movements: " + "\(bodyMovementsScore)"
            muscleTensionLabel.text = "Muscle Tension: " + "\(muscleTensionScore)"
            CpotLabel.text = "\(ventilatorComplianceScore + facialExpressionScore + bodyMovementsScore + muscleTensionScore)"
        default:
            break
        }
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        ventilatorCompliancePickerView.isHidden = true
        ventilatorCompliancePickerView.delegate = self
        vocalizationPickerView.delegate = self
        facialExpressionPickerView.delegate = self
        bodyMovementsPickerView.delegate = self
        muscleTensionPickerView.delegate = self
        calculateCPOT()
    }

    // MARK: - UIPickerView Configuration

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == ventilatorCompliancePickerView {
            return ventilatorComplianceArray.count
        } else if pickerView == vocalizationPickerView {
            return vocalizationArray.count
        } else if pickerView == facialExpressionPickerView {
            return facialExpressionArray.count
        } else if pickerView == bodyMovementsPickerView {
            return bodyMovementsArray.count
        } else {
            return muscleTensionArray.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == ventilatorCompliancePickerView {
            return ventilatorComplianceArray[row]
        } else if pickerView == vocalizationPickerView {
            return vocalizationArray[row]
        } else if pickerView == facialExpressionPickerView {
            return facialExpressionArray[row]
        } else if pickerView == bodyMovementsPickerView {
            return bodyMovementsArray[row]
        } else {
            return muscleTensionArray[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        calculateCPOT()
    }
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
