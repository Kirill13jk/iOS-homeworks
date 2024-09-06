import UIKit

// Основной координатор приложения
class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var tabBarController: UITabBarController

    init(navigationController: UINavigationController, tabBarController: UITabBarController) {
        self.navigationController = navigationController
        self.tabBarController = tabBarController
    }

    // Запуск основного координатора
    func start() {
        showLogin()
    }

    // Отображение экрана логина
    private func showLogin() {
        let loginFactory = MyLoginFactory()
        let loginCoordinator = LoginCoordinator(navigationController: navigationController, loginFactory: loginFactory)
        loginCoordinator.parentCoordinator = self
        loginCoordinator.start()
        childCoordinators.append(loginCoordinator)
    }

    // Завершение авторизации и отображение основной части приложения
    func didFinishLogin() {
        childCoordinators.removeAll { $0 is LoginCoordinator }
        showMain()
    }

    // Метод для выхода из аккаунта
    func didFinishLogout() {
        // Очищаем текущий стек представлений
        childCoordinators.removeAll()
        
        // Создаем новый экземпляр LoginViewController
        let loginFactory = MyLoginFactory()
        let loginCoordinator = LoginCoordinator(navigationController: UINavigationController(), loginFactory: loginFactory)
        loginCoordinator.parentCoordinator = self
        childCoordinators.append(loginCoordinator)
        
        loginCoordinator.start()
        
        // Находим активное окно (UIWindow)
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                window.rootViewController = loginCoordinator.navigationController
                window.makeKeyAndVisible()
            }
        }
    }

    // Отображение основной части приложения
    private func showMain() {
        let profileCoordinator = ProfileCoordinator(navigationController: UINavigationController())
        profileCoordinator.parentCoordinator = self // Устанавливаем parentCoordinator
        profileCoordinator.start()
        childCoordinators.append(profileCoordinator)

        let feedCoordinator = FeedCoordinator(navigationController: UINavigationController())
        feedCoordinator.start()
        childCoordinators.append(feedCoordinator)

        let trackCoordinator = TrackCoordinator(navigationController: UINavigationController())
        trackCoordinator.start()
        childCoordinators.append(trackCoordinator)
        
        let youtubeCoordinator = YouTubeCoordinator(navigationController: UINavigationController())
        youtubeCoordinator.start()
        childCoordinators.append(youtubeCoordinator)
        
        let infoCoordinator = InfoCoordinator(navigationController: UINavigationController())
        infoCoordinator.start()
        childCoordinators.append(infoCoordinator)
        
        let documentCoordinator = DocumentCoordinator(navigationController: UINavigationController())
        documentCoordinator.start()
        childCoordinators.append(documentCoordinator)
        
        tabBarController.viewControllers = [
            profileCoordinator.navigationController,
            feedCoordinator.navigationController,
            trackCoordinator.navigationController,
            youtubeCoordinator.navigationController,
            infoCoordinator.navigationController,
            documentCoordinator.navigationController
        ]

        navigationController.viewControllers = [tabBarController]
    }
}
