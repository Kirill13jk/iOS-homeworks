import UIKit

// Синглтон Checker
class Checker {
    // Приватные свойства login и password
    private let login = "admin"
    private let password = "password"

    // Создаем статичную переменную для синглтона
    static let shared = Checker()

    // Приватный инициализатор, чтобы предотвратить создание новых экземпляров
    private init() {}

    // Метод проверки логина и пароля
    func check(login: String, password: String) -> Bool {
        return self.login == login && self.password == password
    }
}

