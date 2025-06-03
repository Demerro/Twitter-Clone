import UIKit
import OrderedCollections

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
    
    private(set) var sections: OrderedDictionary<Section.ID, Section> = [
        Section(type: .main, title: "", items: [
            Item(type: .profile, title: "Profile", image: UIImage(systemName: "person")!) {},
            Item(type: .lists, title: "Lists", image: UIImage(systemName: "list.bullet.rectangle")!) {},
            Item(type: .topics, title: "Topics", image: UIImage(systemName: "ellipsis.message")!) {},
            Item(type: .bookmarks, title: "Bookmarks", image: UIImage(systemName: "bookmark")!) {},
            Item(type: .moments, title: "Moments", image: UIImage(systemName: "bolt")!) {},
            Item(type: .settingsAndPrivacy, title: "Settings and privacy", image: nil) {},
            Item(type: .helpCenter, title: "Help Center", image: nil) {},
        ])
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
        var snapshot = NSDiffableDataSourceSnapshot<Section.ID, Item.ID>()
        snapshot.appendSections(Array(sections.keys))
        for sectionIdentifier in snapshot.sectionIdentifiers {
            guard let section = sections[sectionIdentifier] else { return }
            snapshot.appendItems(Array(section.items.keys), toSection: sectionIdentifier)
        }
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
    
    private func makeCollectionViewDiffableDataSource() -> UICollectionViewDiffableDataSource<Section.ID, Item.ID> {
        let cellRegistration = makeCollectionViewCellRegistration()
        let headerRegistration = makeCollectionViewSectionHeaderRegistration()
        let dataSource = UICollectionViewDiffableDataSource<Section.ID, Item.ID>(collectionView: collectionView) { [unowned self] collectionView, indexPath, itemIdentifier in
            guard let sectionIdentifier = collectionViewDataSource.sectionIdentifier(for: indexPath.section),
                  let itemIdentifier = collectionViewDataSource.itemIdentifier(for: indexPath),
                  let section = sections[sectionIdentifier],
                  let item = section.items[itemIdentifier]
            else { preconditionFailure() }
            return collectionView.dequeueConfiguredReusableCell(using: cellRegistration, for: indexPath, item: item)
        }
        dataSource.supplementaryViewProvider = { collectionView, elementKind, indexPath in
            collectionView.dequeueConfiguredReusableSupplementary(using: headerRegistration, for: indexPath)
        }
        return dataSource
    }
}

extension SideMenuViewController {
    
    struct Section: Identifiable {
        
        let id = UUID()
        
        let type: SectionType
        
        let title: String
        
        let items: OrderedDictionary<ID, Item>
    }
    
    enum SectionType {
        case main
    }
}

extension SideMenuViewController {
    
    struct Item: Identifiable {
        
        let id = UUID()
        
        let type: ItemType
        
        let title: String
        
        let image: UIImage?
        
        let actionHandler: () -> Void
    }
    
    enum ItemType {
        case profile
        case lists
        case topics
        case bookmarks
        case moments
        case settingsAndPrivacy
        case helpCenter
    }
}
