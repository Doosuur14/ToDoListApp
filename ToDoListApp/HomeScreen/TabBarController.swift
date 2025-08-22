//
//  TabBarController.swift
//  ToDoListApp
//
//  Created by Faki Doosuur Doris on 22.08.2025.
//

import Foundation
import UIKit

class TabBarController: UITabBarController,  UITabBarControllerDelegate {

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
