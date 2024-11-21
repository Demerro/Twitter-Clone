import UIKit
import UIKitUtilities
import SwiftUtilities

final class ApplicationFlowView: UIView {
    
    private var state = State.idle(at: .left)
    
    var mainFlowView: UIView { mainFlowProvider() }
    
    var sideMenuFlowView: UIView { sideMenuFlowProvider() }
    
    private let mainFlowProvider: () -> UIView
    
    private let sideMenuFlowProvider: () -> UIView
    
    init(
        frame: CGRect,
        @_implicitSelfCapture mainFlow mainFlowProvider: @escaping () -> UIView,
        @_implicitSelfCapture sideMenuFlow sideMenuFlowProvider: @escaping () -> UIView
    ) {
        self.mainFlowProvider = mainFlowProvider
        self.sideMenuFlowProvider = sideMenuFlowProvider
        super.init(frame: frame)
        setupCommon()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        mainFlowView.frame = mainFlowViewFrame(for: .left)
        sideMenuFlowView.frame = sideMenuFlowViewFrame(for: .left)
    }
}

extension ApplicationFlowView {
    
    private func setupCommon() {
        backgroundColor = .secondarySystemGroupedBackground
        addSubview(mainFlowView)
        addSubview(sideMenuFlowView)
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panHandler)))
    }
}

extension ApplicationFlowView {
    
    @objc
    private func panHandler(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began:
            beginInteractiveTransition(with: gestureRecognizer)
        case .changed:
            updateInteractiveTransition(with: gestureRecognizer)
        case .ended, .cancelled:
            endInteractiveTransition(with: gestureRecognizer)
        default:
            break
        }
    }
}

extension ApplicationFlowView {
    
    private func beginInteractiveTransition(with gestureRecognizer: UIPanGestureRecognizer) {
        switch state {
        case .idle:
            break
        case .interaction:
            return
        case .animating(to: _, using: let animator):
            animator.stopAnimation(true)
        }
        state = .interaction(with: gestureRecognizer, sideMenuFlowViewStartPoint: sideMenuFlowView.center, mainFlowViewStartPoint: mainFlowView.center)
        sideMenuFlowView.isUserInteractionEnabled = false
    }
    
    private func updateInteractiveTransition(with gestureRecognizer: UIPanGestureRecognizer) {
        guard case .interaction(
            with: gestureRecognizer,
            sideMenuFlowViewStartPoint: let sideMenuFlowViewStartPoint,
            mainFlowViewStartPoint: let mainFlowViewStartPoint
        ) = state else { return }
        
        let translation = gestureRecognizer.translation(in: self)
        let vector = CGVector(to: translation)
        let scale = traitCollection.displayScale
        
        let sideMenuFlowViewCenter = round((sideMenuFlowViewStartPoint.x + vector.dx) * scale) / scale
        let mainFlowViewCenter = round((mainFlowViewStartPoint.x + vector.dx) * scale) / scale
        
        let sideMenuFlowViewRightFrame = sideMenuFlowViewFrame(for: .right)
        let sideMenuFlowViewLeftFrame = sideMenuFlowViewFrame(for: .left)
        let mainFlowViewRightFrame = mainFlowViewFrame(for: .right)
        
        sideMenuFlowView.center.x = max(
            rubberBandClamp(sideMenuFlowViewCenter, dim: sideMenuFlowViewRightFrame.width, limits: -.infinity...sideMenuFlowViewRightFrame.center.x),
            sideMenuFlowViewLeftFrame.center.x
        )
        mainFlowView.center.x = max(
            rubberBandClamp(mainFlowViewCenter, dim: sideMenuFlowViewRightFrame.width, limits: -.infinity...mainFlowViewRightFrame.center.x),
            frame.center.x
        )
    }
    
    private func endInteractiveTransition(with gestureRecognizer: UIPanGestureRecognizer) {
        guard case .interaction(with: gestureRecognizer, sideMenuFlowViewStartPoint: _, mainFlowViewStartPoint: _) = state else { return }
        
        let velocity = CGVector(to: gestureRecognizer.velocity(in: self))
        let currentCenter = sideMenuFlowView.center
        let endpoint = intendedEndpoint(with: velocity, from: currentCenter)
        let sideMenuFlowViewTargetCenter = sideMenuFlowViewFrame(for: endpoint).center
        let mainFlowViewTargetCenter = mainFlowViewFrame(for: endpoint).center
        
        let spring = DampedHarmonicSpring(dampingRatio: 0.86, frequencyResponse: 0.15)
        let timingParameters = spring.timingFunction(withInitialVelocity: velocity, from: &sideMenuFlowView.center, to: sideMenuFlowViewTargetCenter, context: self)
        
        let animator = UIViewPropertyAnimator(duration: 0.0, timingParameters: timingParameters)
        animator.addAnimations { [unowned self] in
            sideMenuFlowView.center.x = sideMenuFlowViewTargetCenter.x
            mainFlowView.center.x = mainFlowViewTargetCenter.x
        }
        animator.addCompletion { [unowned self] _ in
            state = .idle(at: endpoint)
            sideMenuFlowView.isUserInteractionEnabled = true
        }
        
        state = .animating(to: endpoint, using: animator)
        
        animator.startAnimation()
    }
}

extension ApplicationFlowView {
    
    private func intendedEndpoint(with velocity: consuming CGVector, from currentPosition: CGPoint) -> Endpoint {
        if velocity.dx != 0 || velocity.dy != 0 {
            let velocityInPrimaryDirection = fmax(abs(velocity.dx), abs(velocity.dy))
            velocity.dx *= abs(velocity.dx / velocityInPrimaryDirection)
            velocity.dy *= abs(velocity.dy / velocityInPrimaryDirection)
        }

        let projectedPosition = UIGestureRecognizer.project(velocity, onto: currentPosition)
        let endpoint = Endpoint.allCases.min(by: { projectedPosition.distance(to: sideMenuFlowViewFrame(for: $0).center) })!

        return endpoint
    }
}

extension ApplicationFlowView {
    
    private func sideMenuFlowViewFrame(for endpoint: Endpoint) -> CGRect {
        switch endpoint {
        case .left:
            CGRect(x: -frame.width * 0.8, y: frame.minY, width: frame.width * 0.8, height: frame.height)
        case .right:
            CGRect(origin: frame.origin, size: CGSize(width: frame.width * 0.8, height: frame.height))
        }
    }
    
    private func mainFlowViewFrame(for endPoint: Endpoint) -> CGRect {
        switch endPoint {
        case .left:
            frame
        case .right:
            CGRect(origin: CGPoint(x: frame.width * 0.8, y: frame.minY), size: frame.size)
        }
    }
}

extension ApplicationFlowView {
    
    private enum Endpoint: CaseIterable {
        case left
        case right
    }
    
    private enum State {
        case idle(at: Endpoint)
        case interaction(with: UIPanGestureRecognizer, sideMenuFlowViewStartPoint: CGPoint, mainFlowViewStartPoint: CGPoint)
        case animating(to: Endpoint, using: UIViewPropertyAnimator)
    }
}
