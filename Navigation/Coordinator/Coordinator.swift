import UIKit

// Протокол, который будут реализовывать все координаторы
protocol Coordinator {
    // Массив дочерних координаторов для управления вложенными потоками навигации
    var childCoordinators: [Coordinator] { get set }
    // Навигационный контроллер для управления стеком представлений
    var navigationController: UINavigationController { get set }

    // Метод, с которого начинается навигация координатора
    func start()
}
