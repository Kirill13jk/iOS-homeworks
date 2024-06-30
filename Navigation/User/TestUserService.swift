import UIKit

// Тестовый сервис для получения данных пользователя
class TestUserService: UserService {
    // Массив пользователей, используемый для тестирования
    private let users = [
        User(login: "admin", fullName: "Admin User", avatar: UIImage(named: "avatar") ?? UIImage(), status: "Admin status")
    ]
    
    // Метод для получения пользователя по логину
    func getUser(login: String) -> User? {
        // Возвращаем первого пользователя, у которого логин совпадает с запрашиваемым без учета регистра
        return users.first { $0.login.caseInsensitiveCompare(login) == .orderedSame }
    }
}

