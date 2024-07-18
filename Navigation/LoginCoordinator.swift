import UIKit

// Координатор для управления логикой отображения LoginViewController
class LoginCoordinator: Coordinator {
    var childCoordinators = [Coordinator]()
    var navigationController: UINavigationController
    var loginFactory: LoginFactory

    init(navigationController: UINavigationController, loginFactory: LoginFactory) {
        self.navigationController = navigationController
        self.loginFactory = loginFactory
    }

    func start() {
        let loginViewController = LoginViewController()
        loginViewController.coordinator = self
        loginViewController.loginDelegate = loginFactory.makeLoginInspector()
        navigationController.pushViewController(loginViewController, animated: true)
    }

    func didFinishLogin() {
        // Логика завершения авторизации и переход к другому координатору, если нужно
    }
}
