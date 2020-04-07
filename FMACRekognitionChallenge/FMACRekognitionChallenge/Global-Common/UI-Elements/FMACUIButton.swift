//
//  FMACUIButton.swift
//  FMACRekognitionChallenge
//
//  Created by Jeremy Malisse on 4/7/20.
//  Copyright © 2020 Jeremy Malisse. All rights reserved.
//

import UIKit

@IBDesignable class FMACUIButton: UIButton {

	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
		self.setTitleColor(UIColor.fmac_blue, for: .normal)
		titleLabel?.font = UIFont(name: "Helvetica", size: 17)
	}
	
	@IBInspectable var cornerRadius: CGFloat = 0 {
		didSet {
			self.layer.cornerRadius = cornerRadius
		}
	}
	@IBInspectable var borderWidth: CGFloat = 0 {
		didSet {
			self.layer.borderWidth = borderWidth
		}
	}
	@IBInspectable var borderColor: UIColor = UIColor.clear {
		didSet {
			self.layer.borderColor = borderColor.cgColor
		}
	}
	
	@IBInspectable var buttonWidth: CGFloat = 0 {
		didSet {
			widthAnchor.constraint(equalToConstant: buttonWidth).isActive = true
		}
	}
	
	@IBInspectable var buttonHeight: CGFloat = 0 {
		didSet {
			heightAnchor.constraint(equalToConstant: buttonHeight).isActive = true
		}
	}
	
	@IBInspectable var titleColor: UIColor = UIColor.clear {
		didSet {
			self.setTitleColor(titleColor, for: .normal)
		}
	}
	
	@IBInspectable var buttonBackgroundColor: UIColor = UIColor.clear {
		didSet {
			backgroundColor = buttonBackgroundColor
		}
	}
}
