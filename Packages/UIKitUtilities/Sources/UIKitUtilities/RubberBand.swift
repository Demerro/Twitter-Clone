import Foundation
import SwiftUtilities

@inlinable
public func rubberBandClamp(_ x: CGFloat, coeff: CGFloat, dim: CGFloat) -> CGFloat {
    (1.0 - (1.0 / (x * coeff / dim + 1.0))) * dim
}

@inlinable
public func rubberBandClamp(_ x: CGFloat, coeff: CGFloat = 0.55, dim: CGFloat, limits: ClosedRange<CGFloat>) -> CGFloat {
    let clampedX = clamp(x, min: limits.lowerBound, max: limits.upperBound)
    let diff = abs(x - clampedX)
    let sign: CGFloat = clampedX > x ? -1 : 1
    return clampedX + sign * rubberBandClamp(diff, coeff: coeff, dim: dim)
}
