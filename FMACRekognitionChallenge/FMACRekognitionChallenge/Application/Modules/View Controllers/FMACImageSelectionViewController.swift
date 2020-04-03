//
//  FMACImageSelectionViewController.swift
//  FMACRekognitionChallenge
//
//  Created by Jeremy Malisse on 4/2/20.
//  Copyright © 2020 Jeremy Malisse. All rights reserved.
//

import UIKit
import AWSRekognition

import SafariServices

class FMACImageSelectionViewController: FMACViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, SFSafariViewControllerDelegate {
	
	@IBOutlet weak var imageSource: UIImageView!
	@IBOutlet weak var imageTarget: UIImageView!
	
	var infoLinksMap: [Int:String] = [1000:""]
	var rekognitionObject:AWSRekognition?

    override func viewDidLoad() {
        super.viewDidLoad()
		
        // Do any additional setup after loading the view.
    }
	
	@IBAction func sourceImageSelection(_ sender: UIButton) {
		imageSource.presentImagePicker(from: self)
	}
	
	@IBAction func targetImageSelection(_ sender: UIButton) {
		imageTarget.presentImagePicker(from: self)
	}
	
	func PhotoLibraryOpen(_ sender: Any) {
		let pickerController = UIImagePickerController()
		pickerController.delegate = self
		pickerController.sourceType = .savedPhotosAlbum
		present(pickerController, animated: true)
	}
	
	@IBAction func submitCheck(_ sender: UIButton) {
		var celebImage: Data
		if imageSource.image != nil {
			celebImage = imageSource.image!.jpegData(compressionQuality: 0.2)!
			
			sendImageToRekognition(celebImageData: celebImage)
		}
		else {
			print("image not set toast goes here")
		}
	}
	
	//MARK: - AWS Methods
	func sendImageToRekognition(celebImageData: Data){
		
		//Delete older labels or buttons
		DispatchQueue.main.async {
			[weak self] in
			for subView in (self?.imageSource.subviews)! {
				subView.removeFromSuperview()
			}
		}
		
		rekognitionObject = AWSRekognition.default()
		let celebImageAWS = AWSRekognitionImage()
		celebImageAWS?.bytes = celebImageData
		let celebRequest = AWSRekognitionRecognizeCelebritiesRequest()
		celebRequest?.image = celebImageAWS
		
		rekognitionObject?.recognizeCelebrities(celebRequest!){
			(result, error) in
			if error != nil{
				print(error!)
				return
			}
			
			//1. First we check if there are any celebrities in the response
			if ((result!.celebrityFaces?.count)! > 0){
				
				//2. Celebrities were found. Lets iterate through all of them
				for (index, celebFace) in result!.celebrityFaces!.enumerated(){
					
					//Check the confidence value returned by the API for each celebirty identified
					if(celebFace.matchConfidence!.intValue > 50){ //Adjust the confidence value to whatever you are comfortable with
						
						//We are confident this is celebrity. Lets point them out in the image using the main thread
						DispatchQueue.main.async {
							[weak self] in
							
							//Create an instance of Celebrity. This class is availabe with the starter application you downloaded
							let celebrityInImage = Celebrity()
							
							celebrityInImage.scene = (self?.imageSource)!
							
							//Get the coordinates for where this celebrity face is in the image and pass them to the Celebrity instance
							celebrityInImage.boundingBox = ["height":celebFace.face?.boundingBox?.height, "left":celebFace.face?.boundingBox?.left, "top":celebFace.face?.boundingBox?.top, "width":celebFace.face?.boundingBox?.width] as! [String : CGFloat]
							
							//Get the celebrity name and pass it along
							celebrityInImage.name = celebFace.name!
							//Get the first url returned by the API for this celebrity. This is going to be an IMDb profile link
							if (celebFace.urls!.count > 0){
								celebrityInImage.infoLink = celebFace.urls![0]
							}
								//If there are no links direct them to IMDB search page
							else{
								celebrityInImage.infoLink = "https://www.imdb.com/search/name-text?bio="+celebrityInImage.name
							}
							//Update the celebrity links map that we will use next to create buttons
							self?.infoLinksMap[index] = "https://"+celebFace.urls![0]
							
							//Create a button that will take users to the IMDb link when tapped
							let infoButton:UIButton = celebrityInImage.createInfoButton()
							infoButton.tag = index
							infoButton.addTarget(self, action: #selector(self?.handleTap), for: UIControl.Event.touchUpInside)
							self?.imageSource.addSubview(infoButton)
						}
					}
					
				}
			}
				//If there were no celebrities in the image, lets check if there were any faces (who, granted, could one day become celebrities)
			else if ((result!.unrecognizedFaces?.count)! > 0){
				//Faces are present. Point them out in the Image (left as an exercise for the reader)
				print("faces recognized but none identified")
				/**/
			}
			else{
				//No faces were found (presumably no people were found either)
				print("No faces in this pic")
			}
		}
		
	}
	
	@objc func handleTap(sender:UIButton){
		print("tap recognized")
		let celebURL = URL(string: self.infoLinksMap[sender.tag]!)
		let safariController = SFSafariViewController(url: celebURL!)
		safariController.delegate = self
		self.present(safariController, animated:true)
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
