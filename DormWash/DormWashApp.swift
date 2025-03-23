import BackgroundTasks
import CoreData
import SwiftUI
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
                    .preferredColorScheme(.dark)
            } else {
                SplashView(isDataLoaded: $isDataLoaded, cards: $cards)
            }
        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, _ in
            print(granted ? "Уведомления разрешены" : "Уведомления запрещены")
        }

        UNUserNotificationCenter.current().delegate = self

        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.example.app.refresh", using: nil) { task in
            self.handleAppRefresh(task: task as! BGAppRefreshTask)
        }

        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        scheduleAppRefresh()
    }

    private func scheduleAppRefresh() {
        let request = BGAppRefreshTaskRequest(identifier: "com.example.app.refresh")
        request.earliestBeginDate = Date(timeIntervalSinceNow: 15 * 60)
        do {
            try BGTaskScheduler.shared.submit(request)
        } catch {
            print("Не удалось зарегистрировать задачу: \(error.localizedDescription)")
        }
    }

    private func handleAppRefresh(task: BGAppRefreshTask) {
        scheduleAppRefresh()

        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()

        task.expirationHandler = {
            task.setTaskCompleted(success: false)
        }

        do {
            let orders = try context.fetch(fetchRequest)
            let currentDate = Date()
            let calendar = Calendar.current

            for order in orders {
                if let creationDate = order.creationDate {
                    var components = DateComponents()
                    components.hour = Int(order.hour)
                    components.minute = Int(order.minute)

                    if let expirationDate = calendar.date(byAdding: components, to: creationDate),
                       expirationDate <= currentDate
                    {
                        context.delete(order)
                    }
                }
            }

            try context.save()
            task.setTaskCompleted(success: true)
        } catch {
            print("Ошибка при проверке истекших заказов: \(error.localizedDescription)")
            task.setTaskCompleted(success: false)
        }
    }

    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void
    ) {
        let userInfo = response.notification.request.content.userInfo

        if let identifier = userInfo["identifier"] as? String {
            removeOrder(with: identifier)
        }

        completionHandler()
    }

    private func removeOrder(with identifier: String) {
        let context = PersistenceController.shared.container.viewContext
        let fetchRequest: NSFetchRequest<Order> = Order.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "identifier == %@", identifier)

        do {
            let fetchedOrders = try context.fetch(fetchRequest)
            if let orderToDelete = fetchedOrders.first {
                context.delete(orderToDelete)
                try context.save()
                print("Удален заказ с идентификатором \(identifier)")
            }
        } catch {
            print("Ошибка при удалении заказа: \(error.localizedDescription)")
        }
    }
}
