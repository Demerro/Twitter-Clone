import UIKit

public final class HomeFlowController: UINavigationController {
    
    private let homeViewController = HomeViewController()
    
    public init() {
        super.init(rootViewController: homeViewController)
        tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "house")!, selectedImage: UIImage(systemName: "house.fill")!)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
