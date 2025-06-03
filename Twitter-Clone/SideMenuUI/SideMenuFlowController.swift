import UIKit

final class SideMenuFlowController: UINavigationController {
    
    private let sideMenuViewController = SideMenuViewController()
    
    init() {
        super.init(rootViewController: sideMenuViewController)
        navigationBar.isHidden = true
        isToolbarHidden = false
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
