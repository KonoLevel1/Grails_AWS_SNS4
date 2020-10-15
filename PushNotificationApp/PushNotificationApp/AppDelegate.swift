//
//  AppDelegate.swift
//  PushNotificationApp
//
//  Created by 小山順一 on 2020/10/15.
//

import UIKit
import UserNotifications
import AWSSNS
import AWSCognito
import AWSCore
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        // プッシュ通知利用のリクエスト送信
            UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
                guard granted else { return }

                DispatchQueue.main.async {
                    // プッシュ通知利用登録
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
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

extension AppDelegate {

    // プッシュ通知利用登録が成功した場合
    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%.2hhx", $0) }.joined()
        print("Device token: \(token)")
        
        // Cognito匿名認証
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.APNortheast1,
           identityPoolId:"CognitoのプールIDを設定してください")
        let configuration = AWSServiceConfiguration(region:.APNortheast1, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    
        // SNS プラットフォームアプリケーションにデバイストークンを登録する処理
        let sns = AWSSNS.default()
        let endpointRequest: AWSSNSCreatePlatformEndpointInput = AWSSNSCreatePlatformEndpointInput()
        endpointRequest.token = token
        endpointRequest.customUserData = "添付したい文字列を任意で設定してください"
        endpointRequest.platformApplicationArn = "SNSのプラットフォームアプリケーションARNを設定してください"

        sns.createPlatformEndpoint(endpointRequest).continueWith{(task)-> AnyObject? in
            if task.error != nil {
                print("ERRORが発生： \(String(describing: task.error))")
            }else{
            // SNS トピックにエンドポイントを登録する処理
            let createEndpointResponse = task.result! as AWSSNSCreateEndpointResponse
            let subscribeRequest: AWSSNSSubscribeInput = AWSSNSSubscribeInput()
            subscribeRequest.topicArn = "SNSのトピックARNを設定してください"
            subscribeRequest.endpoint = createEndpointResponse.endpointArn
            subscribeRequest.protocols = "application"
            sns.subscribe(subscribeRequest)
            }
            return nil
        }
    }
    
    // プッシュ通知利用登録が失敗した場合
    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register to APNs: \(error)")
    }
}
