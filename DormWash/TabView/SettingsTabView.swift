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
            Color.clear
            
            Button(action: {
                if isMailViewAvailable {
                    isShowingMailView.toggle()
                }
            }) {
                Text("Написать разработчику")
                    .font(.title2)
                    .padding()
                    .background(Color.white.opacity(0.8))
                    .foregroundColor(.blue)
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
        }
        .animatedGradientBackground()
        .edgesIgnoringSafeArea(.all)
        .sheet(isPresented: $isShowingMailView) {
            MailView(recipients: ["m2112619@edu.misis.ru"], subject: "Обратная связь", messageBody: "")
        }
    }
}

