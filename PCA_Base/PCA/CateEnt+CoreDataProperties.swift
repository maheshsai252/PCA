//
//  CateEnt+CoreDataProperties.swift
//

import Foundation
import CoreData


extension CateEnt {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CateEnt> {
        return NSFetchRequest<CateEnt>(entityName: "CateEnt")
    }

    @NSManaged public var cateName: String?
    @NSManaged public var cateOrdinal: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var cateFile: NSSet?

}

// MARK: Generated accessors for cateFile
extension CateEnt {

    @objc(addCateFileObject:)
    @NSManaged public func addToCateFile(_ value: FileEnt)

    @objc(removeCateFileObject:)
    @NSManaged public func removeFromCateFile(_ value: FileEnt)

    @objc(addCateFile:)
    @NSManaged public func addToCateFile(_ values: NSSet)

    @objc(removeCateFile:)
    @NSManaged public func removeFromCateFile(_ values: NSSet)

}

extension CateEnt : Identifiable {

}
