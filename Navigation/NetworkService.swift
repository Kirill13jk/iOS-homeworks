import Foundation

// Протокол, определяющий интерфейс для сетевых сервисов.
protocol APIService {
    func fetchData<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void)
}

struct NetworkService {
    static func request(for configuration: AppConfiguration) {
        // Реализация сетевого запроса
        // Пример:
        print("Requesting data for configuration: \(configuration)")
        // Здесь должен быть ваш код для выполнения сетевого запроса
    }
}

// Реализация сетевого менеджера, который управляет сетевыми запросами.
class NetworkManager: APIService {
    // Универсальный метод для загрузки данных из сети и их декодирования в указанный тип.
    func fetchData<T: Decodable>(url: URL, completion: @escaping (Result<T, Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Обрабатываем возможную ошибку.
            if let error = error {
                completion(.failure(error))
                return
            }
            
            // Проверяем, что данные были получены.
            guard let data = data else {
                completion(.failure(NSError(domain: "No data", code: -1, userInfo: nil)))
                return
            }
            
            do {
                // Декодируем полученные данные в указанный тип модели.
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error)) // Обрабатываем возможную ошибку декодирования.
            }
        }
        task.resume() // Запускаем задачу.
    }
}
