import Foundation

// Класс LoginInspector, который будет использовать CheckerService
class LoginInspector: CheckerServiceProtocol {
    private let checkerService: CheckerServiceProtocol
    
    // Инициализация с возможностью подмены CheckerService (для тестирования)
    init(checkerService: CheckerServiceProtocol = CheckerService()) {
        self.checkerService = checkerService
    }
    
    // Метод для проверки учетных данных
    func checkCredentials(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        checkerService.checkCredentials(email: email, password: password, completion: completion)
    }
    
    // Метод для регистрации нового пользователя
    func signUp(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        checkerService.signUp(email: email, password: password, completion: completion)
    }
}
