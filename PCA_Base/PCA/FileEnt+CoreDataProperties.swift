//
//  FileEnt+CoreDataProperties.swift
//

import Foundation
import CoreData


extension FileEnt {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FileEnt> {
        return NSFetchRequest<FileEnt>(entityName: "FileEnt")
    }

    @NSManaged public var fileAttach:  [String]? //NSObject?
    @NSManaged public var fileName: String?
    @NSManaged public var docAttach: [String]?
    @NSManaged public var fileDate: Date?
    @NSManaged public var fileTag: String?
    @NSManaged public var fileNotes: String?
    @NSManaged public var id: UUID?
    @NSManaged public var fileCate: CateEnt?
    @NSManaged public var docs: NSSet? // Documents

}
extension FileEnt {

    @objc(addDocObject:)
    @NSManaged public func addToFileEnt(_ value: DocEnt)

    @objc(removeDocObject:)
    @NSManaged public func removeFromFileEnt(_ value: DocEnt)

    @objc(addDocFile:)
    @NSManaged public func addToFileEnt(_ values: NSSet)

    @objc(removeDocFile:)
    @NSManaged public func removeFromFileEnt(_ values: NSSet)

}
extension FileEnt : Identifiable {

}
