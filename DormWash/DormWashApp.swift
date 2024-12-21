import SwiftUI
import CoreData
import UIKit
import UserNotifications

@main
struct DormWashApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared

    @State private var isDataLoaded = false
    @State private var cards: [Card] = []

    var body: some Scene {
        WindowGroup {
            if isDataLoaded {
                TabBarView(cards: cards, viewContext: persistenceController.container.viewContext)
                    .environment(\.managedObjectContext, persistenceController.container.viewContext)
            } else {
                SplashView(isDataLoaded: $isDataLoaded, cards: $cards)
            }
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
            self.saveCardsToCoreData(fetchedCards)
            completionHandler(.newData)
        }
    }

   
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        if let aps = userInfo["aps"] as? [String: AnyObject], aps["content-available"] as? Int == 1 {
            NetworkManager.fetchData { fetchedCards in
                self.saveCardsToCoreData(fetchedCards)
                completionHandler(.newData)
            }
        }
    }

   
    private func saveCardsToCoreData(_ cards: [Card]) {
        let context = PersistenceController.shared.container.viewContext

       
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "Card")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch {
            print("Ошибка при удалении старых данных: \(error.localizedDescription)")
        }

       
        for card in cards {
            let newCard = Order(context: context)
            newCard.id = Int64(card.id)
            newCard.isAvailable = card.isAvailable
            newCard.price = Int64(card.price)
        }

   
        do {
            try context.save()
        } catch {
            print("Ошибка сохранения в Core Data: \(error.localizedDescription)")
        }
    }
}

