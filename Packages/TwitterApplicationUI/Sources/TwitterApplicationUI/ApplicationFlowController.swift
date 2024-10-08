import UIKit
import TwitterMainUI

public final class ApplicationFlowController: UIViewController {
    
    private lazy var mainFlowController = MainFlowController()
    
    private lazy var mainFlowView = ApplicationFlowView(frame: .zero, mainFlow: { mainFlowController.view })
    
    public override func loadView() {
        view = mainFlowView
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        addChild(mainFlowController)
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        mainFlowController.didMove(toParent: self)
    }
}

fileprivate final class ApplicationFlowView: UIView {
    
    private let mainFlowProvider: () -> UIView
    
    var mainFlowView: UIView { mainFlowProvider() }
    
    init(frame: CGRect, @_implicitSelfCapture mainFlow mainFlowProvider: @escaping () -> UIView) {
        self.mainFlowProvider = mainFlowProvider
        super.init(frame: frame)
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    func setupConstraints() {
        mainFlowView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(mainFlowView)
        NSLayoutConstraint.activate([
            mainFlowView.topAnchor.constraint(equalTo: topAnchor),
            mainFlowView.leadingAnchor.constraint(equalTo: leadingAnchor),
            trailingAnchor.constraint(equalTo: mainFlowView.trailingAnchor),
            bottomAnchor.constraint(equalTo: mainFlowView.bottomAnchor),
        ])
    }
}
