//
//  ViewModel.swift
//

import Foundation
import CoreData

class FileViewModel: ObservableObject {
    @Published var fileDate = Date()
    @Published var fileName = ""
    @Published var fileNotes = ""
    @Published var fileTag = ""
    @Published var id = UUID()
    @Published var isNewData = false
    @Published var updateFile : FileEnt!
    @Published var pickerResult: [String] = []
    @Published var documents: [DocEnt] = [] // documents array

    @Published var selectedCate: CateEnt? = nil
    
    init() {
    }
    var temporaryStorage: [String] = []

    func writeData(context : NSManagedObjectContext) {
        if updateFile != nil {
            updateCurrentFile()
            FileManager.default.deleteFiles(fileNames: temporaryStorage)
        } else {
            createNewFile(context: context)
        }
        
        do {
            try context.save()
        } catch {
            print(error.localizedDescription)
        }
    }
     
    func DetailItem(fileItem: FileEnt) {
        fileDate = fileItem.fileDate ?? Date()
        fileName = fileItem.fileName ?? ""
        fileNotes = fileItem.fileNotes ?? ""
        fileTag = fileItem.fileTag ?? ""
        id = fileItem.id ?? UUID()
        updateFile = fileItem
        pickerResult = fileItem.fileAttach.map({ $0 }) ?? []
        selectedCate = fileItem.fileCate
        documents = fileItem.docs?.allObjects as? [DocEnt] ?? []
    }
    
    func EditItem(fileItem: FileEnt) {
        fileDate = fileItem.fileDate ?? Date()
        fileName = fileItem.fileName ?? ""
        fileNotes = fileItem.fileNotes ?? ""
        fileTag = fileItem.fileTag ?? ""
        id = fileItem.id ?? UUID()
        isNewData.toggle()
        updateFile = fileItem
        pickerResult = fileItem.fileAttach.map({ $0 }) ?? []
        selectedCate = fileItem.fileCate
        documents = fileItem.docs?.allObjects as? [DocEnt] ?? [] // retrieve docs
    }
    
    private func createNewFile(context : NSManagedObjectContext) {
        let newFile = FileEnt(context: context)
        newFile.fileCate = selectedCate
        newFile.fileDate = fileDate
        newFile.fileName = fileName
        newFile.fileNotes = fileNotes
        newFile.fileTag = fileTag
        newFile.id = id
        newFile.fileAttach = pickerResult
        newFile.fileCate = selectedCate
        newFile.docs = NSSet(array: documents) // add docs
    }
    
    private func updateCurrentFile() {
        updateFile.fileDate = fileDate
        updateFile.fileName = fileName
        updateFile.fileNotes = fileNotes
        updateFile.fileTag = fileTag
        updateFile.id = id
        updateFile.fileAttach = pickerResult
        updateFile.fileCate = selectedCate
        updateFile.docs = NSSet(array: documents)

    }
    
    private func resetData() {
        fileDate = Date()
        fileName = ""
        fileNotes = ""
        fileTag = ""
        id = UUID()
        isNewData.toggle()
        updateFile = nil
        pickerResult = []
        documents = []
    }
    
}


class CateViewModel : ObservableObject {
    
    @Published var lastValue = 0
    @Published var cateName = ""
    @Published var isNewData = false
    @Published var updateCate : CateEnt!

    func writeCate(context : NSManagedObjectContext){
        if updateCate != nil{
            updateCate.cateName = cateName

            try! context.save()
            updateCate = nil
            isNewData.toggle()
            cateName = ""
            return
        }
        
        let itemToSave = CateEnt(context: context)
        itemToSave.id = UUID()
        itemToSave.cateName = "\(cateName)"
        itemToSave.cateOrdinal = Int16(lastValue)
        cateName = ""
        
        do{
            try context.save()
            isNewData.toggle()
            cateName = ""
        }
        catch{
            print(error.localizedDescription)
        }
    }

    func EditCate(cateItem: CateEnt){
        updateCate = cateItem
        cateName = cateItem.cateName!
        isNewData.toggle()
    }
}
