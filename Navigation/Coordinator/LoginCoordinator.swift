import UIKit

// Координатор для управления логикой отображения LoginViewController
class LoginCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var loginFactory: LoginFactory
    weak var parentCoordinator: AppCoordinator?

    init(navigationController: UINavigationController, loginFactory: LoginFactory) {
        self.navigationController = navigationController
        self.loginFactory = loginFactory
    }

    // Запуск координатора авторизации
    func start() {
        let loginViewController = LoginViewController()
        loginViewController.coordinator = self
        loginViewController.loginDelegate = loginFactory.makeLoginInspector()
        navigationController.pushViewController(loginViewController, animated: true)
    }

    // Завершение авторизации и уведомление родительского координатора
    func didFinishLogin() {
        parentCoordinator?.didFinishLogin()
    }
}
