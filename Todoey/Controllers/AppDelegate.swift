//
//  AppDelegate.swift
//  Todoey
//
//  Created by Josh Kardos on 9/12/18.
//  Copyright © 2018 JoshTaylorKardos. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

	var window: UIWindow?


	//gets called when app is finished loading, happens before viewDidLoad in intial controller
	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
		// Override point for customization after application launch.
		
		
		
		return true
	}

	//gets triggered when something happens to the phone when using the app
	//used to help not lose data
	func applicationWillResignActive(_ application: UIApplication) {
		
	}

	//happens when app disappers from the screen
	func applicationDidEnterBackground(_ application: UIApplication) {
		print("AppDidEnterBackground")
	}

	func applicationWillEnterForeground(_ application: UIApplication) {
		// Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
	}

	func applicationDidBecomeActive(_ application: UIApplication) {
		// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
	}
	
	//when the app is going to terminated
	//can be user triggered or system triggered
	func applicationWillTerminate(_ application: UIApplication) {
		print("ApplicationWillTerminate")
	}


}

