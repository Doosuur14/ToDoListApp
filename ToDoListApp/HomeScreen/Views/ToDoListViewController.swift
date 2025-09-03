//
//  ToDoListViewController.swift
//  ToDoListApp
//
//  Created by Faki Doosuur Doris on 21.08.2025.
//

import UIKit

final class ToDoListViewController: UIViewController, UITableViewDataSource,
                              UITableViewDelegate, UISearchBarDelegate, EditTaskViewControllerDelegate{

    var toDoView: ToDoListView?
    var addtaskView: AddTaskView?
    let viewModel: ToDoListViewModel


    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    init(viewModel: ToDoListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        viewModel.reloadTableView = { [weak self] in
            DispatchQueue.main.async {
                self?.toDoView?.tableView.reloadData()
                self?.updateNoResultsLabel()
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.fetchTasks { [weak self] in
            DispatchQueue.main.async {
                self?.toDoView?.tableView.reloadData()
            }
        }

    }


    private func setupView() {
        toDoView = ToDoListView(frame: view.bounds)
        view = toDoView
        toDoView?.setupDelegate(with: self)
        toDoView?.setupDataSource(with: self)
        toDoView?.tableView.register(ToDoListTableViewCell.self, forCellReuseIdentifier: ToDoListTableViewCell.reuseIdentifier)
        toDoView?.tableView.separatorStyle = .none
        toDoView?.searchBar.delegate = self
        toDoView?.label.frame = view.bounds
        view.backgroundColor = .systemBackground
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfRowsInSection()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        viewModel.configureCell(tableView, cellForRowAt: indexPath)
    }


    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CGFloat(viewModel.heightForRowAt())
    }

    private func updateNoResultsLabel() {
        toDoView?.label.isHidden = viewModel.numberOfRowsInSection() != 0
    }

    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchPost(searchText)
    }


    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        toDoView?.searchBar.resignFirstResponder()
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        toDoView?.searchBar.resignFirstResponder()
        viewModel.cancelButtonClicked()
    }

    func didCreateTask(_ tasktodo: ToDoEntity) {
        viewModel.task.append(tasktodo)
        viewModel.filteredTasks.append(tasktodo)
        toDoView?.tableView.insertRows(at: [IndexPath(row: viewModel.task.count - 1, section: 0)], with: .none)
    }

    func tableView(_ tableView: UITableView, contextMenuConfigurationForRowAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil) { [weak self] _ in
            let delete = UIAction(title: "Delete", image: UIImage(systemName: "trash"), attributes: .destructive) { [weak self] _ in
                self?.viewModel.deleteTask(at: indexPath)
            }
            let edit = UIAction(title: "Edit", image: UIImage(systemName: "pencil")) { [weak self] _ in
                guard let self = self else { return }
                let todo = self.viewModel.filteredTasks[indexPath.row]
                let editVC = EditTaskViewController(viewModel: self.viewModel, todo: todo)
                editVC.delegate = self
                self.navigationController?.pushViewController(editVC, animated: true)
            }
            return UIMenu(title: "", children: [edit, delete])
        }
    }

    
    private func navigateToEdit(at indexPath: IndexPath) {
        let todo = viewModel.filteredTasks[indexPath.row]
        let editVC = EditTaskViewController(viewModel: viewModel, todo: todo)
        editVC.delegate = self
        navigationController?.pushViewController(editVC, animated: true)
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    func didUpdateTask(_ task: ToDoEntity?) {
        viewModel.fetchTasks { [weak self] in
            self?.toDoView?.tableView.reloadData()
        }
    }
}
