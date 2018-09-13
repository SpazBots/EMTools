//
//  CalculatorsTableViewController.swift
//  EMTools
//
//  Created by Joel Payne on 11/10/17.
//  Copyright © 2017 Joel Payne. All rights reserved.
//

import UIKit

class CalculatorsTableViewController: UITableViewController {

    // MARK: - Storyboard Actions
    
    @IBAction func callEagleMedButton(_ sender: Any) {
        if let url = URL(string: "tel://18005255220") {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

}
