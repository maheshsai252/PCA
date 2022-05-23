//
//  UIImage+Extension.swift
//

import Foundation
import SwiftUI

extension Date {
    func string(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}

extension UIImage {
    func save() -> String? {
        let fileName = UUID().uuidString
        let fileURL = tempURL.appendingPathComponent(fileName)
        if let imageData = self.jpegData(compressionQuality: 0.8) {
           try? imageData.write(to: fileURL, options: .atomic)
           return fileName
        }
        print("Error saving image")
        return nil
    }
    
    func load(fileName: String) -> UIImage? {
        let fileURL = tempURL.appendingPathComponent(fileName)
        do {
            let imageData = try Data(contentsOf: fileURL)
            let image = UIImage(data: imageData)
            image?.jpegData(compressionQuality: 0.3)
            return image
        } catch {
            print("Error loading image : \(error)")
        }
        return nil
    }
}
