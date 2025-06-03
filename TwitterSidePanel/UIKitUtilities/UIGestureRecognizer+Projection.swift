import UIKit.UIGestureRecognizerSubclass

extension UIGestureRecognizer {

    /// Calculates the value at which a property settles when intially changing
    /// with a specified velocity and some degree of friction is applied.
    ///
    /// The friction causing the property to change slower and slower and
    /// eventually come to rest is modeled after the familiar `UIScrollView`
    /// deceleration behavior.
    ///
    /// - parameter velocity: The velocity at which some property intitially
    /// changes, measured per second.
    /// - parameter position: The initial value of the property.
    /// - parameter decelerationRate: The rate at which the velocity decreases,
    /// measured as the fraction of the velocity that remains per millisecond.
    public static func project(_ velocity: CGFloat, onto position: CGFloat, decelerationRate: UIScrollView.DecelerationRate = .normal) -> CGFloat {
        let velocity = CGVector(dx: velocity, dy: .zero)
        let position = CGPoint(x: position, y: .zero)

        return self.project(velocity, onto: position).x
    }

    /// Calculates the position at which an object comes to rest when initially
    /// moving with a specified velocity and some degree of friction is applied.
    ///
    /// The friction causing the object to move slower and slower and eventually
    /// come to rest is modeled after the familiar `UIScrollView` deceleration
    /// behavior.
    ///
    /// - parameter velocity: The velocity at which the object intitially moves,
    /// measured per second.
    /// - parameter position: The initial position of the object.
    /// - parameter decelerationRate: The rate at which the velocity decreases,
    /// measured as the fraction of the velocity that remains per millisecond.
    public static func project(_ velocity: CGVector, onto position: CGPoint, decelerationRate: UIScrollView.DecelerationRate = .normal) -> CGPoint {

        // The distance traveled is the integral over the exponentially
        // decreasing velocity from `t = 0` to infinity, which comes down to a
        // constant factor in front of the initial velocity. Thus we can threat
        // the projection along each axis individually.
        let factor = -1.0 / (1000.0 * log(decelerationRate.rawValue))
        let x = position.x + factor * velocity.dx
        let y = position.y + factor * velocity.dy

        return CGPoint(x: x, y: y)
    }
}
