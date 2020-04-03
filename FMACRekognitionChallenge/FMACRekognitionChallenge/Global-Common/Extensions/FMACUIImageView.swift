//
//  FMACUIImageView.swift
//  FMACRekognitionChallenge
//
//  Created by Jeremy Malisse on 4/2/20.
//  Copyright © 2020 Jeremy Malisse. All rights reserved.
//

import UIKit

extension UIImageView: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	public func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
		guard let selectedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
			// handle error here
			return
		}
		
		image = selectedImage
		
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
