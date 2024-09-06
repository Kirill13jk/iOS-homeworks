import UIKit

// Координатор для модуля ленты новостей
class DocumentCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        self.navigationController.tabBarItem = UITabBarItem(title: "Document", image: UIImage(named: "image-alt"), tag: 2)
    }

    // Запуск координатора ленты новостей
    func start() {
        // Создание и настройка FeedViewController
        let documentVC = DocumentsViewController()
        // Установка координатора
        documentVC.coordinator = self
        // Пуш представления на стек навигации
        navigationController.pushViewController(documentVC, animated: false)
    }
}
