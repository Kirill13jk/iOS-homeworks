import UIKit

// Координатор для модуля ленты новостей
class FeedCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.tabBarItem = UITabBarItem(title: "Feed", image: UIImage(systemName: "house"), tag: 2)
    }

    // Запуск координатора ленты новостей
    func start() {
        // Создание и настройка FeedViewController
        let feedVC = FeedViewController()
        // Установка координатора
        feedVC.coordinator = self
        // Пуш представления на стек навигации
        navigationController.pushViewController(feedVC, animated: false)
    }
}
