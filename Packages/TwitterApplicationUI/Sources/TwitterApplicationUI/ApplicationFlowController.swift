import UIKit
import TwitterMainUI
import TwitterSideMenuUI

public final class ApplicationFlowController: UIViewController {
    
    private lazy var mainFlowController = MainFlowController()
    
    private lazy var sideMenuFlowController = SideMenuFlowController()
    
    private lazy var applicationFlowView = ApplicationFlowView(frame: .zero, mainFlow: { mainFlowController.view }, sideMenuFlow: { sideMenuFlowController.view })
    
    public override func loadView() {
        view = applicationFlowView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        addChild(mainFlowController)
        addChild(sideMenuFlowController)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainFlowController.didMove(toParent: self)
        sideMenuFlowController.didMove(toParent: self)
    }
}
