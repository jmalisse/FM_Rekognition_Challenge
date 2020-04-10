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

class FMACImageSelectionViewController: FMACViewController, UIImagePickerControllerDelegate, UIGestureRecognizerDelegate {
	
	// Outlet objects for images
	@IBOutlet weak var imageSource: FMACUIImageView!
	@IBOutlet weak var imageTarget: FMACUIImageView!
	
	// Rekognition object
	// Loads configuration from default (globally set in App Delegate)
	var rekognitionClient: AWSRekognition = AWSRekognition.default()
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		// Do any additional setup after loading the view.
		
		// Set up tap gestures using obj-C reference to tappedImage
		// Could be a way to remove the repitition from this code block...
		let imageSourceTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedImageSource(sender:)))
		imageSourceTapRecognizer.delegate = self
		let imageTargetTapRecognizer = UITapGestureRecognizer(target: self, action: #selector(tappedImageTarget(sender:)))
		imageTargetTapRecognizer.delegate = self
		self.imageSource.addGestureRecognizer(imageSourceTapRecognizer)
		self.imageSource.isUserInteractionEnabled = true
		self.imageTarget.addGestureRecognizer(imageTargetTapRecognizer)
		self.imageTarget.isUserInteractionEnabled = true
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
	
	// Selector function - regardless of which image is tapped, they both handle their own imagePicker
	// Buttons are still left for user convenience
	@objc func tappedImageSource(sender: UIImageView) {
		imageSource.presentImagePicker(from: self)
	}
	@objc func tappedImageTarget(sender: UIImageView) {
		imageTarget.presentImagePicker(from: self)
	}
	
	// Submit request to API
	@IBAction func submitCheck(_ sender: UIButton) {
		// Log the timestamp of submission request
		os_log("Compare Faces Request initialized.", log: OSLog.default, type: .info)
		
		// Run comparison check
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
				os_log("Invalid photo selection made by User.", log: OSLog.default, type: .info)
				
				DispatchQueue.main.async {
					let errorAlert = UIAlertController(title: "Invalid Photo(s)", message: "An error has occurred. Please check the following.\n1) Both the Source and Target images are selected.\n2) Both images contain faces.\n3) There is sufficient detail in each image (not too dark, not too bright, etc)\n\nPlease resolve any of those issues with your selection and try again.", preferredStyle: .alert)
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
				let similarity: Float = result?.faceMatches!.first!.similarity as! Float
				
				// Set up Dispatch Queue on main thread for GUI elements
				DispatchQueue.main.async {
					let successAlert = UIAlertController(title: "Match Detected!", message: "Facial similary for these photos determined to be: \(similarity)%", preferredStyle: .alert)
					let closeButton = UIAlertAction(title: "Close", style: .default, handler: nil)
					successAlert.addAction(closeButton)
					self.present(successAlert, animated: true, completion: nil)
				}
				
				// Log the successful match and similarity score along with timestamp
				os_log("Successful match found. Similarity recorded: %f", log: OSLog.default, type: .info, similarity)
			}
			// Photos successfully processed but no face match detected for the given parameters (similarity or actual match)
			else if (result?.unmatchedFaces!.count)! > 0 {

				// Set up Dispatch Queue on main thread for GUI elements
				DispatchQueue.main.async {
					let failureAlert = UIAlertController(title: "Match Not Detected", message: "Facial similarity not detected or not at high enough accuracy.", preferredStyle: .alert)
					let closeButton = UIAlertAction(title: "Close", style: .default, handler: nil)
					failureAlert.addAction(closeButton)
					self.present(failureAlert, animated: true, completion: nil)
				}
				
				// Log the unsuccessful match and the timestamp
				os_log("No match found with given photos.", log: OSLog.default, type: .info)
			}
		}
	}
}
