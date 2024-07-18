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
        // Устанавливаем подсказку для пользователя
        textField.placeholder = "Enter your guess"
        // Устанавливаем стиль рамки
        textField.borderStyle = .roundedRect
        // Отключаем автозамыкание
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // Создаем кнопку для проверки введенного слова
    private lazy var checkGuessButton: CustomButton = {
        let button = CustomButton(
            title: "Check Guess", // Текст кнопки
            titleColor: .white, // Цвет текста
            backgroundColor: .systemBlue, // Цвет фона
            font: UIFont.systemFont(ofSize: 16) // Шрифт текста
        ) { [weak self] in
            // Действие при нажатии кнопки
            self?.checkGuess()
        }
        return button
    }()
    
    // Создаем метку для отображения результата проверки слова
    private let resultLabel: UILabel = {
        let label = UILabel()
        // Устанавливаем шрифт и размер текста
        label.font = UIFont.systemFont(ofSize: 18)
        // Отключаем автозамыкание
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Метод, вызываемый после загрузки view
    override func viewDidLoad() {
        super.viewDidLoad()
        // Устанавливаем цвет фона
        view.backgroundColor = .systemGray6
        
        // Создаем UIStackView для организации элементов интерфейса
        let stackView = UIStackView()
        // Вертикальное расположение элементов
        stackView.axis = .vertical
        // Расстояние между элементами
        stackView.spacing = 10
        // Отключаем автозамыкание
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
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
        
        // Устанавливаем ограничения для UIStackView и элементов
        NSLayoutConstraint.activate([
            // Устанавливаем одинаковую ширину и высоту для всех кнопок и текстовых полей
            button1.widthAnchor.constraint(equalToConstant: 200),
            button1.heightAnchor.constraint(equalToConstant: 50),
            
            button2.widthAnchor.constraint(equalTo: button1.widthAnchor),
            button2.heightAnchor.constraint(equalTo: button1.heightAnchor),
            
            guessTextField.widthAnchor.constraint(equalTo: button1.widthAnchor),
            guessTextField.heightAnchor.constraint(equalTo: button1.heightAnchor),
            
            checkGuessButton.widthAnchor.constraint(equalTo: button1.widthAnchor),
            checkGuessButton.heightAnchor.constraint(equalTo: button1.heightAnchor),
            
            // Центрируем UIStackView по горизонтали и вертикали
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
        // Проверяем, что поле ввода не пустое
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
