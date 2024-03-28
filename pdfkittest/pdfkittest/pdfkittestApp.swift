//
//  pdfkittestApp.swift
//  pdfkittest
//
//  Created by Diamond Ratuppanant on 3/25/24.
//

import SwiftUI

@main
struct pdfkittestApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            PDFExampleView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
