// SceneDelegate.swift

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        
        // Создаем контроллеры для ленты и профиля пользователя
        let feedViewController = FeedViewController()
        let loginViewController = LoginViewController()
        
        // Используем фабрику для создания экземпляра LoginInspector
        let loginFactory = MyLoginFactory()
        loginViewController.loginDelegate = loginFactory.makeLoginInspector()
        
        // Создаем UINavigationController для LoginViewController
        let loginNavigationController = UINavigationController(rootViewController: loginViewController)
        
        // Настраиваем Tab Bar Item для каждого UINavigationController
        let feedNavigationController = UINavigationController(rootViewController: feedViewController)
        feedNavigationController.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "house"), selectedImage: nil)
        loginNavigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), selectedImage: nil)
        
        // Создаем и настраиваем UITabBarController
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [feedNavigationController, loginNavigationController]
        
        window.rootViewController = tabBarController
        self.window = window
        window.makeKeyAndVisible()
    }
}
