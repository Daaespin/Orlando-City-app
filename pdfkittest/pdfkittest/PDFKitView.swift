import SwiftUI
import PDFKit

struct PDFKitView: UIViewRepresentable {
    
    let pdfDocument: PDFDocument
    
    init(pdfData pdfDoc: PDFDocument) {
        self.pdfDocument = pdfDoc
    }
    
    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.document = pdfDocument
        pdfView.autoScales = true
        
        return pdfView
    }
    
    func updateUIView(_ pdfView: PDFView, context: Context) {
        pdfView.document = pdfDocument
    }
}
