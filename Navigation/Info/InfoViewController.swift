import UIKit
import Foundation

struct Todo: Codable {
    let userId: Int
    let id: Int
    let title: String
    let completed: Bool
}


// Класс контроллера для отображения информации.
class InfoViewController: UIViewController {
    weak var coordinator: InfoCoordinator?
    
    // Экземпляр NetworkManager для управления сетевыми запросами.
    let networkManager = NetworkManager()
    
    // UILabel для отображения периода обращения планеты.
    var orbitalPeriodLabel: UILabel!
    
    // UILabel для отображения названия задачи.
    var titleLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        // Настраиваем метки для отображения данных.
        setupLabels()
        
        // Запускаем загрузку данных о планете и задачах.
        fetchPlanetData()
        fetchTodoData()
        
        // Создаем и добавляем кастомную кнопку на экран.
        setupButton()
    }
    
    // Универсальный метод для загрузки данных о планете.
    func fetchPlanetData() {
        guard let url = URL(string: "https://swapi.dev/api/planets/1") else { return }
        
        networkManager.fetchData(url: url) { (result: Result<Planet, Error>) in
            switch result {
            case .success(let planet):
                // Обновляем UI на главном потоке.
                DispatchQueue.main.async {
                    self.orbitalPeriodLabel.text = "Orbital Period: \(planet.orbitalPeriod) days"
                }
            case .failure(let error):
                print("Failed to fetch planet data: \(error.localizedDescription)")
            }
        }
    }
    
    // Универсальный метод для загрузки данных о задаче.
    func fetchTodoData() {
        guard let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1") else { return }
        
        networkManager.fetchData(url: url) { (result: Result<Todo, Error>) in
            switch result {
            case .success(let todo):
                // Обновляем UI на главном потоке.
                DispatchQueue.main.async {
                    self.titleLabel.text = "Title: \(todo.title)"
                }
            case .failure(let error):
                print("Failed to fetch todo data: \(error.localizedDescription)")
            }
        }
    }
    
    // Настройка UILabel для отображения данных.
    private func setupLabels() {
        orbitalPeriodLabel = UILabel()
        orbitalPeriodLabel.textAlignment = .center
        orbitalPeriodLabel.textColor = .black
        orbitalPeriodLabel.frame = CGRect(x: 20, y: 100, width: view.frame.width - 40, height: 50)
        view.addSubview(orbitalPeriodLabel)
        
        titleLabel = UILabel()
        titleLabel.textAlignment = .center
        titleLabel.textColor = .black
        titleLabel.frame = CGRect(x: 20, y: 160, width: view.frame.width - 40, height: 50)
        view.addSubview(titleLabel)
    }
    
    // Настройка кнопки и добавление её на экран.
    private func setupButton() {
        let button = CustomButton(
            title: "View Message",
            titleColor: .white,
            backgroundColor: .systemBlue,
            font: UIFont.boldSystemFont(ofSize: 16),
            action: {
                self.showAlert()
            }
        )
        
        view.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            button.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            button.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            button.widthAnchor.constraint(equalToConstant: 200),
            button.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
    // Метод для отображения сообщения в UIAlertController.
    @objc func showAlert() {
        let alertController = UIAlertController(title: "Hello World!", message: "I love you", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Action 1", style: .default) { _ in
            print("Action 1")
        }
        let action2 = UIAlertAction(title: "Action 2", style: .default) { _ in
            print("Action 2")
        }
        alertController.addAction(action1)
        alertController.addAction(action2)
        present(alertController, animated: true, completion: nil)
    }
}
