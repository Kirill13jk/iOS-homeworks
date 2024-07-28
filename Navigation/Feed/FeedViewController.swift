import UIKit

enum GuessError: Error {
    case emptyInput
    case incorrectGuess
}


// ViewController для отображения ленты и взаимодействия с пользователем
class FeedViewController: UIViewController {
    weak var coordinator: FeedCoordinator? // Слабая ссылка на координатор для избежания циклов сильных ссылок
    private let viewModel = FeedViewModel() // Экземпляр FeedViewModel для управления данными
    private var updateTimer: Timer? // Объект таймера для автоматического обновления данных

    // Переменная для хранения оставшегося времени до следующего обновления
    private var timeRemaining: Int = 60 {
        didSet {
            // Обновляем текст метки с оставшимся временем
            timerLabel.text = "Next update in: \(timeRemaining) seconds"
        }
    }
    
    // Текстовое поле для ввода слова
    private let guessTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your guess" // Устанавливаем подсказку для пользователя
        textField.borderStyle = .roundedRect // Устанавливаем стиль рамки
        textField.translatesAutoresizingMaskIntoConstraints = false // Отключаем автоматическую установку ограничений
        return textField
    }()
    
    // Кнопка для проверки введенного слова
    private lazy var checkGuessButton: CustomButton = {
        let button = CustomButton(
            title: "Check Guess", // Текст кнопки
            titleColor: .white, // Цвет текста кнопки
            backgroundColor: .systemBlue, // Цвет фона кнопки
            font: UIFont.systemFont(ofSize: 16) // Шрифт и размер текста на кнопке
        ) { [weak self] in
            self?.checkGuess() // Действие при нажатии кнопки
        }
        return button
    }()
    
    // Метка для отображения результата проверки слова
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18) // Устанавливаем шрифт и размер текста
        label.translatesAutoresizingMaskIntoConstraints = false // Отключаем автоматическую установку ограничений
        return label
    }()
    
    // Метка для отображения оставшегося времени до обновления ленты
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18) // Устанавливаем шрифт и размер текста
        label.textAlignment = .center // Устанавливаем выравнивание текста по центру
        label.translatesAutoresizingMaskIntoConstraints = false // Отключаем автоматическую установку ограничений
        return label
    }()
    
    // Метод, вызываемый после загрузки view
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6 // Устанавливаем цвет фона
        
        // Создаем UIStackView для организации элементов интерфейса
        let stackView = UIStackView()
        stackView.axis = .vertical // Вертикальное расположение элементов
        stackView.spacing = 10 // Устанавливаем расстояние между элементами
        stackView.translatesAutoresizingMaskIntoConstraints = false // Отключаем автоматическую установку ограничений
        
        // Создаем кнопки для открытия постов
        let button1 = CustomButton(
            title: "Open Post S", // Текст кнопки
            titleColor: .black, // Цвет текста кнопки
            backgroundColor: .white, // Цвет фона кнопки
            font: UIFont.systemFont(ofSize: 16) // Шрифт и размер текста на кнопке
        ) { [weak self] in
            self?.openPost() // Действие при нажатии кнопки
        }
        
        let button2 = CustomButton(
            title: "Open Post M", // Текст кнопки
            titleColor: .black, // Цвет текста кнопки
            backgroundColor: .systemGray5, // Цвет фона кнопки
            font: UIFont.systemFont(ofSize: 16) // Шрифт и размер текста на кнопке
        ) { [weak self] in
            self?.openPost() // Действие при нажатии кнопки
        }
        
        // Добавляем элементы в UIStackView
        stackView.addArrangedSubview(button1)
        stackView.addArrangedSubview(button2)
        stackView.addArrangedSubview(guessTextField)
        stackView.addArrangedSubview(checkGuessButton)
        stackView.addArrangedSubview(resultLabel)
        stackView.addArrangedSubview(timerLabel) // Добавляем метку таймера в стек
        
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
        
        // Устанавливаем таймер для обновления данных каждые 60 секунд
        startUpdateTimer()
    }
    
    // Метод для запуска таймера обновления
    private func startUpdateTimer() {
        // Создаем таймер, который будет вызывать метод updateFeed каждые 60 секунд
        updateTimer = Timer.scheduledTimer(timeInterval: 60.0, target: self, selector: #selector(updateFeed), userInfo: nil, repeats: true)
        // Устанавливаем начальное значение времени до обновления
        timeRemaining = 60
        // Обновляем таймер каждую секунду
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] timer in
            self?.updateTimeRemaining()
        }
    }
    
    // Метод для обновления оставшегося времени
    private func updateTimeRemaining() {
        if timeRemaining > 0 {
            timeRemaining -= 1
        } else {
            timeRemaining = 60
        }
    }
    
    // Метод для обновления ленты
    @objc private func updateFeed() {
        // Используем ViewModel для загрузки новых данных
        viewModel.fetchFeedData {
            // Обновляем UI после получения новых данных, если необходимо
            print("Лента обновлена!") // Пример отладочного вывода
        }
        // Сброс времени до следующего обновления
        timeRemaining = 60
    }
    
    // Остановка таймера
    private func stopUpdateTimer() {
        updateTimer?.invalidate() // Останавливаем таймер
        updateTimer = nil // Убираем ссылку на таймер
    }
    
    // Метод для проверки введенного слова
    private func checkGuess() {
        do {
            // Пытаемся проверить введенное слово с помощью функции validateGuess, которя может ошибку
            let result = try validateGuess(guess: guessTextField.text)
            // Если слово правильное, обновляем метку результатом и устанавливаем зеленный цвет текста
            resultLabel.text = result
            resultLabel.textColor = .green
        } catch let error as GuessError {
            // Если была выброшена ошибка GuessError, обрабатываем ее в методе handleGuessError
            handleGuessError(error)
        } catch {
            // Обрабатываем любые другие наожиданные ошибки, устанавливая соответствующее сообщение
            resultLabel.text = "Unexpected error."
            resultLabel.textColor = .red
        }
    }
    
    // Функция для проверки введенного слова, выбрасывает ошибки в случае некорретного ввода
    private func validateGuess(guess: String?) throws -> String {
        // Проверяем, что введенное слово не пустое
        guard let guess = guess, !guess.isEmpty else {
            throw GuessError.emptyInput
        }
        let correctWord = "apple" // Пример правильного слова
        // Проверяем, совпадает ли введенног слово с правильными, не учитывая регистр
        guard guess.lowercased() == correctWord.lowercased() else {
            throw GuessError.incorrectGuess
        }
        
        // Если слово правильное, возвращаем соответствующее сообщение
        return "Correct! The secret word is \(correctWord)."
    }
    
    // Функции для обработки ошибок ввода слова
    private func handleGuessError(_ error: GuessError) {
        var message = ""
        
        // В зависимости от типа ошибки устанавливаем соответствующее сообщение
        switch error {
        case .emptyInput:
            message = "Please enter a word."
        case .incorrectGuess:
            message = "Incorect word. Please try again."
        }
        
        // Обновляем метку с сообщением об ошибки и устанавливаем красный цвет текста
        resultLabel.text = message
        resultLabel.textColor = .red
    }
    
    
    // Метод для открытия поста
    @objc private func openPost() {
        // Переход на экран с постом
        let postViewController = PostViewController()
        navigationController?.pushViewController(postViewController, animated: true)
    }
    
    // Остановка таймера при уничтожении контроллера
    deinit {
        stopUpdateTimer() // Останавливаем таймер при уничтожении контроллера
    }
}
