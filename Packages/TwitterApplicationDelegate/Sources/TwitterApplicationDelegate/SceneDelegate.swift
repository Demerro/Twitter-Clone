import UIKit
import TwitterApplicationUI

public final class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    public var window: UIWindow?

    public func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let window = UIWindow(windowScene: scene as! UIWindowScene)
        window.rootViewController = ApplicationFlowController()
        window.makeKeyAndVisible()
        self.window = window
    }
}
