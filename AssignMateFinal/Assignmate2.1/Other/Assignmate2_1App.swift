//
//  Assignmate2_1App.swift
//  Assignmate2.1
//
//  Created by Jesse Chhina on 10/16/23.
//

import SwiftUI
import FirebaseCore


class AppDelegate: NSObject, UIApplicationDelegate {
  func application(_ application: UIApplication,
                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
    FirebaseApp.configure()

    return true
  }
}

@main
struct AssignMateApp: App {
    
    @AppStorage("apiKey") var apiKey: String = ""
    @State var isShowingAPIConfigModal: Bool = true

    let idProvider: () -> String
    let dateProvider: () -> Date

    
    init() {
        self.idProvider = {
            UUID().uuidString
        }
        self.dateProvider = Date.init
    }

  // register app delegate for Firebase setup
  @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
  @StateObject var flashcardStore = FlashcardStore()

    

  var body: some Scene {
    WindowGroup {
      NavigationView {
        MainView()
              .environmentObject(flashcardStore)
              .background(Color("BackGroundColor").ignoresSafeArea())
      }
      .tint(Color.purple)
    }
  }
}

