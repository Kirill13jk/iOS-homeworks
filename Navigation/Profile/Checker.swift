import UIKit

// Синглтон Checker
class Checker {
    private let login = "123456789" // Ожидаемый логин
    private let password = "123456789" // Ожидаемый пароль

    static let shared = Checker() // Синглтон

    private init() {} // Приватный инициализатор

    // Метод для проверки логина и пароля
    func check(login: String, password: String) -> Bool {
        // Проверяем логин и пароль без учета регистра
        return self.login.caseInsensitiveCompare(login) == .orderedSame &&
               self.password.caseInsensitiveCompare(password) == .orderedSame
    }
}


