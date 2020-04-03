//
//  AppDelegate.swift
//  FMACRekognitionChallenge
//
//  Created by Jeremy Malisse on 4/1/20.
//  Copyright © 2020 Jeremy Malisse. All rights reserved.
//

import UIKit
import AWSCore

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		// Initialize Identity Provider
		let credentialsProvider = AWSCognitoCredentialsProvider(
			regionType: .USWest2,
			identityPoolId: "us-west-2:4d23b683-95cc-4cbd-9f35-583e33e72e5e")
		let configuration = AWSServiceConfiguration(
			region: .USWest2,
			credentialsProvider: credentialsProvider)
		AWSServiceManager.default().defaultServiceConfiguration = configuration
		
		return true
	}

	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
		// Called when a new scene session is being created.
		// Use this method to select a configuration to create the new scene with.
		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}


}

