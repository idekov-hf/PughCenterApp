//
//  AppDelegate.swift
//  PughCenterApp
//
//  Created by Iavor Dekov on 2/8/16.
//  Copyright © 2016 Iavor Dekov. All rights reserved.
//

import UIKit
import Parse

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        let configuration = ParseClientConfiguration {
            $0.applicationId = ParseConstants.ApplicationID
            $0.server = ParseConstants.ServerURL
        }
        Parse.initializeWithConfiguration(configuration)
        
        let types: UIUserNotificationType = [.Alert, .Badge, .Sound]
        let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        if (launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? NSDictionary) != nil {
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = mainStoryboard.instantiateViewControllerWithIdentifier("RevealViewController") as! SWRevealViewControllerTest
                viewController.notificationReceived = true
                window?.rootViewController = viewController
                window?.makeKeyWindow()
        }
        
        return true
    }
    
    
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken
        deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    
    // Failed to register for remote notifications
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError
        error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    
    func application(application: UIApplication, didReceiveRemoteNotification userInfo: [NSObject : AnyObject], fetchCompletionHandler completionHandler: (UIBackgroundFetchResult) -> Void) {
        
        if let aps = userInfo["aps"] as? NSDictionary, alertMessage = aps["alert"] as? String {
            
            let alert = UIAlertController(title: "New Notification!", message: alertMessage, preferredStyle: .Alert)
            alert.addAction(UIAlertAction(title: "Close", style: .Cancel, handler: nil))
            alert.addAction(UIAlertAction(title: "View", style: UIAlertActionStyle.Default, handler: {(UIAlertAction) -> Void in
                let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let viewController = mainStoryboard.instantiateViewControllerWithIdentifier("RevealViewController") as! SWRevealViewControllerTest
                viewController.notificationReceived = true
                self.window?.rootViewController = viewController
                self.window?.makeKeyWindow()
                }
                ))
            window?.rootViewController?.presentViewController(alert, animated: true, completion: nil)
            completionHandler(UIBackgroundFetchResult.NewData)
        }
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        let installation = PFInstallation.currentInstallation()
        if installation.badge != 0 {
            installation.badge = 0
            installation.saveEventually()
        }
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

}
