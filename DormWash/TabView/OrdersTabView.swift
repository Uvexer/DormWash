import SwiftUI

struct OrdersTabView: View {
    var body: some View {
        NavigationView {
            VStack {}
                .navigationBarTitle("Заказы")
                .navigationBarItems(trailing: Button(action: {
                    print("Плюс нажата")
                }) {
                    Image(systemName: "plus")
                })
        }
    }
}

