//
//  HomeTableViewController.swift
//  EMTools
//
//  Created by Joel Payne on 5/9/17.
//  Copyright © 2017 Joel Payne. All rights reserved.
//

import UIKit

class HomeTableViewController: UITableViewController {
	
	
	@IBAction func callEagleMedButton(_ sender: Any) {
		if let url = URL(string: "tel://18005255220") {
			UIApplication.shared.open(url, options: [:], completionHandler: nil)
		}
	}
	override func viewDidLoad() {
		super.viewDidLoad()
	}
}
