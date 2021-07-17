//
//  Extensions.swift
//  EMTools
//
//  Created by Joel Payne on 4/20/17.
//  Copyright © 2017 Joel Payne. All rights reserved.
//

import UIKit

private var maxTextLength = [UITextField: Int]()

extension UITextField {
    @IBInspectable var maxLength: Int {
        get {
            guard let length = maxTextLength[self] else {
                return Int.max
            }
            return length
        }
        set {
            maxTextLength[self] = newValue
            addTarget(self, action: #selector(limitLength), for: UIControl.Event.editingChanged)
        }
    }

    @objc func limitLength(_ textField: UITextField) {
        guard let newText = textField.text, newText.count > maxLength else {
            return
        }
        let selection = selectedTextRange
        let maxIndex = newText.index(newText.startIndex, offsetBy: maxLength)
        text = String(newText[..<maxIndex])
        selectedTextRange = selection
    }
}

extension UITextField {
    var integer: Int {
        Int(text ?? "") ?? 0
    }
}

extension UITextField {
    var double: Double {
        Double(text ?? "") ?? 0.0
    }
}

extension UITextField {
    func selectAllText() {
        selectedTextRange = textRange(from: beginningOfDocument, to: endOfDocument)
    }
}

extension UIButton {
    func setTitleWithOutAnimation(title: String?) {
        UIView.setAnimationsEnabled(false)
        self.setTitle(title, for: UIControl.State.normal)
        UIView.setAnimationsEnabled(true)
    }
}

extension Double {
    func roundToOne() -> String {
        let outputString = "\(String(format: "%.1f", self))"
        return outputString
    }
}

extension Double {
    /// Rounds the double to decimal places value
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}
