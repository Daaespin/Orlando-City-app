//
//  ContentView.swift
//  Orlando city app
//
//  Created by Michael Gonzalez on 3/24/24.
//

import SwiftUI
import WebKit
import PDFKit

struct ContentView: View {
    @State private var showPermitsList = false
    @State private var showCurrentApplications = false
    @State private var userApplications: [String] = ["Application 1", "Application 2", "Application 3"] // Example list of user applications

    var body: some View {
        NavigationView {
            VStack {
                Text("Orlando Permits")
                    .font(.title)
                    .padding()

                Image("downtown_orlando")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()

                VStack(spacing: 20) {
                    NavigationLink(destination: PermitsListView(), isActive: $showPermitsList) {
                        EmptyView()
                    }

                    NavigationLink(destination: CurrentApplicationsView(applications: userApplications), isActive: $showCurrentApplications) {
                        EmptyView()
                    }

                    Button(action: {
                        showPermitsList = true
                    }) {
                        Text("Complete an Application")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        showCurrentApplications = true
                    }) {
                        Text("Check on Current Application")
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.accentColor)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            }
        }
    }
}



struct PermitsListView: View {
    var body: some View {
        List {
            DisclosureGroup("General Permitting Forms") {
                Text("Form 1")
                Text("Form 2")
                
                NavigationLink(destination: PDFView(url: "https://www.orlando.gov/files/sharedassets/public/v/1/departments/edv/permitting-services-division/bld/revision-request-1.2020.pdf")) {
                    Text("Revision Request Form")
                }
            }

            DisclosureGroup("Business Tax Receipt Forms") {
                Text("Form 1")
                Text("Form 2")
                Text("Form 3")
            }

            // Other Permit Forms...
        }
        .navigationBarTitle("Permits")
    }
}

struct PDFView: View {
    var url: String

    var body: some View {
        WebView(urlString: url)
            .navigationBarTitle("Revision Request Form")
    }
}

struct WebView: UIViewRepresentable {
    let urlString: String

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        if let url = URL(string: urlString) {
            let request = URLRequest(url: url)
            webView.load(request)
        }
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

    
    


struct CurrentApplicationsView: View {
    var applications: [String]

    var body: some View {
        List {
            if applications.isEmpty {
                Text("Nothing is here yet!")
            } else {
                ForEach(applications, id: \.self) { application in
                    Text(application)
                }
            }
        }
        .navigationBarTitle("Current Applications")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


