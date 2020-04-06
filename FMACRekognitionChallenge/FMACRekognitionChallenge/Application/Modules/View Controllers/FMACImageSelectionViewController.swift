//
//  FMACImageSelectionViewController.swift
//  FMACRekognitionChallenge
//
//  Created by Jeremy Malisse on 4/2/20.
//  Copyright © 2020 Jeremy Malisse. All rights reserved.
//

import UIKit
import AWSRekognition
import os.log

class FMACImageSelectionViewController: FMACViewController, UIImagePickerControllerDelegate {
	
	// Outlet objects for images
	@IBOutlet weak var imageSource: UIImageView!
	@IBOutlet weak var imageTarget: UIImageView!
	
	// Rekognition object
	// Loads configuration from default (globally set in App Delegate)
	var rekognitionClient: AWSRekognition = AWSRekognition.default()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
	}
	
	// MARK: IBActions for buttons
	
	// Set source image
	@IBAction func sourceImageSelection(_ sender: UIButton) {
		imageSource.presentImagePicker(from: self)
	}
	
	// Set target image
	@IBAction func targetImageSelection(_ sender: UIButton) {
		imageTarget.presentImagePicker(from: self)
	}
	
	// Submit request to API
	@IBAction func submitCheck(_ sender: UIButton) {
		compare(sourceImage: imageSource.image!, targetImage: imageTarget.image!)
	}
	
	public func compare(sourceImage: UIImage, targetImage: UIImage) {
		// Would prefer nil checking prior to network request/response, but currently handled in the completion closure for API
		
		// Assign Source image as bytes (no encoding required - not CLI)
		let awsImageSource = AWSRekognitionImage()
		awsImageSource!.bytes = sourceImage.jpegData(compressionQuality: 0.2)
		
		// Assign Target image as bytes (no encoding required - not CLI)
		let awsImageTarget = AWSRekognitionImage()
		awsImageTarget!.bytes = targetImage.jpegData(compressionQuality: 0.2)
		
		// Configure API request for CompareFaces
		let request: AWSRekognitionCompareFacesRequest = AWSRekognitionCompareFacesRequest.init()
		
		request.sourceImage = awsImageSource
		request.targetImage = awsImageTarget
		request.qualityFilter = .none
		
		// Submit request to API
		rekognitionClient.compareFaces(request) {
			(result, error) in
			
			// Error will contain information about the failure, but the information comes as String(s) and can't be parsed this way, afaict. Preferably, it would be best to parse the error code and present an alert based on that.
			if error != nil {
				// Error here, present alert on main thread (UI elements always on main thread)
//				os_log(StaticString(error.debugDescription))
				DispatchQueue.main.async {
					let errorAlert = UIAlertController(title: "Invalid Photo(s)", message: "Please select photos of faces and make sure both Source and Target photos are chosen.", preferredStyle: .alert)
					let closeButton = UIAlertAction(title: "Close", style: .default, handler: nil)
					errorAlert.addAction(closeButton)
					self.present(errorAlert, animated: true, completion: nil)
				}
				
				// Return the request/response API function
				return
			}
			
			//	Result will contain two variables for possible profiles
			//	First result is faceMatches which implies a match was found
			//	Second result is unmatchedFaces which implies no match was found
			
			// Face matched here
			if (result?.faceMatches!.count)! > 0 {
				// Convert NSNumber to float value
				let similarity: Float = result?.faceMatches![0].similarity as! Float
				
				// Set up Dispatch Queue on main thread for GUI elements
				DispatchQueue.main.async {
					let successAlert = UIAlertController(title: "Match Detected!", message: "Facial similary for these photos determined to be: \(similarity)%", preferredStyle: .alert)
					let closeButton = UIAlertAction(title: "Close", style: .default, handler: nil)
					successAlert.addAction(closeButton)
					self.present(successAlert, animated: true, completion: nil)
				}
			}
			else if (result?.unmatchedFaces!.count)! > 0 {
				// No match found
				print("no face match detected from this photo")
			}
		}
	}
}



