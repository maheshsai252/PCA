//
//  FileManager+Extension.swift
//

import Foundation
import MessageUI

var tempURL: URL {
    return FileManager.default.temporaryDirectory
}

var dirURL: FileManager {
    return FileManager.default
}

extension FileManager {
    func deleteFiles(fileNames: [String]) {
        do {
            let tmpDirectory = try contentsOfDirectory(atPath: tempURL.path)
            try tmpDirectory.filter({ fileNames.contains($0) }).forEach({
                let fileUrl = tempURL.appendingPathComponent($0)
                try removeItem(atPath: fileUrl.path)
            })
        } catch {
            debugPrint(error)
        }
    }

}
