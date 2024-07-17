import UIKit

// Основной координатор приложения, управляющий UITabBarController
class AppCoordinator: Coordinator {
    // Массив дочерних координаторов
    var childCoordinators = [Coordinator]()
    // Навигационный контроллер
    var navigationController: UINavigationController
    // TabBar контроллер, отображающий вкладки
    var tabBarController: UITabBarController

    // Инициализация с навигационным и таб бар контроллерами
    init(navigationController: UINavigationController, tabBarController: UITabBarController) {
        self.navigationController = navigationController
        self.tabBarController = tabBarController
    }

    // Запуск координатора
    func start() {
        // Инициализация и запуск координатора профиля
        let profileCoordinator = ProfileCoordinator(navigationController: UINavigationController())
        profileCoordinator.start()
        // Добавление в массив дочерних координаторов
        childCoordinators.append(profileCoordinator)

        // Инициализация и запуск координатора ленты новостей
        let feedCoordinator = FeedCoordinator(navigationController: UINavigationController())
        feedCoordinator.start()
        // Добавление в массив дочерних координаторов
        childCoordinators.append(feedCoordinator)

        // Установка viewControllers для tabBarController
        tabBarController.viewControllers = [
            profileCoordinator.navigationController,
            feedCoordinator.navigationController
        ]
    }
}
