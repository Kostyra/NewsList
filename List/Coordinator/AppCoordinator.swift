//
//  AppCoordinator.swift
//  List
//
//  Created by Kos on 09.12.2024.
//


import UIKit

protocol AppCoordinatorProtocol: AnyObject {
    
}

final class AppCoordinator {
    
    //MARK: - Private properties
    
    private var rootViewController: UIViewController
    private var childsCoordinators: [CoordinatorProtocol] = []
    
    //MARK: - Initialise
    
    init(rootViewController: UIViewController) {
        self.rootViewController = rootViewController
    }
    
    //MARK: - Private methods
    
    
    private func collectionViewCoordinator() -> CoordinatorProtocol {
        let collectionViewCoordinator = CollectionViewCoordinator(parentCoordinator: self)
        return collectionViewCoordinator
    }
    
    private func showCollectionViewScreen() -> UIViewController {
        let coordinator = collectionViewCoordinator()
        addChildCoordinator(coordinator)
        setFlow(to: coordinator.start())
        return rootViewController
    }
    
    private func setFlow(to newViewController: UIViewController) {
        rootViewController.addChild(newViewController)
        newViewController.view.frame = rootViewController.view.frame
        rootViewController.view.addSubview(newViewController.view)
        newViewController.didMove(toParent: rootViewController)
    }
    
    private func switchCoordinators(from previousCoordinator: CoordinatorProtocol, to nextCoordinator: CoordinatorProtocol) {
        addChildCoordinator(nextCoordinator)
        switchFlow(to: nextCoordinator.start())
        removeChildCoordinator(previousCoordinator)
    }
    
    private func switchFlow(to newViewController: UIViewController) {
        guard let currentViewController = rootViewController.children.first else {
            return
        }
        
        currentViewController.willMove(toParent: nil)
        currentViewController.navigationController?.isNavigationBarHidden = true
        rootViewController.addChild(newViewController)
        newViewController.view.frame = rootViewController.view.bounds
        
        rootViewController.transition(
            from: rootViewController.children[0],
            to: newViewController,
            duration: 0.5,
            options: [.transitionFlipFromRight]
        ) { [weak self] in
            guard let self else { return }
            currentViewController.removeFromParent()
            newViewController.didMove(toParent: rootViewController)
        }
    }
    
    private func addChildCoordinator(_ coordinator: CoordinatorProtocol) {
        childsCoordinators.append(coordinator)
    }
    
    private func removeChildCoordinator(_ coordinator: CoordinatorProtocol) {
        if let index = childsCoordinators.firstIndex(where: { $0 === coordinator }) {
            childsCoordinators.remove(at: index)
        }
    }
}

//MARK: - extension CoordinatorProtocol


extension AppCoordinator: CoordinatorProtocol {
    func start() -> UIViewController {
        showCollectionViewScreen()
    }
}

