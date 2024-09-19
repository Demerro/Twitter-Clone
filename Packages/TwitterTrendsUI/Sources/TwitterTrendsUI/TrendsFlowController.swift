import UIKit

public final class TrendsFlowController: UINavigationController {
    
    private let trendsViewController = TrendsViewController()
    
    public init() {
        super.init(rootViewController: trendsViewController)
        let tabBarImage = UIImage(systemName: "magnifyingglass")!
        tabBarItem = UITabBarItem(title: nil, image: tabBarImage, selectedImage: tabBarImage)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
