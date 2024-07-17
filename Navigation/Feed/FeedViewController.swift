import UIKit

// ViewController для отображения ленты и взаимодействия с пользователем
class FeedViewController: UIViewController {
    // Слабая ссылка на координатор для избежания циклов сильных ссылок
    weak var coordinator: FeedCoordinator?
    
    // Создаем экземпляр FeedViewModel
    private let viewModel = FeedViewModel()
    
    // Создаем текстовое поле для ввода слова
    private let guessTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your guess" // Подсказка для пользователя
        textField.borderStyle = .roundedRect // Стиль рамки
        textField.translatesAutoresizingMaskIntoConstraints = false // Отключаем автозамыкание
        return textField
    }()
    
    // Создаем кнопку для проверки введенного слова
    private lazy var checkGuessButton: CustomButton = {
        let button = CustomButton(
            title: "Check Guess", // Текст кнопки
            titleColor: .white, // Цвет текста
            backgroundColor: .systemBlue, // Цвет фона
            font: UIFont.systemFont(ofSize: 16)
        ) { [weak self] in
            // Действие при нажатии кнопки
            self?.checkGuess()
        }
        return button
    }()
    
    // Создаем метку для отображения результата проверки слова
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18) // Шрифт и размер текста
        label.translatesAutoresizingMaskIntoConstraints = false // Отключаем автозамыкание
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6 // Устанавливаем цвет фона
        
        // Создаем UIStackView для организации элементов интерфейса
        let stackView = UIStackView()
        stackView.axis = .vertical // Вертикальное расположение элементов
        stackView.spacing = 10 // Расстояние между элементами
        stackView.translatesAutoresizingMaskIntoConstraints = false // Отключаем автозамыкание
        
        // Создаем кнопки для открытия постов
        let button1 = CustomButton(
            title: "Open Post S",
            titleColor: .black,
            backgroundColor: .white,
            font: UIFont.systemFont(ofSize: 16)
        ) { [weak self] in
            // Действие при нажатии кнопки
            self?.openPost()
        }
        
        let button2 = CustomButton(
            title: "Open Post M",
            titleColor: .black,
            backgroundColor: .systemGray5,
            font: UIFont.systemFont(ofSize: 16)
        ) { [weak self] in
            // Действие при нажатии кнопки
            self?.openPost()
        }
        
        // Добавляем элементы в UIStackView
        stackView.addArrangedSubview(button1)
        stackView.addArrangedSubview(button2)
        stackView.addArrangedSubview(guessTextField)
        stackView.addArrangedSubview(checkGuessButton)
        stackView.addArrangedSubview(resultLabel)
        
        // Добавляем UIStackView на главный view
        view.addSubview(stackView)
        
        // Устанавливаем ограничения для UIStackView и кнопок
        NSLayoutConstraint.activate([
            button1.widthAnchor.constraint(equalToConstant: 200),
            button1.heightAnchor.constraint(equalToConstant: 50),
            
            button2.heightAnchor.constraint(equalToConstant: 50),
            
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        // Загружаем данные через ViewModel
        viewModel.fetchFeedData {
            // Обновляем UI после загрузки данных, если необходимо
        }
    }
    
    // Метод для проверки введенного слова
    private func checkGuess() {
        guard let guess = guessTextField.text, !guess.isEmpty else {
            // Если поле ввода пустое, отображаем сообщение об ошибке
            resultLabel.text = "Please enter a word"
            resultLabel.textColor = .red
            return
        }
        
        // Получаем результат проверки слова через ViewModel
        let result = viewModel.checkGuess(woed: guess)
        resultLabel.text = result.0
        resultLabel.textColor = result.1
    }
    
    // Метод для открытия поста
    @objc private func openPost() {
        let postViewController = PostViewController()
        navigationController?.pushViewController(postViewController, animated: true)
    }
}
