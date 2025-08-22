//
//  CRUDTaskViewModel.swift
//  ToDoListApp
//
//  Created by Faki Doosuur Doris on 22.08.2025.
//

import Foundation

class CRUDTaskViewModel {

    var localDataSource: LocalDataSourceProtocol
    var tasks: [ToDoEntity] = []

    var onTaskAdded: (() -> Void)?

    init(localDataSource: LocalDataSourceProtocol = LocalDataSource.shared) {
        self.localDataSource = localDataSource
    }

    func addTask(title: String, desc: String?, completion: @escaping (Result<ToDoEntity, Error>) -> Void) {
        //        localDataSource.createTask(title: title, desc: desc, completion: completion)
        localDataSource.createTask(title: title, desc: desc) { [weak self] result in
            switch result {
            case .success(let task):
                self?.tasks.append(task)
                completion(.success(task))
            case .failure(let error):
                print("Failed to create task: \(error)")
                completion(.failure(error))
            }
        }
    }


    func fetchTasks(completion: @escaping () -> Void) {
        localDataSource.fetchTasks { [weak self] result in
            switch result {
            case .success(let fetchedTasks):
                self?.tasks = fetchedTasks
                completion()
            case .failure(let error):
                print("Failed to fetch tasks: \(error)")
                completion()
            }
        }
    }

}

