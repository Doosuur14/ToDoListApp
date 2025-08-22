//
//  LocalDataSource.swift
//  ToDoListApp
//
//  Created by Faki Doosuur Doris on 22.08.2025.
//

import Foundation
import CoreData

protocol LocalDataSourceProtocol {
    func createTask(title: String, desc: String?, completion: @escaping (Result<ToDoEntity, Error>) -> Void)
    func fetchTasks(completion: @escaping (Result<[ToDoEntity], Error>) -> Void)

}

class LocalDataSource: LocalDataSourceProtocol {

    static let shared = LocalDataSource()

    func createTask(title: String, desc: String?, completion: @escaping (Result<ToDoEntity, any Error>) -> Void) {
        let context = CoreDataManager.shared.viewContext
        let task = ToDoEntity(context: context)
        task.id = Int64(Date().timeIntervalSince1970)
        task.title = title
        task.desc = desc
        task.createdAt = Date.now

        do {
            try context.save()
            completion(.success(task))
        } catch {
            completion(.failure(error))
        }
    }

    func fetchTasks(completion: @escaping (Result<[ToDoEntity], Error>) -> Void) {

        let context = CoreDataManager.shared.viewContext
        let request: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()

        do {
            let tasks = try context.fetch(request)
            completion(.success(tasks))
        } catch {
            completion(.failure(error))
        }
    }

}
