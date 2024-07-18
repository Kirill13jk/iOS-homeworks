import UIKit

// Основной координатор приложения, управляющий UITabBarController
class AppCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var tabBarController: UITabBarController

    init(navigationController: UINavigationController, tabBarController: UITabBarController) {
        self.navigationController = navigationController
        self.tabBarController = tabBarController
    }

    func start() {
        showLogin() // Показать экран логина при старте приложения
    }

    private func showLogin() {
        let loginFactory = MyLoginFactory()
        let loginCoordinator = LoginCoordinator(navigationController: navigationController, loginFactory: loginFactory)
        loginCoordinator.start()
        childCoordinators.append(loginCoordinator)
    }

    func didFinishLogin() {
        childCoordinators.removeAll { $0 is LoginCoordinator }
        showMain() // Показать основную часть приложения
    }

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
