//We can also log the pdfs that were created using the app with a database. 
// Please let me know if you want to use the database instead. 
//We can also log the date of the PDF. 
import Foundation

class PDFTracker {
    static let pdfListKey = "PDFList"


    static func trackPDF(permitID: String, fileName: String) {
        // Load the existing PDF list from UserDefaults
        var pdfList = UserDefaults.standard.stringArray(forKey: pdfListKey) ?? []
        
        // Add the new PDF file name along with the permit ID
        let pdfInfo = "\(permitID): \(fileName)"
        pdfList.append(pdfInfo)
        
        // Save the updated PDF list back to UserDefaults
        UserDefaults.standard.set(pdfList, forKey: pdfListKey)
    }
    
    static func getPDFList() -> [String] {
        // Retrieve the PDF list from UserDefaults
        return UserDefaults.standard.stringArray(forKey: pdfListKey) ?? []
    }
}
