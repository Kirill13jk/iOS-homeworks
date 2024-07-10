import Foundation

// Модель данных для FeedViewController
class FeedModel {
    private let secretWord = "password" // Загаданное слово
    
    // Метод проверки введенного слова на соответствие загаданному
    func check(word: String) -> Bool {
        return word.lowercased() == secretWord.lowercased()
    }
}
