import Foundation

// Модель данных для управления данными ленты
class FeedModel {
    // Метод для получения элементов ленты
    func getFeedItems() -> [FeedItem] {
        // Возвращаем фиктивные данные
        return [
            FeedItem(title: "Post 1", description: "Description 1"),
            FeedItem(title: "Post 2", description: "Description 2")
        ]
    }

    // Метод для проверки введенного слова
    func check(word: String) -> Bool {
        // Простая проверка: если слово "example", возвращаем true
        return word.lowercased() == "example"
    }
}

// Структура данных для элемента ленты
struct FeedItem {
    let title: String // Заголовок поста
    let description: String // Описание поста
}
