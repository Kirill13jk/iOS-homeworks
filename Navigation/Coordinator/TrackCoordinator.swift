import UIKit

// Координатор для модуля ленты новостей
class TrackCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.tabBarItem = UITabBarItem(title: "Track", image: UIImage(named: "soundwave"), tag: 2)
    }

    // Запуск координатора ленты новостей
    func start() {
        // Создание и настройка FeedViewController
        let trackVC = TrackViewController()
        // Установка координатора
        trackVC.coordinator = self
        // Пуш представления на стек навигации
        navigationController.pushViewController(trackVC, animated: false)
    }
}
