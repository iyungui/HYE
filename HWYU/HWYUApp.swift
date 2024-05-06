//
//  HWYUApp.swift
//  HWYU
//
//  Created by 이융의 on 12/12/23.
//

import SwiftUI
import FirebaseCore
import FirebaseAppCheck

class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
      let providerFactory = AppCheckDebugProviderFactory()
      AppCheck.setAppCheckProviderFactory(providerFactory)
      
    FirebaseApp.configure()
    return true
  }
}

@main
struct HWYUApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var authViewModel = AuthViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationView {
              ContentView()
                    .environmentObject(authViewModel)
            }
        }
    }
}
