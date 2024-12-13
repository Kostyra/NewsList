//
//  CollectionViewCoordinator.swift
//  List
//
//  Created by Kos on 09.12.2024.
//

import UIKit



final class CollectionViewCoordinator {
    
    
    // MARK: - Properties
    
    weak var parentCoordinator: AppCoordinator?
    private var navigationController: UINavigationController?
    private var rootViewController: UIViewController?
    private var childCoordinators: [CoordinatorProtocol] = []
    
    
    //MARK: - Initialise
    
    
    init(parentCoordinator: AppCoordinator?) {
        self.parentCoordinator = parentCoordinator
    }
    
    deinit {
        print("CollectionViewCoordinator delete")
    }
    
    
    // MARK: - Methods
    
    private func createNavigationController() -> UIViewController {
        let coreMapper = CoreMapper()
        let networkManager = CoreNetworkManager()
        let apiService = ListsApiService(mapper: coreMapper, networkManager: networkManager)
        let viewModel = CollectionViewModel(coordinator: self, apiService: apiService)
        let collectionViewController = CollectionViewController(viewModel: viewModel)
        let navigationController = UINavigationController(rootViewController: collectionViewController)
        self.navigationController = navigationController
        return navigationController
    }
    
    func pushChildViewController(_ viewController: UIViewController) {
        if let navigationController = navigationController {
            navigationController.pushViewController(viewController, animated: true)
        }
    }
    
    private func addChildCoordinator(_ coordinator: CoordinatorProtocol) {
        childCoordinators.append(coordinator)
    }
    
    private func removeChildCoordinator(_ coordinator: CoordinatorProtocol) {
        if let index = childCoordinators.firstIndex(where: { $0 === coordinator }) {
            childCoordinators.remove(at: index)
        }
    }
}

// MARK: - CoordinatorProtocol

extension CollectionViewCoordinator: CoordinatorProtocol {
    func start() -> UIViewController {
        createNavigationController()
    }
}

