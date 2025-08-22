//
//  EditTaskViewController.swift
//  ToDoListApp
//
//  Created by Faki Doosuur Doris on 22.08.2025.
//

import UIKit
import UIKit
import SnapKit

protocol EditTaskViewControllerDelegate: AnyObject {
    func didUpdateTask(_ task: ToDoEntity?)
}

class EditTaskViewController: UIViewController {
    var editTaskView: AddTaskView?
    let viewModel: ToDoListViewModel
//    let viewModel: CRUDTaskViewModel
    let todo: ToDoEntity

    weak var delegate: EditTaskViewControllerDelegate?

    init(viewModel: ToDoListViewModel, todo: ToDoEntity) {
        self.viewModel = viewModel
        self.todo = todo
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setupNavigation()
        populateFields()
    }

    private func setUpView() {
        editTaskView = AddTaskView(frame: view.bounds)
        view = editTaskView
        view.backgroundColor = .systemBackground
    }

    private func setupNavigation() {
        navigationItem.title = "Edit Task"
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelTapped)
        )
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .save,
            target: self,
            action: #selector(saveTapped)
        )
        navigationItem.rightBarButtonItem?.tintColor = .systemYellow
        navigationItem.leftBarButtonItem?.tintColor = .systemYellow
    }

    private func populateFields() {
        editTaskView?.titleTextField.text = todo.title ?? ""
        editTaskView?.descriptionTextView.text = todo.desc ?? ""
        if editTaskView?.descriptionTextView.text.isEmpty ?? true {
            editTaskView?.descriptionTextView.text = "Add details..."
            editTaskView?.descriptionTextView.textColor = .secondaryLabel
        } else {
            editTaskView?.descriptionTextView.textColor = .label
        }
    }

    @objc private func cancelTapped() {
        dismiss(animated: true)
        navigationController?.popViewController(animated: true)
    }

    @objc private func saveTapped() {
        guard let title = editTaskView?.titleTextField.text, !title.isEmpty else {
            return
        }
        let descText = editTaskView?.descriptionTextView.text ?? ""
        guard let desc = descText == "Add details..." ? nil : descText else { return  }
        viewModel.editTask(todo: todo, title: title, desc: desc) { [weak self] success in
            if success {
                print("Task edited: \(title)")
                self?.delegate?.didUpdateTask(self?.todo)
                self?.dismiss(animated: true)
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true)
                }
            } else {
                self?.showAlert(message: "Cannot edit completed tasks")
            }
        }
    }

    private func showAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
