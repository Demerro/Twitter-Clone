import CoreGraphics

extension CGVector {
    
    public init(from source: CGPoint = .zero, to target: CGPoint) {
        let dx = target.x - source.x
        let dy = target.y - source.y
        self = CGVector(dx: dx, dy: dy)
    }
}
