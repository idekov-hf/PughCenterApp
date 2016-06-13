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
            $0.applicationId = "NVPRIp61qbH3LXvJ9pPn"
            $0.server = "https://pughcenterapp.herokuapp.com/parse"
        }
        Parse.initializeWithConfiguration(configuration)
        
        // 1
        if application.applicationState != .Background {
            
            // 2
            let preBackgroundPush = !application.respondsToSelector(Selector("backgroundRefreshStatus"))
            let oldPushHandlerOnly = !self.respondsToSelector(.didReceiveRemoteNotification)
            var pushPayload = false
            if let options = launchOptions {
                pushPayload = options[UIApplicationLaunchOptionsRemoteNotificationKey] != nil
            }
            if (preBackgroundPush || oldPushHandlerOnly || pushPayload) {
                PFAnalytics.trackAppOpenedWithLaunchOptions(launchOptions)
            }
        }
        
        // 3
        let types: UIUserNotificationType = [.Alert, .Badge, .Sound]
        let settings = UIUserNotificationSettings(forTypes: types, categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        // Check if launched from notification
        // 1
        if let notification = launchOptions?[UIApplicationLaunchOptionsRemoteNotificationKey] as? [String: AnyObject] {
            
            // 2
            let aps = notification["aps"] as! [String: AnyObject]
            print(aps)
//            createNewNewsItem(aps)
            // 3
            (window?.rootViewController as? SWRevealViewControllerTest)?.notificationReceived = true
        }
        
        return true
    }
    
    // 1
    func application(application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken
        deviceToken: NSData) {
        let installation = PFInstallation.currentInstallation()
        installation.setDeviceTokenFromData(deviceToken)
        installation.saveInBackground()
    }
    // 2
    func application(application: UIApplication, didFailToRegisterForRemoteNotificationsWithError
        error: NSError) {
        if error.code == 3010 {
            print("Push notifications are not supported in the iOS Simulator.")
        } else {
            print("application:didFailToRegisterForRemoteNotificationsWithError: %@", error)
        }
    }
    // 3
    func application(application: UIApplication, didReceiveRemoteNotification
        userInfo: [NSObject : AnyObject]) {
        PFPush.handlePush(userInfo)
        if case(.Inactive) = application.applicationState {
            PFAnalytics.trackAppOpenedWithRemoteNotificationPayload(userInfo)
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

// 1
private extension Selector {
    // 2
    static let didReceiveRemoteNotification = #selector(
        UIApplicationDelegate.application(_:didReceiveRemoteNotification:fetchCompletionHandler:))
}

