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

    // Отображение основной части приложения
    private func showMain() {
        let profileCoordinator = ProfileCoordinator(navigationController: UINavigationController())
        profileCoordinator.start()
        childCoordinators.append(profileCoordinator)

        let feedCoordinator = FeedCoordinator(navigationController: UINavigationController())
        feedCoordinator.start()
        childCoordinators.append(feedCoordinator)

        tabBarController.viewControllers = [
            profileCoordinator.navigationController,
            feedCoordinator.navigationController
        ]

        navigationController.viewControllers = [tabBarController]
    }
}
