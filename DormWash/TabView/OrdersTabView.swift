import SwiftUI
import CoreData

struct OrdersTabView: View {
    @Binding var cards: [Card]
    @State private var showMachineSelection = false
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: Order.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Order.id, ascending: true)]
    ) private var orders: FetchedResults<Order>

    var body: some View {
        NavigationView {
            VStack {
                List {
                    ForEach(orders) { order in
                        Text("Заказ на Машинку \(order.id)")
                            .swipeActions(edge: .trailing) {
                                Button(role: .destructive) {
                                    deleteOrder(order: order)
                                } label: {
                                    Text("Удалить")
                                }
                            }
                    }
                }
            }
            .navigationBarTitle("Заказы")
            .navigationBarItems(trailing: Button(action: {
                showMachineSelection.toggle()
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showMachineSelection) {
                MachineSelectionView(cards: $cards)
            

            }
            .animatedGradientBackground()
        }
    }
    

    func addOrder(id: String, isAvailable: Bool, price: Int64, in viewContext: NSManagedObjectContext) {
        guard let idValue = Int64(id) else {
            print("Invalid id value")
            return
        }

        let newOrder = Order(context: viewContext)
        newOrder.id = idValue
        newOrder.isAvailable = isAvailable
        newOrder.price = price

        do {
            try viewContext.save()
            print("Order saved successfully")
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }


    private func deleteOrder(order: Order) {
        viewContext.delete(order)
        
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}
