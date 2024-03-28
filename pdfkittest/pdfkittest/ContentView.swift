import SwiftUI
import PDFKit

struct PDFExampleView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var pdfDocument: PDFDocument?
    @State private var isShowingShareSheet: Bool = false

    var body: some View {
        VStack {
            Form {
                Section(header: Text("Personal Information")) {
                    TextField("Name", text: $name)
                    TextField("Email", text: $email)
                    TextField("Phone Number", text: $phoneNumber)
                }
            }
            Button("Next") {
                generatePDF()
            }
            if let pdfDocument = pdfDocument {
                PDFKitView(pdfData: pdfDocument)
                    .frame(width: 300, height: 300)
                Button("Share") {
                    isShowingShareSheet = true
                }
                .sheet(isPresented: $isShowingShareSheet, content: {
                    SharePDFView(pdfData: pdfDocument.dataRepresentation() ?? Data(), fileName: "GeneratedPDF.pdf")
                })
            }
        }
    }

    @MainActor
    private func generatePDF() {
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: CGRect(x: 0, y: 0, width: 595, height: 842))
        let data = pdfRenderer.pdfData { context in
            context.beginPage()

            alignText(value: "Name: \(name)", x: 0, y: 30, width: 595, height: 50, alignment: .left, textFont: UIFont.systemFont(ofSize: 20, weight: .regular))
            alignText(value: "Email: \(email)", x: 0, y: 80, width: 595, height: 50, alignment: .left, textFont: UIFont.systemFont(ofSize: 20, weight: .regular))
            alignText(value: "Phone Number: \(phoneNumber)", x: 0, y: 130, width: 595, height: 50, alignment: .left, textFont: UIFont.systemFont(ofSize: 20, weight: .regular))
        }

        if let pdfDocument = PDFDocument(data: data) {
            self.pdfDocument = pdfDocument
        }
    }

    private func alignText(value: String, x: Int, y: Int, width: Int, height: Int, alignment: NSTextAlignment, textFont: UIFont) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = alignment

        let attributes = [
            NSAttributedString.Key.font: textFont,
            NSAttributedString.Key.paragraphStyle: paragraphStyle
        ]

        let textRect = CGRect(x: x, y: y, width: width, height: height)
        value.draw(in: textRect, withAttributes: attributes)
    }
}
