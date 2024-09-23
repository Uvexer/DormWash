import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
    @Environment(\.presentationMode) var presentation
    var recipients: [String]
    var subject: String
    var messageBody: String

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        @Binding var presentation: PresentationMode

        init(presentation: Binding<PresentationMode>) {
            _presentation = presentation
        }

        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            _ = controller.dismiss(animated: true) {
                self.$presentation.wrappedValue.dismiss()
            }
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation)
    }

    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let vc = MFMailComposeViewController()
        vc.mailComposeDelegate = context.coordinator
        vc.setToRecipients(recipients)
        vc.setSubject(subject)
        vc.setMessageBody(messageBody, isHTML: false)
        return vc
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: UIViewControllerRepresentableContext<MailView>) { }
}

struct SettingsTabView: View {
    @State private var isShowingMailView = false
    @State private var isMailViewAvailable = MFMailComposeViewController.canSendMail()

    var body: some View {
        ZStack {
            // Градиент на всём экране
            LinearGradient(gradient: Gradient(colors: [.blue, .purple]), startPoint: .top, endPoint: .bottom)
                .edgesIgnoringSafeArea(.all)

            // List с прозрачными ячейками
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
                        .foregroundColor(.white) // Цвет текста
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
    }
}


