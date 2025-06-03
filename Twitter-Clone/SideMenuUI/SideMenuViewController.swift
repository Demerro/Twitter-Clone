import UIKit

final class SideMenuViewController: UIViewController {
    
    private lazy var collectionViewDataSource = makeCollectionViewDiffableDataSource()
    
    let collectionView: UICollectionView = {
        var config = UICollectionLayoutListConfiguration(appearance: .grouped)
        config.headerMode = .supplementary
        config.itemSeparatorHandler = { indexPath, sectionSeparatorConfiguration in
            var config = sectionSeparatorConfiguration
            config.topSeparatorVisibility = .hidden
            config.bottomSeparatorVisibility = indexPath.row == 4 ? .visible : .hidden
            config.bottomSeparatorInsets = .zero
            return config
        }
        config.backgroundColor = .secondarySystemGroupedBackground
        let layout = UICollectionViewCompositionalLayout.list(using: config)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemBackground
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        return collectionView
    }()
    
    private(set) var items: [Item] = [
        Item(title: "Profile", image: UIImage(systemName: "person")!) {},
        Item(title: "Lists", image: UIImage(systemName: "list.bullet.rectangle")!) {},
        Item(title: "Topics", image: UIImage(systemName: "ellipsis.message")!) {},
        Item(title: "Bookmarks", image: UIImage(systemName: "bookmark")!) {},
        Item(title: "Moments", image: UIImage(systemName: "bolt")!) {},
        Item(title: "Settings and privacy", image: nil) {},
        Item(title: "Help Center", image: nil) {},
    ]
    
    override func loadView() {
        view = collectionView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupCommon()
        setupSnapshot()
    }
}

extension SideMenuViewController {
    
    private func setupCommon() {
        collectionView.delegate = self
        toolbarItems = [
            UIBarButtonItem(image: UIImage(systemName: "lightbulb.max")!, style: .plain, target: nil, action: nil),
            UIBarButtonItem(systemItem: .flexibleSpace),
            UIBarButtonItem(image: UIImage(systemName: "qrcode")!, style: .plain, target: nil, action: nil),
        ]
    }
    
    private func setupSnapshot() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Item.ID>()
        snapshot.appendSections([.main])
        snapshot.appendItems(items.map(\.id))
        collectionViewDataSource.apply(snapshot, animatingDifferences: false)
    }
}

extension SideMenuViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

extension SideMenuViewController {
    
    private func makeCollectionViewCellRegistration() -> UICollectionView.CellRegistration<UICollectionViewListCell, Item> {
        .init { cell, indexPath, item in
            var config = cell.defaultContentConfiguration()
            config.text = item.title
            config.image = item.image
            config.imageProperties.tintColor = .secondaryLabel
            cell.contentConfiguration = config
        }
    }
    
    private func makeCollectionViewSectionHeaderRegistration() -> UICollectionView.SupplementaryRegistration<SideMenuHeaderView> {
        .init(elementKind: UICollectionView.elementKindSectionHeader) { supplementaryView, elementKind, indexPath in
        }
    }
    
    private func makeCollectionViewDiffableDataSource() -> UICollectionViewDiffableDataSource<Section, Item.ID> {
        let cellRegistration = makeCollectionViewCellRegistration()
        let headerRegistration = makeCollectionViewSectionHeaderRegistration()
        let dataSource = UICollectionViewDiffableDataSource<Section, Item.ID>(collectionView: collectionView) { [unowned self] collectionView, indexPath, itemIdentifier in
            collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: items[indexPath.item])
        }
        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        return dataSource
    }
}

extension SideMenuViewController {
    
    enum Section {
        case main
    }
    
    struct Item: Identifiable {
        
        let id = UUID()
        
        let title: String
        
        let image: UIImage?
        
        let actionHandler: () -> Void
    }
}
