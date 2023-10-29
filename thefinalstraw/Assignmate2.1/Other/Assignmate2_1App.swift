//
//  Assignmate2_1App.swift
//  Assignmate2.1
//
//  Created by Jesse Chhina on 10/16/23.
//

import SwiftUI
import FirebaseCore
import FirebaseMessaging


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct AssignMateApp: App {
  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  @StateObject var flashcardStore = FlashcardStore()

    

  var body: some Scene {
    WindowGroup {
      NavigationView {
        MainView()
              .environmentObject(flashcardStore)
      }
      .tint(Color.purple)
    }
  }
}

