//
//  AddTaskViewController.swift
//  ToDoListApp
//
//  Created by Faki Doosuur Doris on 22.08.2025.
//

import UIKit

class AddTaskViewController: UIViewController {

    var addTaskView: AddTaskView?
    let viewModel: CRUDTaskViewModel

    init(viewModel: CRUDTaskViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
        setupNavigation()
    }

    private func setUpView() {
       addTaskView = AddTaskView(frame: view.bounds)
        view = addTaskView
        view.backgroundColor = .systemBackground
    }

    private func setupNavigation() {
        navigationItem.title = "New Task"
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

    @objc private func cancelTapped() {
        dismiss(animated: true)
        navigationController?.popViewController(animated: true)
    }

    @objc private func saveTapped() {
        guard let title = addTaskView?.titleTextField.text, !title.isEmpty else {
            return
        }
        let desc = addTaskView?.descriptionTextView.text == "Add details..." ? nil : addTaskView?.descriptionTextView.text
        viewModel.addTask(title: title, desc: desc) { [weak self] result in
            switch result {
            case .success(let task):
                print("Task saved: \(task.title ?? "")")
                self?.dismiss(animated: true)
                DispatchQueue.main.async {
                    self?.navigationController?.popViewController(animated: true) 
                }
            case .failure(let error):
                print("Failed to save: \(error)")
            }
        }
    }
}
