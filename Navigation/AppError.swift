import UIKit

// Определение собственного домена ошибокчс
enum AppError: Error {
    case networkError(String) // Ошибки сети с описанием
    case authenticationError(String) // Ошибки авторизации с описание
    case validationError(String) // Ошибки валидации с описанием
}
