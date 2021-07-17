//
//  IBWViewController.swift
//  EMTools
//
//  Created by Joel Payne on 4/17/17.
//  Copyright © 2017 Joel Payne. All rights reserved.
//

import UIKit

class IBWViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {

    // MARK: - StoryBoard Outlets

    @IBOutlet var genderSegmentedControl: UISegmentedControl!
    @IBOutlet var heightPickerView: UIPickerView!
    @IBOutlet var tidalVolumePickerView: UIPickerView!
    @IBOutlet var idealBodyWeightLabel: UILabel!
    @IBOutlet var ventTidalVolumeLabel: UILabel!

    // MARK: - StoryBoard Actions

    @IBAction func callEagleMedButton(_ sender: Any) {
        if let url = URL(string: "tel://18005255220") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }

    @IBAction func genderDidChange(_ sender: Any) {
        calculate()
    }

    // MARK: - Variables and Constants

    let pickerViewHeightFeet = (4...7).map {
        String($0)
    }
    let pickerViewHeightInches = [" 0", " 1", " 2", " 3", " 4", " 5", " 6", " 7", " 8", " 9", "10 ", "11 "]
    let pickerViewTidalVolume = (4...8).map {
        String($0)
    }

    // MARK: - Actions

    func calculate() {
        let gender = genderSegmentedControl.selectedSegmentIndex
        let feet = heightPickerView.selectedRow(inComponent: 0)
        let inch = heightPickerView.selectedRow(inComponent: 1)
        let tidalVolume = tidalVolumePickerView.selectedRow(inComponent: 0) + 4
        let totalInches = ((feet + 4) * 12) + inch
        let adjustedHeight = totalInches - 60
        var weight: Double = 0.0
        var idealBodyWeight: Double = 0.0
        var ventTidalVolume: Int = 0
        switch gender {
        case 0:
            weight = 50.0
        case 1:
            weight = 45.5
        default:
            break
        }
        idealBodyWeight = weight + (Double(adjustedHeight) * 2.3)
        ventTidalVolume = Int((idealBodyWeight * Double(tidalVolume)) + 0.5)
        idealBodyWeightLabel.text = "Ideal Body Weight: " + "\(idealBodyWeight.rounded(toPlaces: 2))" + " kg"
        ventTidalVolumeLabel.text = "Set Tidal Volume to: " + "\(ventTidalVolume)" + " ml"
    }

    // MARK: - View Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        heightPickerView.delegate = self
        tidalVolumePickerView.delegate = self
        heightPickerView.dataSource = self
        tidalVolumePickerView.dataSource = self
        calculate()
    }

    // MARK: - PickerView Configuration

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView == heightPickerView {
            return 2
        } else {
            return 1
        }
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == heightPickerView {
            switch component {
            case 0:
                return pickerViewHeightFeet.count
            case 1:
                return pickerViewHeightInches.count
            default:
                return 0
            }
        } else {
            return pickerViewTidalVolume.count
        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let defaultArray: [String] = ["default"]
        if pickerView == heightPickerView {
            switch component {
            case 0:
                return pickerViewHeightFeet[row]
            case 1:
                return pickerViewHeightInches[row]
            default:
                return defaultArray[row]
            }
        } else {
            return pickerViewTidalVolume[row]
        }
    }

    func pickerView(_ pickerView: UIPickerView, widthForComponent component: Int) -> CGFloat {
        100
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        calculate()
    }
}
