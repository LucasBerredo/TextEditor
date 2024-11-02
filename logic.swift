//
//  logic.swift
//  textEditor
//
//  Created by Lucas Berredo de la Colina on 2/11/24.
//

import UniformTypeIdentifiers
import SwiftUI

struct TextDocument: FileDocument {
    static public var readableContentTypes = [UTType.plainText]
    
    var text = ""
    
    init(_ text: String = "") {
        self.text = text
    }
    
    init(configuration: ReadConfiguration) throws {
        if let data = configuration.file.regularFileContents {
            text = String(decoding: data, as: UTF8.self)
        }
    }
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data(text.utf8)
        return FileWrapper(regularFileWithContents: data)
    }
    
    
    
}

