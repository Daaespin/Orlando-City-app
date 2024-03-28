import SwiftUI

struct ContentView: View {
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var phoneNumber: String = ""
    @State private var isShowingPDF: Bool = false

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
                isShowingPDF = true
            }
        }
    }
}
