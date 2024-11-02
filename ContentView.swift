//
//  ContentView.swift
//  textEditor
//
//  Created by Lucas Berredo de la Colina on 2/11/24.
//

import SwiftUI

struct ContentView: View{
    var body: some View{
        VStack{
            Text("Text editor")
                .font(.system(size:36))
            Spacer()
                .frame(height:25)
            ExportToggleView()
        }
        .padding()
    }
    
}

struct ExportToggleView: View {
    @State private var text: String = ""
    @State private var showingExporter = false
    @State private var showingImporter = false
    @State private var error: Error?
    
    private func read(from url: URL) -> Result<String,Error> {
        let accessing = url.startAccessingSecurityScopedResource()
        defer {
            if accessing {
                url.stopAccessingSecurityScopedResource()
            }
        }
        return Result {try String(contentsOf: url)}
    }


    
    var body: some View{
        VStack{
            HStack{
                Spacer()
                Button("Import file") {
                    showingImporter = true
                }
                Spacer()
                Button("Export file") {
                    showingExporter = true
                }
                Spacer()
            }
            TextEditingView(text: $text)
        }
        .fileExporter(isPresented: $showingExporter,
                          document: TextDocument(text),
                          contentType: .text,
                          defaultFilename: "boop_backup2.txt") { result in
                if case .failure(let error) = result {
                    self.error = error
                }
            }
            
          .fileImporter(isPresented: $showingImporter,
                        allowedContentTypes: [.text]) {
              let result = $0.flatMap { url in read(from: url) }
              switch result {
              case .success(let importedText):
                  self.text = importedText
              case .failure(let error):
                  self.error = error
              }
          }
        }
    }


struct TextEditingView: View {
    @Binding var text: String

    var body: some View{
        TextEditor(text: $text)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}


