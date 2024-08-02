import UIKit

// Координатор для модуля ленты новостей
class YouTybeCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.tabBarItem = UITabBarItem(title: "YouTube", image: UIImage(named: "youtube"), tag: 2)
    }

    // Запуск координатора ленты новостей
    func start() {
        // Создание и настройка FeedViewController
        let youtubeVC = YouTubeViewController()
        // Установка координатора
        youtubeVC.coordinator = self
        // Пуш представления на стек навигации
        navigationController.pushViewController(youtubeVC, animated: false)
    }
}
