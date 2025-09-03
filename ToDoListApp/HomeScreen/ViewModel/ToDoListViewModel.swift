//
//  ToDoListViewModel.swift
//  ToDoListApp
//
//  Created by Faki Doosuur Doris on 21.08.2025.
//

import Foundation
import UIKit
import CoreData

final class ToDoListViewModel {
    @Published var task: [ToDoEntity] = []
    var filteredTasks: [ToDoEntity] = []
    var remoteDataSource: RemoteDataSourceProtocol
    var localDataSource: LocalDataSourceProtocol
    var reloadTableView: (() -> Void)?

    init(remoteDataSource: RemoteDataSourceProtocol = RemoteDataSource.shared, localDataSource: LocalDataSourceProtocol = LocalDataSource.shared) {
        self.remoteDataSource = remoteDataSource
        self.localDataSource = localDataSource
        loadInitialData()
    }


    func numberOfRowsInSection() -> Int {
        return filteredTasks.count
    }

    func heightForRowAt() -> Int {
        return 100
    }

    func searchPost(_ searchText: String) {
        if searchText.isEmpty {
            filteredTasks = task
        } else {
            filteredTasks = task.filter {
                $0.title?.lowercased().contains(searchText.lowercased()) ?? false
            }
        }
        reloadTableView?()
    }

    func cancelButtonClicked() {
        filteredTasks = task
        self.reloadTableView?()
    }

    private func setupMockData() {
        remoteDataSource.fetchContent { [weak self] result in
            switch result {
            case .success(let todos):
                let context = CoreDataManager.shared.viewContext
                context.perform {
                    todos.forEach { remoteTodo in
                        _ = remoteTodo.toCoreDataEntity(in: context)
                    }
                    do {
                        try context.save()
                        let request: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
                        let savedTodos = try context.fetch(request)

                        self?.task = savedTodos
                        self?.filteredTasks = savedTodos

                        DispatchQueue.main.async {
                            self?.reloadTableView?()
                        }
                    } catch {
                        print("CoreData save error: \(error)")
                    }
                }
            case .failure(let error):
                print("API error: \(error)")
            }
        }
    }

    func toggleCompleted(at indexPath: IndexPath) {
        let todo = filteredTasks[indexPath.row]
        todo.completed = true

        let context = CoreDataManager.shared.viewContext
        do {
            try context.save()
            reloadTableView?()
        } catch {
            print("Failed to save toggle: \(error)")
        }
    }


    func configureCell(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ToDoListTableViewCell.reuseIdentifier, for: indexPath)
        as? ToDoListTableViewCell
        guard let cell = cell else {return UITableViewCell()}
        var tasks: ToDoEntity
        if filteredTasks.isEmpty {
            tasks = task[indexPath.row]
        } else {
            tasks = filteredTasks[indexPath.row]
        }

        cell.tag = indexPath.row
        cell.configureCell(with: tasks)
        cell.onToggleCompleted = { [weak self] in
            print("onToggleCompleted called for indexPath: \(indexPath)")
            self?.toggleCompleted(at: indexPath)
        }
        return cell
    }


    private func loadInitialData() {
        let context = CoreDataManager.shared.viewContext
        let request: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()

        do {
            let savedTodos = try context.fetch(request)
            if savedTodos.isEmpty {
                setupMockData()
            } else {
                self.task = savedTodos
                self.filteredTasks = savedTodos
                DispatchQueue.main.async {
                    self.reloadTableView?()
                }
            }
        } catch {
            print("CoreData fetch error: \(error)")
        }
    }

    func addTask(title: String, desc: String?, completion: @escaping (Result<ToDoEntity, Error>) -> Void) {
        localDataSource.createTask(title: title, desc: desc) { [weak self] result in
            switch result {
            case .success(let task):
                self?.task.append(task)
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
                self?.task = fetchedTasks
                completion()
            case .failure(let error):
                print("Failed to fetch tasks: \(error)")
                completion()
            }
        }
    }

    func deleteTask(at indexPath: IndexPath) {
        let todo = filteredTasks[indexPath.row]
        localDataSource.deleteTask(todo) { [weak self] result in
            switch result {
            case .success:
                self?.task.removeAll { $0 == todo }
                self?.filteredTasks.removeAll { $0 == todo }
                DispatchQueue.main.async {
                    self?.reloadTableView?()
                }
            case .failure(let error):
                print("Failed to delete task: \(error)")
            }
        }
    }

    func editTask(todo: ToDoEntity, title: String, desc: String, completion: @escaping (Bool) -> Void) {
        if todo.completed {
            completion(false)
            return
        }
        localDataSource.editTask(todo, title: title, desc: desc) { [weak self] result in
            switch result {
            case .success(let updatedTask):
                if let index = self?.task.firstIndex(where: { $0 == todo }) {
                    self?.task[index] = updatedTask
                }
                if let index = self?.filteredTasks.firstIndex(where: { $0 == todo }) {
                    self?.filteredTasks[index] = updatedTask
                }
                DispatchQueue.main.async {
                    self?.reloadTableView?()
                    completion(true)
                }
            case .failure(let error):
                print("Failed to edit task: \(error)")
                completion(false)
            }
        }
    }
}
