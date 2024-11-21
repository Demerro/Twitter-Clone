import UIKit

public final class SideMenuFlowController: UINavigationController {
    
    private let sideMenuViewController = SideMenuViewController()
    
    public init() {
        super.init(rootViewController: sideMenuViewController)
        navigationBar.isHidden = true
        isToolbarHidden = false
    }
    
    @available(*, unavailable)
    public required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
}
