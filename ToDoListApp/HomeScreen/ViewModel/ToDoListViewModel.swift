//
//  ToDoListViewModel.swift
//  ToDoListApp
//
//  Created by Faki Doosuur Doris on 21.08.2025.
//

import Foundation
import UIKit
import CoreData

class ToDoListViewModel {
    var task: [ToDoEntity] = []
    var filteredTasks: [ToDoEntity] = []
    var remoteDataSource: RemoteDataSourceProtocol
    var reloadTableView: (() -> Void)?

    init(remoteDataSource: RemoteDataSourceProtocol = RemoteDataSource.shared) {
        self.remoteDataSource = remoteDataSource
        setupMockData()
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
                        print("❌ CoreData save/fetch error: \(error)")
                    }
                }
            case .failure(let error):
                print("❌ API error: \(error)")
            }
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
        return cell
    }

}
