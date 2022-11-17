//
//  PushNotificationsManager.swift
//  Messunity
//
//  Created by Shumakov Dmytro on 15.11.2022.
//

import Foundation

/*
 func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any],
    fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
   
     // Messaging.messaging().appDidReceiveMessage(userInfo)
   
     completionHandler(.noData)
 }
 
 func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
     //
     // Messaging.messaging().apnsToken = deviceToken;
     //
     let deviceTokenString = deviceToken.hexString
     print("Device Token: ", deviceTokenString)
 }
 
 func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
     print("i am not available in simulator :( \(error)")
 }
 
 // Push Notifications
//        let center = UNUserNotificationCenter.current()
//        center.requestAuthorization(options:[.badge, .alert, .sound]) { (granted, error) in
//            // If granted comes true you can enabled features based on authorization.
//            guard granted else { return }
//            DispatchQueue.main.async {
//              UIApplication.shared.registerForRemoteNotifications()
//            }
//        }
 
 */

//extension AppDelegate: UNUserNotificationCenterDelegate {
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
//
//        let userInfo = notification.request.content.userInfo
//        Messaging.messaging().appDidReceiveMessage(userInfo)
//
//        // Change this to your preferred presentation option
//        completionHandler([[.alert, .badge,.sound]])
//    }
//
//    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
//
//        let userInfo = response.notification.request.content.userInfo
//        Messaging.messaging().appDidReceiveMessage(userInfo)
//
//        completionHandler()
//    }
//
//
//}
