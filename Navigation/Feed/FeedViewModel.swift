import Foundation
import UIKit

// ViewModel для управления данными ленты
class FeedViewModel {
    // Экземпляр модели данных
    private let model = FeedModel()
    
    // Массив элементов ленты
    var feedItems: [FeedItem] = []
    
    // Метод для загрузки данных ленты
    func fetchFeedData(completion: @escaping () -> Void) {
        // Получаем данные из модели
        feedItems = model.getFeedItems()
        // Вызываем completion для уведомления об окончании загрузки
        completion()
    }
    
    // Метод для проверки введенного слова и возврата результата
    func checkGuess(woed: String) -> (String, UIColor) {
        // Проверяем слово через модель
        if model.check(word: woed) {
            // Если слово верное, возвращаем сообщение и цвет
            return ("Correct!", .green)
        } else {
            // Если слово неверное, возвращаем другое сообщение и цвет
            return ("Wrong, try again.", .red)
        }
    }
}
