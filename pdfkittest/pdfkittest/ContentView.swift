import SwiftUI
import PDFKit

struct PDFExampleView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var pdfDocument: PDFDocument?
    @State private var isShowingShareSheet: Bool = false
    @State private var errorMessage: String?
    
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
                let pdfData = pdfDocument.dataRepresentation() ?? Data()
                let pdf = PDFDocument(data: pdfData)
                PDFKitView(pdfData: pdf ?? PDFDocument())
                    .frame(width: 300, height: 300)
                Button("Share") {
                    isShowingShareSheet = true
                }
                .sheet(isPresented: $isShowingShareSheet, content: {
                    SharePDFView(pdfData: pdfData, fileName: "GeneratedPDF.pdf")
                })
            }
            
            
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
            }
        }
    }
    
    @MainActor
    private func generatePDF() {
        let templateURL = URL(string: "https://www.orlando.gov/files/sharedassets/public/v/1/departments/edv/permitting-services-division/bld/revision-request-1.2020.pdf")!
        guard let template = PDFDocument(url: templateURL),
              let page = template.page(at: 0) else {
            errorMessage = "Failed to load PDF template."
            return
        }
        
        let pdfRenderer = UIGraphicsPDFRenderer(bounds: page.bounds(for: .mediaBox))
        let data = pdfRenderer.pdfData { context in
            context.beginPage()
            
            let cgContext = context.cgContext
            cgContext.translateBy(x: 0, y: page.bounds(for: .mediaBox).height) // Move the origin to the bottom-left corner
            cgContext.scaleBy(x: 1.0, y: -1.0) // Flip the context
            
            cgContext.drawPDFPage(page.pageRef!) // Use pageRef to get CGPDFPage
            
            // Draw the text using a separate context
            if let textContext = UIGraphicsGetCurrentContext() {
                textContext.saveGState() // Save the current context state
                textContext.translateBy(x: 0, y: page.bounds(for: .mediaBox).height) // Move the origin to the bottom-left corner
                textContext.scaleBy(x: 1.0, y: -1.0) // Flip the context back to normal
                
                // Draw the text at the desired position
                let titleAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.boldSystemFont(ofSize: 24)
                ]
                let title = NSAttributedString(string: "Personal Information", attributes: titleAttributes)
                title.draw(at: CGPoint(x: 50, y: 50)) // Adjusted y-coordinate
                
                let infoAttributes: [NSAttributedString.Key: Any] = [
                    .font: UIFont.systemFont(ofSize: 18)
                ]
                let info = NSAttributedString(string: "Name: \(name)\nEmail: \(email)\nPhone Number: \(phoneNumber)", attributes: infoAttributes)
                info.draw(at: CGPoint(x: 50, y: 100)) // Adjusted y-coordinate
                
                textContext.restoreGState() // Restore the context state
            }
        }
        
        if let pdfDocument = PDFDocument(data: data) {
            self.pdfDocument = pdfDocument
            errorMessage = nil
        } else {
            errorMessage = "Failed to generate PDF."
        }
    }
}
