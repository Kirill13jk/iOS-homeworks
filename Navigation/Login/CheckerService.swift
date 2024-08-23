import FirebaseAuth

// Протокол для взаимодействия с Firebase
// Определяет методы для проверки учетных данных и регистрации нового пользователя
protocol CheckerServiceProtocol {
    // Метод для проверки учетных данных (вход)
    // Принимает email, пароль и completion блок, который возвращает результат операции (успех или ошибка)
    func checkCredentials(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
    
    // Метод для регистрации нового пользователя
    // Принимает email, пароль и completion блок, который возвращает результат операции (успех или ошибка)
    func signUp(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void)
}

// Реализация протокола CheckerServiceProtocol
// Этот класс отвечает за взаимодействие с Firebase для проверки учетных данных и регистрации пользователей
class CheckerService: CheckerServiceProtocol {
    
    // Проверка существующих учетных данных в Firebase
    // Использует метод signIn из FirebaseAuth для попытки входа с переданным email и паролем
    // Если операция успешна, возвращается .success, в противном случае — .failure с ошибкой
    func checkCredentials(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // Если произошла ошибка, возвращаем ее через completion
                completion(.failure(error))
            } else {
                // Если вход успешен, возвращаем успех через completion
                completion(.success(()))
            }
        }
    }
    
    // Регистрация нового пользователя в Firebase
    // Использует метод createUser из FirebaseAuth для создания новой учетной записи с переданным email и паролем
    // Если операция успешна, возвращается .success, в противном случае — .failure с ошибкой
    func signUp(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                // Если произошла ошибка при регистрации, возвращаем ее через completion
                completion(.failure(error))
            } else {
                // Если регистрация успешна, возвращаем успех через completion
                completion(.success(()))
            }
        }
    }
}
