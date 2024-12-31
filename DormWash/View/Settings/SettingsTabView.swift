import MessageUI
import SwiftUI

struct SettingsTabView: View {
    @State private var isShowingMailView = false
    @State private var isMailViewAvailable = MFMailComposeViewController.canSendMail()

    var body: some View {
        ZStack {
            Color.clear
                .animatedGradientBackground()

            VStack {
                Text("Настройки")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 50)

                List {
                    Section {
                        Button(action: {
                            if isMailViewAvailable {
                                isShowingMailView.toggle()
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
                .listStyle(InsetGroupedListStyle())
                .scrollContentBackground(.hidden)
            }
        }
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $isShowingMailView) {
            MailView(recipients: ["m2112619@edu.misis.ru"], subject: "Обратная связь", messageBody: "")
        }
    }
}
