import UIKit

// Координатор для модуля профиля
class ProfileCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    weak var parentCoordinator: AppCoordinator?  // Связь с родительским координатором

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.tabBarItem = UITabBarItem(title: "Profile", image: UIImage(named: "person"), tag: 1)
    }

    // Запуск координатора профиля
    func start() {
        let profileVC = ProfileViewController()
        profileVC.coordinator = self
        navigationController.pushViewController(profileVC, animated: false)
    }

    // Метод для обработки завершения сеанса
    func didFinishLogout() {
        // Сообщаем родительскому координатору, что нужно вернуться на экран входа
        parentCoordinator?.didFinishLogout()
    }
}

