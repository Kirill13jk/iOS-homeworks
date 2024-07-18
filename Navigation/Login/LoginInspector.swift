// LoginInspector.swift

import Foundation

// Класс, реализующий протокол LoginViewControllerDelegate
class LoginInspector: LoginViewControllerDelegate {
    func check(login: String, password: String) -> Bool {
        return Checker.shared.check(login: login, password: password)
    }
}
