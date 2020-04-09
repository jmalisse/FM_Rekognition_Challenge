//
//  FMACUIImageView.swift
//  FMACRekognitionChallenge
//
//  Created by Jeremy Malisse on 4/8/20.
//  Copyright © 2020 Jeremy Malisse. All rights reserved.
//

import UIKit

@IBDesignable class FMACUIImageView: UIImageView, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	override func prepareForInterfaceBuilder() {
		super.prepareForInterfaceBuilder()
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
	
	@IBInspectable var borderColor: UIColor = UIColor.fmac_blue {
		didSet {
			self.layer.borderColor = borderColor.cgColor
		}
	}
	
	public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		
		guard let editedimage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
			// error handling
			
			// Log failed selection and timestamp
			return
		}

		image = editedimage
		
		// Log successful selection and timestamp, then dismiss picker
		picker.presentingViewController?.dismiss(animated: true, completion: nil)
	}
	
	func presentImagePicker(from viewController: UIViewController) {
		let picker = UIImagePickerController()
		picker.delegate = self
		picker.sourceType = .photoLibrary
		picker.allowsEditing = true
		
		viewController.present(picker, animated: true)
	}
}
