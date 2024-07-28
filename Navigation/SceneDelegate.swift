import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        let window = UIWindow(windowScene: windowScene)
        let tabBarController = UITabBarController()
        let navigationController = UINavigationController()
        
        let appCoordinator = AppCoordinator(navigationController: navigationController, tabBarController: tabBarController)
        self.appCoordinator = appCoordinator

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window

        appCoordinator.start()
    }
}
