//
//  ViewController.swift
//  ActionMenuButton-iOS
//
//  Created by Fady Adel on 10/7/16.
//  Copyright © 2016 com.fady All rights reserved.
//

import UIKit

class ViewController: UIViewController {

	@IBOutlet var actionMenuButton: ActionMenuButton!
	override func viewDidLoad() {
		super.viewDidLoad()
		for i in 1...5 {
			let button = MenuButton(withRadius: 25){ () -> (Void) in
				print("Hello")
			}
			button.setTitle("\(i)", for: .normal)
			button.setTitleColor(UIColor.white, for: .normal)
			button.backgroundColor = UIColor(red: 1, green: 0, blue: 0, alpha: 1)
			actionMenuButton.add(menuButton: button)
		}
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	@IBAction func actionMenuButtonPressed(_ sender: AnyObject) {
		actionMenuButton.toggleMenu()
	}

}

