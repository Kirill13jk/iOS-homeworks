import UIKit

// Координатор для модуля ленты новостей
class FavoriteCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(named: "favorite"), tag: 2)
    }

    // Запуск координатора ленты новостей
    func start() {
        // Создание и настройка FeedViewController
        let favoriteVC = FavoritePostsViewController()
        // Установка координатора
        favoriteVC.coordinator = self
        // Пуш представления на стек навигации
        navigationController.pushViewController(favoriteVC, animated: false)
    }
}
