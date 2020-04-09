//
//  FMACSubUIButton.swift
//  FMACRekognitionChallenge
//
//  Created by Jeremy Malisse on 4/9/20.
//  Copyright © 2020 Jeremy Malisse. All rights reserved.
//

import UIKit

class FMACSubUIButton: FMACUIButton {

	override open var isHighlighted: Bool {
		didSet {
			backgroundColor = isHighlighted ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0.1985498716) : UIColor.clear
			titleColor = isHighlighted ? UIColor.white : UIColor.white
		}
	}
}
