//
//  FMACImageSelectionViewController.swift
//  FMACRekognitionChallenge
//
//  Created by Jeremy Malisse on 4/2/20.
//  Copyright © 2020 Jeremy Malisse. All rights reserved.
//

import UIKit
import AWSRekognition

class FMACImageSelectionViewController: FMACViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
	
	@IBOutlet weak var imageSource: UIImageView!
	@IBOutlet weak var imageTarget: UIImageView!
	
	var selectedImage: UIImageView?
	

    override func viewDidLoad() {
        super.viewDidLoad()
		
		selectedImage = nil

        // Do any additional setup after loading the view.
    }
	
	@IBAction func sourceImageSelection(_ sender: UIButton) {
//		selectedImage? = imageSource
//		PhotoLibraryOpen(sender)
		imageSource.presentImagePicker(from: self)
	}
	
	@IBAction func targetImageSelection(_ sender: UIButton) {
//		selectedImage? = imageTarget
//		PhotoLibraryOpen(sender)
		
		imageTarget.presentImagePicker(from: self)
	}
	
	func PhotoLibraryOpen(_ sender: Any) {
		let pickerController = UIImagePickerController()
		pickerController.delegate = self
		pickerController.sourceType = .savedPhotosAlbum
		present(pickerController, animated: true)
	}
    
	// MARK: - UIImagePickerControllerDelegate
//	private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
//		dismiss(animated: true)
//
//		guard let image = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage else {
//			fatalError("couldn't load image from Photos")
//		}
//
//		selectedImage!.image = image
////		let celebImage:Data = UIImageJPEGRepresentation(image, 0.2)!
////
////		//Demo Line
////		sendImageToRekognition(celebImageData: celebImage)
//	}

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
