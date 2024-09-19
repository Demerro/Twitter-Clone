import UIKit
import TwitterHomeUI
import TwitterTrendsUI
import TwitterNotificationsUI
import TwitterMessagesUI

public final class MainFlowController: UITabBarController {
    
    private let homeFlowController = HomeFlowController()
    
    private let trendsFlowController = TrendsFlowController()
    
    private let notificationsFlowController = NotificationsFlowController()
    
    private let messagesFlowController = MessagesFlowController()
    
    public init() {
        super.init(nibName: nil, bundle: nil)
        viewControllers = [
            homeFlowController,
            trendsFlowController,
            notificationsFlowController,
            messagesFlowController
        ]
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
}
