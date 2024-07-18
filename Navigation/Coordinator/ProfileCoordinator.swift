import UIKit

// Координатор для модуля профиля
class ProfileCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(systemName: "person"), tag: 1)
    }

    // Запуск координатора профиля
    func start() {
        // Создание и настройка ProfileViewController
        let profileVC = ProfileViewController()
        // Установка координатора
        profileVC.coordinator = self
        // Пуш представления на стек навигации
        navigationController.pushViewController(profileVC, animated: false)
    }
}

