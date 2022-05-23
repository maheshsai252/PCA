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
    @NSManaged public var fileDate: Date?
    @NSManaged public var fileTag: String?
    @NSManaged public var fileNotes: String?
    @NSManaged public var id: UUID?
    @NSManaged public var fileCate: CateEnt?

}

extension FileEnt : Identifiable {

}
