import UIKit

// Не смог использовать структуру LoginInspector так как икскод ругался, клас реализующий протокол LoginViewControllerDelegate
class LoginInspector: LoginViewControllerDelegate {
    func check(login: String, password: String) -> Bool {
        return Checker.shared.check(login: login, password: password)
    }
}

