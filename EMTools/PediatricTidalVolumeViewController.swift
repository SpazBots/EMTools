//
//  PediatricTidalVolumeViewController.swift
//  EMTools
//
//  Created by Joel Payne on 5/7/17.
//  Copyright © 2017 Joel Payne. All rights reserved.
//

import UIKit

class PediatricTidalVolumeViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Storyboard Outlets

    @IBOutlet var weightTextField: UITextField!
    @IBOutlet var weightUnitSelectButton: UIButton!
    @IBOutlet var tidalVolumeTextField: UITextField!
    @IBOutlet var tidalVolumeLabel: UILabel!

    // MARK: - Storyboard Actions

    @IBAction func weightTextFieldEditingChanged(_ sender: Any) {
        calculate()
    }

    @IBAction func tidalVolumeTextFieldEditingChanged(_ sender: Any) {
        calculate()
    }

    @IBAction func weightUnitSelectButtonAction(_ sender: Any) {
        presentSelector(dataSource: weightUnit, button: weightUnitSelectButton)
    }

    @IBAction func weightTextFieldEditingDidBegin(_ sender: Any) {
        nextBarButton.isEnabled = true
        previousBarButton.isEnabled = false
    }

    @IBAction func tidalVolumeTextFieldEditingDidBegin(_ sender: Any) {
        nextBarButton.isEnabled = false
        previousBarButton.isEnabled = true
    }

    // MARK - Constants and Variables

    let weightUnit: [String] = ["kg", "lbs"]
    var selectedWeightUnit = "kg"
    var weight: Double = 0.0
    var weightKg: Double = 0.0
    var tidalVolume: Double = 0.0
    let keyboardToolbar = UIToolbar()
    let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let previousBarButton = UIBarButtonItem(title: "Previous", style: UIBarButtonItem.Style.plain, target: PediatricTidalVolumeViewController.self, action: #selector(PediatricTidalVolumeViewController.goToPreviousField))
    let nextBarButton = UIBarButtonItem(title: "Next", style: UIBarButtonItem.Style.plain, target: PediatricTidalVolumeViewController.self, action: #selector(PediatricTidalVolumeViewController.goToNextField))
    let doneBarButton = UIBarButtonItem(title: "Done", style: UIBarButtonItem.Style.done, target: PediatricTidalVolumeViewController.self, action: #selector(PediatricTidalVolumeViewController.doneEditing))

    // MARK: - Actions

    func presentSelector(dataSource: [String], button: UIButton) {
        let selectorAlert = UIAlertController(title: "Select Unit", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        for (index, _) in dataSource.enumerated() {
            let title = dataSource[index]
            selectorAlert.addAction(UIAlertAction(title: title, style: UIAlertAction.Style.default, handler: { action in self.setButtonSelection(button, title) }))
        }
        selectorAlert.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: nil))
        present(selectorAlert, animated: true, completion: nil)
    }

    func setButtonSelection(_ button: UIButton, _ title: String) {
        button.setTitleWithOutAnimation(title: title)
        selectedWeightUnit = title
        calculate()
    }

    func calculate() {
        weight = weightTextField.double
        tidalVolume = tidalVolumeTextField.double
        convertWeight()
        let ventTidalVolume: Int = Int(weightKg * tidalVolume)
        tidalVolumeLabel.text = "Set Tidal Volume to: " + "\(ventTidalVolume)" + " ml"
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
        tidalVolumeTextField.resignFirstResponder()
        weightTextField.becomeFirstResponder()
    }

    @objc func goToNextField() {
        weightTextField.resignFirstResponder()
        tidalVolumeTextField.becomeFirstResponder()
    }

    @objc func doneEditing(_: Any?) {
        view.endEditing(true)
    }

    func addBarButtons() {
        keyboardToolbar.sizeToFit()
        keyboardToolbar.items = [previousBarButton, nextBarButton, flexBarButton, doneBarButton]
        weightTextField.inputAccessoryView = keyboardToolbar
        tidalVolumeTextField.inputAccessoryView = keyboardToolbar
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addBarButtons()
        weightTextField.delegate = self
        tidalVolumeTextField.delegate = self
        weightTextField.becomeFirstResponder()
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
