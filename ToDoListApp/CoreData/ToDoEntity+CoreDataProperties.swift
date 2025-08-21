//
//  ToDoEntity+CoreDataProperties.swift
//  ToDoListApp
//
//  Created by Faki Doosuur Doris on 21.08.2025.
//
//

import Foundation
import CoreData


extension ToDoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoEntity> {
        return NSFetchRequest<ToDoEntity>(entityName: "ToDoEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var desc: String?
    @NSManaged public var createdAt: Date?
    @NSManaged public var completed: Bool
    @NSManaged public var userId: Int64
    @NSManaged public var isFromApi: Bool

}

extension ToDoEntity : Identifiable {

}
