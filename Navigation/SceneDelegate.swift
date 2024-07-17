import UIKit

// SceneDelegate, где происходит инициализация и запуск приложения
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?

    // Метод, вызываемый при подключении сцены
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }

        // Создание основного окна приложения
        let window = UIWindow(windowScene: windowScene)
        // Создание TabBarController
        let tabBarController = UITabBarController()
        // Создание NavigationController
        let navigationController = UINavigationController()
        
        // Инициализация и запуск AppCoordinator
        let appCoordinator = AppCoordinator(navigationController: navigationController, tabBarController: tabBarController)
        self.appCoordinator = appCoordinator

        // Установка корневого контроллера окна
        window.rootViewController = tabBarController
        window.makeKeyAndVisible()
        self.window = window

        // Запуск координатора
        appCoordinator.start()
    }
}
