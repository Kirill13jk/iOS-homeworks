import UIKit

// Координатор для модуля ленты новостей
class FavoriteCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.tabBarItem = UITabBarItem(title: "Favorite", image: UIImage(named: "star"), tag: 2)
    }

    // Запуск координатора ленты новостей
    func start() {
        // Создание и настройка 
        let favoriteVC = FavoritesViewController()
        // Установка координатора
        favoriteVC.coordinator = self
        // Пуш представления на стек навигации
        navigationController.pushViewController(favoriteVC, animated: false)
    }
}
