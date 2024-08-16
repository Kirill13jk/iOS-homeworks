import UIKit
import Foundation

// Структура для модели данных "Todo", которая будет использоваться для декодирования JSON ответа.
// Эта структура соответствует JSON-данным, полученным из API: https://jsonplaceholder.typicode.com/todos/1
struct Todo: Codable {
    let userId: Int      // Идентификатор пользователя, связанного с задачей.
    let id: Int          // Уникальный идентификатор задачи.
    let title: String    // Название задачи.
    let completed: Bool  // Статус выполнения задачи.
}

// Класс контроллера для отображения информации.
class InfoViewController: UIViewController {
    // Опциональная ссылка на координатор для управления навигацией. Используется в архитектуре Coordinator.
    weak var coordinator: InfoCoordinator?
    
    // UILabel для отображения периода обращения планеты.
    var orbitalPeriodLabel: UILabel!
    
    // UILabel для отображения названия задачи.
    var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Устанавливаем цвет фона представления на системный цвет фона.
        view.backgroundColor = .systemBackground
        
        // Настраиваем UILabel для отображения данных о периоде обращения планеты.
        orbitalPeriodLabel = UILabel()
        orbitalPeriodLabel.textAlignment = .center // Центрируем текст в метке.
        orbitalPeriodLabel.textColor = .black      // Устанавливаем черный цвет текста.
        orbitalPeriodLabel.frame = CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 50) // Устанавливаем положение и размеры метки.
        view.addSubview(orbitalPeriodLabel)        // Добавляем UILabel на экран.
        
        // Запускаем загрузку данных о планете.
        fetchPlanetData()
        
        // Настраиваем UILabel для отображения названия задачи.
        titleLabel = UILabel()
        titleLabel.textAlignment = .center // Центрируем текст в метке.
        titleLabel.textColor = .black      // Устанавливаем черный цвет текста.
        titleLabel.frame = CGRect(x: 20, y: 160, width: view.frame.width - 40, height: 50) // Устанавливаем положение и размеры метки.
        view.addSubview(titleLabel)        // Добавляем UILabel на экран.
        
        // Запускаем загрузку данных о задаче.
        fetchData()
        
        // Создаем кастомную кнопку и добавляем её на экран.
        let button = CustomButton(
            title: "View Message",            // Заголовок кнопки.
            titleColor: .white,               // Цвет текста кнопки.
            backgroundColor: .systemBlue,     // Цвет фона кнопки.
            font: UIFont.boldSystemFont(ofSize: 16), // Шрифт текста кнопки.
            action: {
                self.showAlert() // Действие при нажатии на кнопку.
            }
        )
        
        view.addSubview(button) // Добавляем кнопку на экран.
        button.translatesAutoresizingMaskIntoConstraints = false // Отключаем автоматические ограничения для кнопки.
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor), // Центрируем кнопку по горизонтали.
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor), // Центрируем кнопку по вертикали.
            button.widthAnchor.constraint(equalToConstant: 200),          // Устанавливаем ширину кнопки.
            button.heightAnchor.constraint(equalToConstant: 50)           // Устанавливаем высоту кнопки.
        ])
    }
    
    // Метод для выполнения сетевого запроса к API и обработки данных о планете.
    func fetchPlanetData() {
        let urlString = "https://swapi.dev/api/planets/1" // URL-адрес для получения данных о планете Татуин.
        guard let url = URL(string: urlString) else {
            print("Invalid URL") // Проверяем, что URL валиден. Если нет, выводим сообщение.
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error.localizedDescription)") // Если произошла ошибка, выводим её в консоль.
                return
            }
            
            if let data = data {
                // Вывод полного JSON для отладки. Это полезно, чтобы убедиться, что данные приходят правильно.
                if let jsonString = String(data: data, encoding: .utf8) {
                    print("Full JSON response: \(jsonString)")
                }
                
                do {
                    let planet = try JSONDecoder().decode(Planet.self, from: data) // Декодируем JSON в объект Planet.
                    
                    // Проверка данных: выводим период обращения в консоль.
                    print("Orbital Period: \(planet.orbitalPeriod) days")
                    
                    // Обновляем UI на главном потоке, чтобы отобразить период обращения планеты.
                    DispatchQueue.main.async {
                        self.orbitalPeriodLabel.text = "Orbital Period: \(planet.orbitalPeriod) days"
                        self.orbitalPeriodLabel.backgroundColor = .yellow // Для проверки видимости метки.
                        self.orbitalPeriodLabel.textColor = .red // Устанавливаем яркий цвет текста для заметности.
                    }
                } catch {
                    print("Failed to decode JSON: \(error.localizedDescription)") // Если не удалось декодировать JSON, выводим ошибку.
                }
            } else {
                print("No data received") // Если данные не были получены, выводим сообщение.
            }
        }
        
        task.resume() // Запускаем задачу.
    }


    // Метод для выполнения сетевого запроса к API и обработки данных о задаче.
    func fetchData() {
        let urlString = "https://jsonplaceholder.typicode.com/todos/1" // URL-адрес для получения данных о задаче.
        guard let url = URL(string: urlString) else { return } // Проверяем, что URL валиден.
        
        // Создаем задачу URLSession для выполнения сетевого запроса.
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            // Проверяем наличие ошибки.
            if let error = error {
                print("Error: \(error.localizedDescription)") // Если произошла ошибка, выводим её в консоль.
                return
            }
            
            // Проверяем, что данные были получены.
            guard let data = data else {
                print("No data received") // Если данные не были получены, выводим сообщение.
                return
            }
            
            do {
                // Преобразуем полученные данные в объект JSON.
                let jsonObject = try JSONSerialization.jsonObject(with: data, options: [])
                
                // Преобразуем JSON в словарь и извлекаем значение поля title.
                if let jsonDict = jsonObject as? [String: Any], let title = jsonDict["title"] as? String {
                    // Обновляем UI на главном потоке, чтобы отобразить название задачи.
                    DispatchQueue.main.async {
                        self.titleLabel.text = "Title: \(title)"
                    }
                } else {
                    print("JSON is not in expected format") // Если JSON имеет неверный формат, выводим сообщение.
                }
            } catch {
                print("Failed to decode JSON: \(error.localizedDescription)") // Если не удалось декодировать JSON, выводим ошибку.
            }
        }
        
        task.resume() // Запускаем задачу.
    }
    
    // Метод для отображения сообщения в UIAlertController.
    @objc func showAlert() {
        let alertController = UIAlertController(title: "Hello World!", message: "I love you", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Action 1", style: .default) { _ in
            print("Action 1") // Выводим сообщение в консоль при выборе Action 1.
        }
        let action2 = UIAlertAction(title: "Action 2", style: .default) { _ in
            print("Action 2") // Выводим сообщение в консоль при выборе Action 2.
        }
        alertController.addAction(action1)
        alertController.addAction(action2)
        present(alertController, animated: true, completion: nil) // Отображаем UIAlertController.
    }
}
