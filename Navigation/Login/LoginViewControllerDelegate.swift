// LoginViewControllerDelegate.swift

import Foundation

// Протокол для взаимодействия с LoginViewController
protocol LoginViewControllerDelegate: AnyObject {
    // Метод для проверки учетных данных
    func checkCredentials(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    // Метод для регистрации нового пользователя
    func signUp(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
}
