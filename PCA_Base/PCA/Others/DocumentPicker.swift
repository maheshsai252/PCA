//
//  DocumentPicker.swift
//  PCA
//
//  Created by Mahesh sai on 26/05/22.
//



import Foundation
import SwiftUI
import CoreData

struct DocCreator {
    
    static func createDoc(context: NSManagedObjectContext, date: Date, name: String) -> DocEnt? {
        let doc = DocEnt(context: context)
        doc.name = name
        doc.date=date
        do {
            try context.save()
            return doc
        } catch {
            print(error)
        }
        return nil
    }
}


struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var pickerResult: [DocEnt]
    @Binding var added: Bool
    let context: NSManagedObjectContext
    func makeUIViewController(context: Context) -> some UIViewController {
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: [.text,.pdf])
        controller.allowsMultipleSelection = false
        controller.shouldShowFileExtensions = true
        controller.delegate = context.coordinator
        return controller
    }
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    func makeCoordinator() -> DocumentPickerCoordinator {
        DocumentPickerCoordinator(context: context, pickerResult: $pickerResult, added: $added)
    }
    
}
class DocumentPickerCoordinator: NSObject, UIDocumentPickerDelegate {
    @Binding var pickerResult: [DocEnt]
    @Binding var added: Bool
    let context: NSManagedObjectContext
    init(context: NSManagedObjectContext,pickerResult: Binding<[DocEnt]>, added: Binding<Bool> ) {
        self.context = context
        self._pickerResult = pickerResult
        self._added = added
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let url = urls.first else {
            return
        }
        // Add URLS
        if let fn = URL.save(localDocumentsURL: url) {
            if let doc = DocCreator.createDoc(context: context, date: url.createdDate, name: fn) {
                self.pickerResult.append(doc)
            }
        }
//        reportsViewModel.addURLS(pickedURL: url)
        added = true
    }
}


extension URL {
    var createdDate: Date {
        let attributes = try! FileManager.default.attributesOfItem(atPath: self.path)
        let creationDate = attributes[.creationDate] as! Date
        return creationDate
    }
    static func save(localDocumentsURL: URL) -> String? {
        let filename = localDocumentsURL.pathComponents.last ?? UUID().uuidString
        let fileURL = tempURL.appendingPathComponent(filename)
        do {
            guard localDocumentsURL.startAccessingSecurityScopedResource() else {return nil}
            defer {
                localDocumentsURL.stopAccessingSecurityScopedResource()
            }
            
            try FileManager.default.copyItem(at: localDocumentsURL, to: fileURL)
            return filename
        }
        catch {
            print(error)
        }
        return nil
    }
    static func load(fileName: String) -> URL? {
        let fileURL = tempURL.appendingPathComponent(fileName)
        return fileURL
    }
    
}
