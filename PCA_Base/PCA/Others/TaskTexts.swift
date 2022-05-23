//
//  TaskTexts.swift
//

import SwiftUI
import UniformTypeIdentifiers

struct TaskTxt: FileDocument {
    // tasktxt = document, tasktexts = message, TaskTxt=MessageDocument

    static var readableContentTypes: [UTType] { [.plainText] }

    var tasktexts: String
    init(tasktexts: String) {
        self.tasktexts = tasktexts
    }

    init(configuration: ReadConfiguration) throws {
        guard let data = configuration.file.regularFileContents,
              let string = String(data: data, encoding: .utf8)
        else {
            throw CocoaError(.fileReadCorruptFile)
        }
        tasktexts = string
    }

    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        return FileWrapper(regularFileWithContents: tasktexts.data(using: .utf8)!)
    }
    
}
