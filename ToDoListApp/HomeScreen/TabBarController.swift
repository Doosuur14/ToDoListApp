//
//  TabBarController.swift
//  ToDoListApp
//
//  Created by Faki Doosuur Doris on 22.08.2025.
//

import Foundation
import UIKit

final class TabBarController: UITabBarController,  UITabBarControllerDelegate {

    private let toDoListViewModel: ToDoListViewModel
    private let crudTaskViewModel: CRUDTaskViewModel

    init(toDoListViewModel: ToDoListViewModel = ToDoListViewModel(),
         crudTaskViewModel: CRUDTaskViewModel = CRUDTaskViewModel()) {
        self.toDoListViewModel = toDoListViewModel
        self.crudTaskViewModel = crudTaskViewModel
        super.init(nibName: nil, bundle: nil)
        self.delegate = self
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabs()
        self.delegate = self
        tabBar.tintColor = .systemYellow
    }
    

    private func setupTabs() {
        let viewModel = ToDoListViewModel()
        let todoVC = UINavigationController(rootViewController: ToDoListViewController(viewModel: viewModel))
        todoVC.tabBarItem = UITabBarItem(title: "", image: UIImage(systemName: "plus"), tag: 0)
        todoVC.tabBarItem.image?.accessibilityIdentifier = "plus"
        todoVC.tabBarItem.accessibilityIdentifier = "addTab"
        viewControllers = [todoVC]
    }


    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController.tabBarItem.tag == 0 {
            if let navController = selectedViewController as? UINavigationController {
                let viewModel = CRUDTaskViewModel()
                let addTaskVC = AddTaskViewController(viewModel: viewModel)
                navController.pushViewController(addTaskVC, animated: true)
            }
            return false
        }
        return true
    }

}
