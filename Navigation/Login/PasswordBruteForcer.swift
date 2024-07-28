import Foundation

class PasswordBruteForcer {
    private let allowedCharacters = Array("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789")
    
    func bruteForce(passwordToUnlock: String, completion: @escaping (String) -> Void) {
        // Запускаем выполнение в глобальной очереди с высоким приоритетом
        DispatchQueue.global(qos: .userInitiated).async {
            let startTime = Date()  // Запоминаем время начала выполнения
            var currentPassword = ""  // Начинаем с пустого пароля
            // Продолжаем, пока текущий пароль не совпадет с заданным
            while currentPassword != passwordToUnlock {
                currentPassword = self.incrementString(currentPassword)  // Инкрементируем текущий пароль
                if currentPassword == passwordToUnlock {
                    DispatchQueue.main.async {
                        completion(currentPassword)  // Возвращаем найденный пароль на главной очереди
                    }
                    break
                }
                // Проверяем, не прошло ли больше минуты
                if Date().timeIntervalSince(startTime) > 60 {
                    print("Не удалось найти пароль менее чем за минуту.")
                    break
                }
            }
        }
    }
    
    private func incrementString(_ str: String) -> String {
        // Если строка пустая, возвращаем первый символ из разрешенных
        if str.isEmpty {
            return String(allowedCharacters[0])
        }
        
        var currentPassword = Array(str)  // Преобразуем строку в массив символов
        for i in (0..<currentPassword.count).reversed() {  // Идем по символам строки с конца
            if let index = allowedCharacters.firstIndex(of: currentPassword[i]), index < allowedCharacters.count - 1 {
                currentPassword[i] = allowedCharacters[index + 1]  // Инкрементируем символ
                return String(currentPassword)  // Возвращаем текущий пароль
            } else {
                currentPassword[i] = allowedCharacters[0]  // Устанавливаем символ на начальный
            }
        }
        
        return String(currentPassword) + String(allowedCharacters[0])  // Добавляем новый символ в конец
    }
}
