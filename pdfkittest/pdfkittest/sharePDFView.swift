import SwiftUI
import PDFKit

struct SharePDFView: UIViewControllerRepresentable {
    let pdfData: Data
    let fileName: String

    func makeUIViewController(context: Context) -> UIActivityViewController {
        let pdfURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        do {
            try pdfData.write(to: pdfURL)
        } catch {
            fatalError("Failed to write PDF data to temporary file: \(error)")
        }

        let activityViewController = UIActivityViewController(activityItems: [pdfURL], applicationActivities: nil)
        activityViewController.completionWithItemsHandler = { _, _, _, _ in
            try? FileManager.default.removeItem(at: pdfURL)
        }

        return activityViewController
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
