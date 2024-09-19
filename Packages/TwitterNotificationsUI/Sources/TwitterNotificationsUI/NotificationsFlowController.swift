import UIKit

public final class NotificationsFlowController: UINavigationController {
    
    private let notificationsViewController = NotificationsViewController()

    public init() {
        super.init(rootViewController: notificationsViewController)
        tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "bell")!, selectedImage: UIImage(systemName: "bell.fill")!)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
