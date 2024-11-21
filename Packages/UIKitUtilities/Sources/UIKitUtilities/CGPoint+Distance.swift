import CoreGraphics

extension CGPoint {
    
    public func distance(to other: CGPoint) -> CGFloat {
        hypot(other.x - self.x, other.y - self.y)
    }
}
