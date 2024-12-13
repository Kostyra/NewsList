//
//  CollectionViewModel.swift
//  List
//
//  Created by Kos on 09.12.2024.
//

//import Foundation
//import Combine
//
//// MARK: - CollectionViewModelProtocol
//protocol CollectionViewModelProtocol {
//    var stateDidChange: ((CollectionViewModel.State) -> Void)? { get set }
//    func getList()
//    func loadNextPage()
//}
//
//final class CollectionViewModel {
//    enum State {
//        case loading
//        case done(lists: [ListUIModel])
//        case error(error: String)
//    }
//
//    private weak var coordinator: CollectionViewCoordinator?
//    private let apiService: ListsApiServiceProtocol
//    private var lists: [ListUIModel] = []
//    private var pageSize = 15
//    private var currentPage = 1
//    private var cancellables = Set<AnyCancellable>()
//
//    var stateDidChange: ((State) -> Void)?
//    var state: State = .loading {
//        didSet {
//            self.stateDidChange?(state)
//        }
//    }
//
//    init(coordinator: CollectionViewCoordinator, apiService: ListsApiServiceProtocol) {
//        self.coordinator = coordinator
//        self.apiService = apiService
//    }
//
//    func getLists(page: Int) {
//        state = .loading
//        apiService.getLists(page: page, pageSize: pageSize)
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { [weak self] completion in
//                guard let self = self else { return }
//                switch completion {
//                case .failure(let error):
//                    self.state = .error(error: error.localizedDescription)
//                case .finished:
//                    break
//                }
//            }, receiveValue: { [weak self] newLists in
//                guard let self = self else { return }
//                if page == 1 {
//                    self.lists = newLists
//                } else {
//                    self.lists.append(contentsOf: newLists)
//                }
//                self.state = .done(lists: self.lists)
//            })
//            .store(in: &cancellables)
//    }
//
//    func loadNextPage() {
//        currentPage += 1
//        getLists(page: currentPage)
//    }
//}
//
//extension CollectionViewModel: CollectionViewModelProtocol {
//    func getList() {
//        currentPage = 1
//        getLists(page: currentPage)
//    }
//}


import Foundation
import Combine

// MARK: - CollectionViewModelProtocol
protocol CollectionViewModelProtocol {
    var statePublisher: Published<CollectionViewModel.State>.Publisher { get }
    var isLoadingNextPage: Bool { get }
    func getList()
    func loadNextPage()
}

final class CollectionViewModel: ObservableObject {
    enum State {
        case loading
        case done(lists: [ListUIModel])
        case error(error: String)
    }

    
    var isLoadingNextPage = false 
    private weak var coordinator: CollectionViewCoordinator?
    private let apiService: ListsApiServiceProtocol
    private var lists: [ListUIModel] = []
    private var pageSize = 15
    private var currentPage = 1
    private var cancellables = Set<AnyCancellable>()

    @Published private(set) var state: State = .loading

    var statePublisher: Published<State>.Publisher { $state }

    init(coordinator: CollectionViewCoordinator, apiService: ListsApiServiceProtocol) {
        self.coordinator = coordinator
        self.apiService = apiService
    }

    private func getLists(page: Int) {
        state = .loading
        apiService.getLists(page: page, pageSize: pageSize)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure(let error):
                    self.state = .error(error: error.localizedDescription)
                    self.isLoadingNextPage = false
                case .finished:
                    break
                }
            }, receiveValue: { [weak self] newLists in
                guard let self = self else { return }
                if page == 1 {
                    self.lists = newLists
                } else {
                    self.lists.append(contentsOf: newLists)
                }
                self.state = .done(lists: self.lists)
                self.isLoadingNextPage = false
            })
            .store(in: &cancellables)
    }

    func loadNextPage() {
         guard !isLoadingNextPage else { return }
         isLoadingNextPage = true
         currentPage += 1
         getLists(page: currentPage)
     }
}

// MARK: - CollectionViewModelProtocol Implementation
extension CollectionViewModel: CollectionViewModelProtocol {
    func getList() {
        currentPage = 1
        getLists(page: currentPage)
    }
}
