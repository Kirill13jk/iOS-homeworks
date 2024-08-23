import UIKit
import Foundation

enum AppConfiguration {
    case people(URL)
    case starships(URL)
    case planets(URL)
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var appCoordinator: AppCoordinator?
    
    var appConfiguration: AppConfiguration? // Переменная для хранения

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        // Массив Url для использования конфигурации
        let urls = [
            URL(string: "https://swapi.dev/api/people/8")!,
            URL(string: "https://swapi.dev/api/starships/3")!,
            URL(string: "https://swapi.dev/api/planets/5")!
        ]
        
        //  Генерируем случайный индекс для выбора конфигурации
        let randomIndex = Int.random(in: 0..<urls.count)
        
        // Используем оператор switch для инициализации appConfiguration
        switch randomIndex {
        case 0:
            appConfiguration = .people(urls[randomIndex]) // Инициализируем конфигурацию для people
        case 1:
            appConfiguration = .starships(urls[randomIndex]) // для starships
        case 2:
            appConfiguration = .planets(urls[randomIndex]) // для planets
        default:
            break
        }
        
        // Проверяем что конфигурации инициализирова
        if let configuration = appConfiguration {
            // Вызываем метод request для выполнения сетевого запроса
            NetworkService.request(for: configuration)
        }

        let window = UIWindow(windowScene: windowScene)
        let tabBarController = UITabBarController()
        let navigationController = UINavigationController()
        
        let appCoordinator = AppCoordinator(navigationController: navigationController, tabBarController: tabBarController)
        self.appCoordinator = appCoordinator

        window.rootViewController = navigationController
        window.makeKeyAndVisible()
        self.window = window

        appCoordinator.start()
    }
}
