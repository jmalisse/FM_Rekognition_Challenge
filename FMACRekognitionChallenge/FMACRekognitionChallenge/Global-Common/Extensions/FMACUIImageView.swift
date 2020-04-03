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
		
		guard let editedimage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
			// error handling
			return
		}
		image = editedimage
		
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
