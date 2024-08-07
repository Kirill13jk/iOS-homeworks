import Foundation

// Обьявляем перечисление AppConfiguration для хранения различный конфигурация API
enum AppConfiguration {
    case people(URL)
    case starships(URL)
    case planets(URL)
}

struct NetworkService {
    // статический метод repuest принимает параметр типа AppConfiguration
    static func request(for configuration: AppConfiguration) {
        let urlString: String // Обьявляем переменую для хранения строки URL
        
        // Используем оператор switch для извлечения URL из конфигурации
        switch configuration {
        case .people(let url):
            urlString = url.absoluteString // Присваем значение URL для people
        case .starships(let url):
            urlString = url.absoluteString //для starships
        case .planets(let url):
            urlString = url.absoluteString // для planets
        }
        
        // Преобразуем строку URL в обьект URL
        guard let url = URL(string: urlString) else { return }
        
        // Создаем задачу URLSession для выполнения сетевого запроса
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
                
            // Проверяем наличие ошибки
            if let error = error {
                print("Error: \(error.localizedDescription)") // Выводим сообщение об ошибки
                return
            }
            
            // Преобразуем ответ в HTTPURLResponse для извлечения статуса и заголовка
            guard let httpResponse = response as? HTTPURLResponse else { return }
            print("Status Code: \(httpResponse.statusCode)") // Выводим статус код ответа
            print("Headers: \(httpResponse.allHeaderFields)") // Выводим заголовки ответа
            
            // Провереям наличие данных в ответе
            if let data = data {
                // Преобразуем данные в строке и выводим их
                print("Data: \(String(data: data, encoding: .utf8) ?? "No data")")
            }
        }
                      
        // Запускаем задачу
        task.resume()
    }
}
