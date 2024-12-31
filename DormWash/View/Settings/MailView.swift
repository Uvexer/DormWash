import MessageUI
import SwiftUI

struct MailView: UIViewControllerRepresentable {
    var recipients: [String]
    var subject: String
    var messageBody: String

    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let mailComposeVC = MFMailComposeViewController()
        mailComposeVC.setToRecipients(recipients)
        mailComposeVC.setSubject(subject)
        mailComposeVC.setMessageBody(messageBody, isHTML: false)
        mailComposeVC.mailComposeDelegate = context.coordinator
        return mailComposeVC
    }

    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator()
    }

    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            controller.dismiss(animated: true)
        }
    }
}
