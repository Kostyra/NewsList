//
//  CollectionViewModel.swift
//  List
//
//  Created by Kos on 09.12.2024.
//

import Foundation

protocol CollectionViewModelProtocol {
    var stateDidChange: ((CollectionViewModel.State) -> Void)? { get set }
    var isLoading:Bool { get }
    func getList()
    func loadNextPage()
}


final class CollectionViewModel {
    
    //MARK: - Enum
    
    enum State {
        case loading
        case done(lists: [ListUIModel])
        case error(error: String)
    }
    
    //MARK: - properties
    
    private weak var coordinator: CollectionViewCoordinator?
    private let apiService: ListsApiService
    private var lists: [ListUIModel] = []
    private var pageSize = 15
    private var currentPage = 1
    var isLoading = false
    
    var stateDidChange:((State) -> Void)?
    var state: State = .loading {
        didSet {
            self.stateDidChange?(state)
        }
    }
    
    
    //MARK: - Initialise
    
    init(coordinator: CollectionViewCoordinator, apiService: ListsApiService) {
        self.coordinator = coordinator
        self.apiService = apiService
    }
    
    deinit {
        print("TableModel \(#function)")
        
    }
    
    //MARK: - Method
    
    func getLists(page: Int) {
        guard !isLoading else { return }
        isLoading = true
        stateDidChange?(.loading)
        
        Task { @MainActor [weak self] in
            guard let self = self else { return }
            do {
                let newLists = try await apiService.getLists(page: page, pageSize: pageSize)
                if page == 1 {
                    self.lists = newLists
                } else {
                    self.lists.append(contentsOf: newLists)
                }
                self.state = .done(lists: self.lists)
                self.isLoading = false
            } catch {
                self.state = .error(error: error.localizedDescription)
                self.isLoading = false
            }
        }
    }
    
    func loadNextPage() {
        guard !isLoading else { return }
        currentPage += 1
        getLists(page: currentPage)
    }
}

//MARK: - extension CollectionViewModel


extension CollectionViewModel: CollectionViewModelProtocol {

    func getList() {
        currentPage = 1
        getLists(page: currentPage)
    }
}
