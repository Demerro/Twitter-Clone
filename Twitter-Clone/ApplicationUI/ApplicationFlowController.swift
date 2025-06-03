import UIKit

final class ApplicationFlowController: UIViewController {
    
    private lazy var mainViewController: UIViewController = {
        $0.view.backgroundColor = .systemPurple
        return $0
    }(UIViewController())
    
    private lazy var sideMenuFlowController = SideMenuFlowController()
    
    private lazy var applicationFlowView = ApplicationFlowView(frame: .zero, mainFlow: { mainViewController.view }, sideMenuFlow: { sideMenuFlowController.view })
    
    override func loadView() {
        view = applicationFlowView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addChild(mainViewController)
        addChild(sideMenuFlowController)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainViewController.didMove(toParent: self)
        sideMenuFlowController.didMove(toParent: self)
    }
}
