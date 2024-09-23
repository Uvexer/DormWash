import SwiftUI
import UIKit
import CoreData
import UserNotifications

@main
struct DormWashApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
      
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Уведомления разрешены")
            } else {
                print("Уведомления запрещены")
            }
        }
        
        UNUserNotificationCenter.current().delegate = self
        
        UIApplication.shared.setMinimumBackgroundFetchInterval(UIApplication.backgroundFetchIntervalMinimum)
        
        return true
    }
  
    func application(_ application: UIApplication, performFetchWithCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        NetworkManager.fetchData { fetchedCards in
     
            self.saveCardsToUserDefaults(fetchedCards)

        
            completionHandler(.newData)
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let aps = userInfo["aps"] as? [String: AnyObject], aps["content-available"] as? Int == 1 {
            NetworkManager.fetchData { fetchedCards in
                self.saveCardsToUserDefaults(fetchedCards)
                completionHandler(.newData)
            }
        }
    }

    func saveCardsToUserDefaults(_ cards: [Card]) {
        let cardsData = cards.map { ["id": "\($0.id)", "isAvailable": $0.isAvailable ? "true" : "false", "price": "\($0.price)"] }
        UserDefaults.standard.set(cardsData, forKey: "cachedCards")
    }
}
