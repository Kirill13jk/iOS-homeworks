import UIKit

// Реальный сервис для получения данных пользователя
class CurrentUserService: UserService {
    private let user: User // Переменная для хранения текущего пользователя

    // Инициализатор, принимающий пользователя
    init(user: User) {
        self.user = user
    }

    // Метод для получения пользователя по логину
    func getUser(login: String) -> User? {
        // Возвращаем пользователя, если его логин совпадает с запрашиваемым без учета регистра
        return login.caseInsensitiveCompare(user.login) == .orderedSame ? user : nil
    }
}


