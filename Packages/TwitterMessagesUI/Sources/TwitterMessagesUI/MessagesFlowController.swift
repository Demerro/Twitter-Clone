import UIKit

public final class MessagesFlowController: UINavigationController {
    
    private let messagesViewController = MessagesViewController()
    
    public init() {
        super.init(rootViewController: messagesViewController)
        tabBarItem = UITabBarItem(title: nil, image: UIImage(systemName: "envelope")!, selectedImage: UIImage(systemName: "envelope.fill")!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
