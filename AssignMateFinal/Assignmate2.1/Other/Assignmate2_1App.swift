

import SwiftUI
import FirebaseCore

// AppDelegate for Firebase configuration
class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure() // Configure Firebase
        
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

    // Register app delegate for Firebase setup
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
