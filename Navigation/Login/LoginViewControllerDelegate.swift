// LoginViewControllerDelegate.swift

import Foundation

// Протокол делегата для проверки логина и пароля
protocol LoginViewControllerDelegate: AnyObject {
    func check(login: String, password: String) -> Bool
}
