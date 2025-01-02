import SwiftUI

struct ContactDeveloperButton: View {
    var body: some View {
        Button(action: {
            if let url = URL(string: "https://t.me/bogd1104"),
               UIApplication.shared.canOpenURL(url)
            {
                UIApplication.shared.open(url)
            }
        }) {
            HStack {
                Image(systemName: "envelope.fill")
                Text("Написать разработчику")
            }
            .foregroundColor(.white)
        }
        .listRowBackground(Color.clear)
    }
}
