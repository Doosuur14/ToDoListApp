//
//  Todo.swift
//  ToDoListApp
//
//  Created by Faki Doosuur Doris on 21.08.2025.
//

import Foundation
import CoreData

struct RemoteTodo: Decodable {
    let id: Int
    let todo: String
    let completed: Bool
    let userId: Int
}

extension RemoteTodo {
    func toCoreDataEntity(in context: NSManagedObjectContext) -> ToDoEntity {
        let entity = ToDoEntity(context: context)
        entity.id = Int64(id)
        entity.title = todo
        entity.desc = ""
        entity.createdAt = Date()
        entity.completed = completed
        entity.userId = Int64(userId)
        entity.isFromApi = true
        return entity
    }
}


