import SwiftUI

struct AddOrderButton: View {
    @ObservedObject var viewModel: OrdersViewModel

    var body: some View {
        Button(action: {
            viewModel.showMachineSelection.toggle()
        }) {
            Image(systemName: "plus")
                .foregroundColor(.white)
                .font(.title2)
        }
    }
}
