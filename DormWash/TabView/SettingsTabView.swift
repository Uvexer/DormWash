import SwiftUI
import MessageUI

struct SettingsTabView: View {
    @State private var isShowingMailView = false
    @State private var isMailViewAvailable = MFMailComposeViewController.canSendMail()
    @AppStorage("isDarkMode") private var isDarkMode: Bool = false

    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: isDarkMode ? [.black, .gray] : [.blue, .purple]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)
            
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

                Section(header: Text("Настройки темы").foregroundColor(.white)) {
                    Toggle(isOn: $isDarkMode) {
                        Text(isDarkMode ? "Тёмная тема" : "Светлая тема")
                            .foregroundColor(.white)
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .background(Color.clear)
        }
        .sheet(isPresented: $isShowingMailView) {
            MailView(recipients: ["m2112619@edu.misis.ru"], subject: "Обратная связь", messageBody: "")
        }
        .preferredColorScheme(isDarkMode ? .dark : .light) 
    }
}


