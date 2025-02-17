import CoreData
import SwiftUI

struct MachineSelectionView: View {
    @Binding var cards: [Card]
    @State private var selectedCard: Card?
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            MachinesTabView(selectedCard: $selectedCard, cards: $cards)

            Button(action: {
                if let selectedCard {
                    addOrder(
                        id: Int64(selectedCard.id),
                        isAvailable: selectedCard.isAvailable,
                        price: Int64(selectedCard.price),
                        in: viewContext
                    )
                    presentationMode.wrappedValue.dismiss()
                }
            }) {
                Text("Добавить заказ")
                    .foregroundColor(.white)
                    .padding()
                    .background(selectedCard == nil ? Color.gray : Color.blue)
                    .cornerRadius(10)
            }
            .disabled(selectedCard == nil)
            .padding()
        }
    }
}
