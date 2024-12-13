//
//  CollectionViewController.swift
//  List
//
//  Created by Kos on 09.12.2024.
//

//import UIKit
//
//final class CollectionViewController: UIViewController {
//    
//    //MARK: - Typealias
//    
//    typealias DataSource = UICollectionViewDiffableDataSource <Int, ListUIModel>
//    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, ListUIModel>
//    
//    //MARK: - Properties
//    private var viewModel: CollectionViewModelProtocol
//    private lazy var dataSource = makeDataSource()
//    private var expandedIndexPaths: Set<IndexPath> = []
//    private var refreshControl = UIRefreshControl()
//
//    private lazy var collectionView: UICollectionView = {
//        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
//        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
//        collectionView.backgroundColor = .clear
//        collectionView.delegate = self
//        return collectionView
//    }()
//    
//    //MARK: - Life cycle
//    init(viewModel: CollectionViewModel) {
//        self.viewModel = viewModel
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemGray2
//        navigationController?.isNavigationBarHidden = true
//        setup()
//        bindingModel()
//        viewModel.getList()
//        setupRefreshControl()
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        navigationController?.isNavigationBarHidden = true
//    }
//    
//    //MARK: - Methods
//    
//    private func setup() {
//        view.addSubviews(collectionView, translatesAutoresizingMaskIntoConstraints: false)
//        NSLayoutConstraint.activate([
//            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0),
//            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
//            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 0),
//            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 0),
//        ])
//    }
//    
//    private func createLayout() -> UICollectionViewLayout {
//        let spacing: CGFloat = 20
//        let itemSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1.0),
//            heightDimension: .fractionalHeight(1.0))
//        let item = NSCollectionLayoutItem(layoutSize: itemSize)
//        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)
//        let groupSize = NSCollectionLayoutSize(
//            widthDimension: .fractionalWidth(1.0),
//            heightDimension: .absolute(80.0))
//        let group = NSCollectionLayoutGroup.horizontal(
//            layoutSize: groupSize, subitems: [item])
//        group.interItemSpacing = .fixed(spacing)
//        let section  = NSCollectionLayoutSection(group: group)
//        section.contentInsets = NSDirectionalEdgeInsets.init(top: 0, leading: 0, bottom: 0, trailing: 0)
//        section.interGroupSpacing = 10
//        let lauout = UICollectionViewCompositionalLayout(section: section)
//        return lauout
//    }
//    
//    private func setupRefreshControl() {
//        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
//        collectionView.refreshControl = refreshControl
//    }
//    
//    private func makeDataSource() -> DataSource {
//        return DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
//            guard let cell = collectionView.dequeueReusableCell(
//                withReuseIdentifier: CollectionViewCell.identifier,
//                for: indexPath
//            ) as? CollectionViewCell else { return UICollectionViewCell() }
//            let isExpanded = self.expandedIndexPaths.contains(indexPath)
//            cell.configurationCellCollection(with: itemIdentifier, isExpanded: isExpanded)
//            return cell
//        }
//    }
//    
//    private func makeShapshot(lists: [ListUIModel]) {
//        var snapshot = Snapshot()
//        snapshot.appendSections([0])
//        snapshot.appendItems(lists, toSection: 0)
//        dataSource.apply(snapshot, animatingDifferences: true)
//        refreshControl.endRefreshing()
//    }
//    
//    private func bindingModel() {
//        viewModel.stateDidChange = { [weak self] state in
//            guard let self else { return }
//            switch state {
//            case .loading:
//                break
//            case .done(lists: let lists):
//                self.makeShapshot(lists: lists)
//            case .error(error: let error):
//                print(error)
//            }
//        }
//    }
//
//    @objc private func refreshData() {
//        viewModel.getList()
//    }
//}
//
//// MARK: - extension UICollectionViewDelegate
//extension CollectionViewController: UICollectionViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//        let scrollViewHeight = scrollView.frame.size.height
////        if contentHeight > 0 && offsetY > contentHeight - scrollViewHeight * 1.5 && !viewModel.isLoading {
////            viewModel.loadNextPage()
////        }
//        if contentHeight > 0 && offsetY > contentHeight - scrollViewHeight * 1.5 {
//            viewModel.loadNextPage()
//        }
//    }
//        
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if expandedIndexPaths.contains(indexPath) {
//            expandedIndexPaths.remove(indexPath)
//        } else {
//            expandedIndexPaths.insert(indexPath)
//        }
//        guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell else { return }
//        let item = dataSource.itemIdentifier(for: indexPath)
//        cell.configurationCellCollection(with: item!, isExpanded: expandedIndexPaths.contains(indexPath), updateTitleOnly: true)
//    }
//}

import UIKit
import Combine

final class CollectionViewController: UIViewController {
    
    // MARK: - Typealias
    typealias DataSource = UICollectionViewDiffableDataSource<Int, ListUIModel>
    typealias Snapshot = NSDiffableDataSourceSnapshot<Int, ListUIModel>

    // MARK: - Properties
    private var viewModel: CollectionViewModelProtocol
    private lazy var dataSource = makeDataSource()
    private var expandedIndexPaths: Set<IndexPath> = []
    private var cancellables = Set<AnyCancellable>()

    private lazy var collectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: createLayout())
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: CollectionViewCell.identifier)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        return collectionView
    }()

    private var refreshControl = UIRefreshControl()

    // MARK: - Life Cycle
    init(viewModel: CollectionViewModelProtocol) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray2
        navigationController?.isNavigationBarHidden = true
        setup()
        bindViewModel()
        viewModel.getList()
        setupRefreshControl()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.isNavigationBarHidden = true
    }

    // MARK: - Methods

    private func setup() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
        ])
    }

    private func createLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 20
        let itemSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .fractionalHeight(1.0)
        )
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        item.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15)

        let groupSize = NSCollectionLayoutSize(
            widthDimension: .fractionalWidth(1.0),
            heightDimension: .absolute(80.0)
        )
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
        group.interItemSpacing = .fixed(spacing)

        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)
        section.interGroupSpacing = 10

        return UICollectionViewCompositionalLayout(section: section)
    }

    private func setupRefreshControl() {
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        collectionView.refreshControl = refreshControl
    }

    private func makeDataSource() -> DataSource {
        return DataSource(collectionView: collectionView) { collectionView, indexPath, itemIdentifier in
            guard let cell = collectionView.dequeueReusableCell(
                withReuseIdentifier: CollectionViewCell.identifier,
                for: indexPath
            ) as? CollectionViewCell else { return UICollectionViewCell() }
            
            let isExpanded = self.expandedIndexPaths.contains(indexPath)
            cell.configurationCellCollection(with: itemIdentifier, isExpanded: isExpanded)
            return cell
        }
    }

    private func makeSnapshot(lists: [ListUIModel]) {
        var snapshot = Snapshot()
        snapshot.appendSections([0])
        snapshot.appendItems(lists, toSection: 0)
        dataSource.apply(snapshot, animatingDifferences: true)
        refreshControl.endRefreshing()
    }

    private func bindViewModel() {
        viewModel.statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                guard let self = self else { return }
                switch state {
                case .loading:
                    break
                case .done(let lists):
                    self.makeSnapshot(lists: lists)
                case .error(let error):
                    print(error)
                }
            }
            .store(in: &cancellables)
    }

    @objc private func refreshData() {
        viewModel.getList()
    }
}

// MARK: - UICollectionViewDelegate
extension CollectionViewController: UICollectionViewDelegate {
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//        let scrollViewHeight = scrollView.frame.size.height
//        if contentHeight > 0 && offsetY > contentHeight - scrollViewHeight * 1.5 {
//            viewModel.loadNextPage()
//        }
//    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
           let offsetY = scrollView.contentOffset.y
           let contentHeight = scrollView.contentSize.height
           let scrollViewHeight = scrollView.frame.size.height
           
           // Порог срабатывания
           if contentHeight > 0 && offsetY > contentHeight - scrollViewHeight * 1.5 {
               // Проверка, что не выполняется загрузка
               if !viewModel.isLoadingNextPage {
                   viewModel.loadNextPage()
               }
           }
       }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if expandedIndexPaths.contains(indexPath) {
            expandedIndexPaths.remove(indexPath)
        } else {
            expandedIndexPaths.insert(indexPath)
        }
        guard let cell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell else { return }
        let item = dataSource.itemIdentifier(for: indexPath)
        cell.configurationCellCollection(with: item!, isExpanded: expandedIndexPaths.contains(indexPath), updateTitleOnly: true)
    }
}



