//
//  MAPCPPViewController.swift
//  EMTools
//
//  Created by Joel Payne on 4/17/17.
//  Copyright © 2017 Joel Payne. All rights reserved.
//

import UIKit

class MAPCPPViewController: UIViewController, UITextFieldDelegate {

    // MARK: - Storyboard Outlets

    @IBOutlet var systolicTextField: UITextField!
    @IBOutlet var diastolicTextField: UITextField!
    @IBOutlet var icpTextField: UITextField!
    @IBOutlet var mapTextField: UITextField!
    @IBOutlet var cppLabel: UILabel!

    // MARK: - Storyboard Actions

    @IBAction func callEagleMedButton(_ sender: Any) {
        if let url = URL(string: "tel://18005255220") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    @IBAction func systolicTextFieldEditingDidEnd(_ sender: Any) {
        calculateMAP()
    }

    @IBAction func diastolicTextFieldEditingDidEnd(_ sender: Any) {
        calculateMAP()
    }

    @IBAction func icpTextFieldEditingDidEnd(_ sender: Any) {
        calculateCPP()
    }

    @IBAction func mapTextFieldEditingDidEnd(_ sender: Any) {
        calculateCPP()
    }

    @IBAction func systolicTextFieldEditingDidBegin(_ sender: Any) {
        nextBarButton.isEnabled = true
        previousBarButton.isEnabled = false
    }

    @IBAction func diastolicTextFieldEditingDidBegin(_ sender: Any) {
        nextBarButton.isEnabled = true
        previousBarButton.isEnabled = true
    }

    @IBAction func icpTextFieldEditingDidBegin(_ sender: Any) {
        nextBarButton.isEnabled = true
        previousBarButton.isEnabled = true
    }

    @IBAction func mapTextFieldEditingDidBegin(_ sender: Any) {
        nextBarButton.isEnabled = false
        previousBarButton.isEnabled = true
    }

    // MARK: - Variables and Constants

    var systolic: Int = 0
    var diastolic: Int = 0
    var map: Int = 0
    var icp: Int = 0
    var cpp: Int = 0
    let keyboardToolbar = UIToolbar()
    let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
    let previousBarButton = UIBarButtonItem(title: "Previous", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MAPCPPViewController.goToPreviousField))
    let nextBarButton = UIBarButtonItem(title: "Next", style: UIBarButtonItemStyle.plain, target: self, action: #selector(MAPCPPViewController.goToNextField))
    let doneBarButton = UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.done, target: self, action: #selector(MAPCPPViewController.doneEditing))

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        addBarButtons()
        systolicTextField.delegate = self
        diastolicTextField.delegate = self
        icpTextField.delegate = self
        mapTextField.delegate = self
        systolicTextField.becomeFirstResponder()
    }

    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.selectAllText()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    // MARK: - Actions

    func calculateCPP() {
        icp = icpTextField.integer
        cpp = map - icp
        cppLabel.text = "\(cpp)"
    }

    func calculateMAP() {
        systolic = systolicTextField.integer
        diastolic = diastolicTextField.integer
        map = ((2 * diastolic) + systolic) / 3
        mapTextField.text = "\(map)"
        calculateCPP()
    }

    @objc func goToPreviousField(_: Any?) {
        if diastolicTextField.isFirstResponder {
            diastolicTextField.resignFirstResponder()
            systolicTextField.becomeFirstResponder()
        } else if icpTextField.isFirstResponder {
            icpTextField.resignFirstResponder()
            diastolicTextField.becomeFirstResponder()
        } else if mapTextField.isFirstResponder {
            mapTextField.resignFirstResponder()
            icpTextField.becomeFirstResponder()
        }
    }

    @objc func goToNextField() {
        if systolicTextField.isFirstResponder {
            systolicTextField.resignFirstResponder()
            diastolicTextField.becomeFirstResponder()
        } else if diastolicTextField.isFirstResponder {
            diastolicTextField.resignFirstResponder()
            icpTextField.becomeFirstResponder()
        } else if icpTextField.isFirstResponder {
            icpTextField.resignFirstResponder()
            mapTextField.becomeFirstResponder()
        }
    }

    @objc func doneEditing(_: Any?) {
        self.view.endEditing(true)
    }

    func addBarButtons() {
        keyboardToolbar.sizeToFit()
        keyboardToolbar.items = [previousBarButton, nextBarButton, flexBarButton, doneBarButton]
        diastolicTextField.inputAccessoryView = keyboardToolbar
        systolicTextField.inputAccessoryView = keyboardToolbar
        icpTextField.inputAccessoryView = keyboardToolbar
        mapTextField.inputAccessoryView = keyboardToolbar
    }
}
