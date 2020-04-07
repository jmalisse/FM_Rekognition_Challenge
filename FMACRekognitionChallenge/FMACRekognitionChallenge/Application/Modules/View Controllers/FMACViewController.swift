//
//  FMACViewController.swift
//  FMACRekognitionChallenge
//
//  Created by Jeremy Malisse on 4/2/20.
//  Copyright © 2020 Jeremy Malisse. All rights reserved.
//

import UIKit

@IBDesignable class FMACViewController: ViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

		self.view.backgroundColor = UIColor.fmac_green
        // Do any additional setup after loading the view.
    }
    
	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
	}
	
	@IBInspectable var backgroundColor: UIColor = UIColor.clear {
		didSet {
			self.view.backgroundColor = backgroundColor
		}
	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
