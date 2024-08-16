import UIKit

// Координатор для модуля ленты новостей
class InfoCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.tabBarItem = UITabBarItem(title: "Info", image: UIImage(named: "info"), tag: 2)
    }

    // Запуск координатора ленты новостей
    func start() {
        // Создание и настройка FeedViewController
        let infoVC = InfoViewController()
        // Установка координатора
        infoVC.coordinator = self
        // Пуш представления на стек навигации
        navigationController.pushViewController(infoVC, animated: false)
    }
}
