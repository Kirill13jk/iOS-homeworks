import UIKit

class FeedViewController: UIViewController {
    
    private let model = FeedModel() // Экземпляр модели для проверки слова
    
    // Создание текстового поля для ввода слова
    private let guessTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your guess"
        textField.borderStyle = .roundedRect
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    // Создание кнопки для проверки введенного слова
    private lazy var checkGuessButton: CustomButton = {
        let button = CustomButton(
            title: "Check Guess",
            titleColor: .white,
            backgroundColor: .systemBlue
        ) { [weak self] in
            self?.checkGuess()
        }
        return button
    }()
    
    // Создание UILabel для отображения результата проверки
    private let resultLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6
        
        // Создание UIStackView для организации элементов интерфейса
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Создание кнопок открытия постов
        let button1 = CustomButton(
            title: "Open Post Super Man",
            titleColor: .black,
            backgroundColor: .white
        ) { [weak self] in
            self?.openPost()
        }
        
        let button2 = CustomButton(
            title: "Open Post Spider Man",
            titleColor: .black,
            backgroundColor: .systemGray5
        ) { [weak self] in
            self?.openPost()
        }
        
        // Добавление элементов в UIStackView
        stackView.addArrangedSubview(button1)
        stackView.addArrangedSubview(button2)
        stackView.addArrangedSubview(guessTextField)
        stackView.addArrangedSubview(checkGuessButton)
        stackView.addArrangedSubview(resultLabel)
        
        // Добавление UIStackView на главный view
        view.addSubview(stackView)
        
        // Установка ограничений для UIStackView и кнопок
        NSLayoutConstraint.activate([
            button1.widthAnchor.constraint(equalToConstant: 200),
            button1.heightAnchor.constraint(equalToConstant: 50),
            
            button2.heightAnchor.constraint(equalToConstant: 50),
            
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    // Метод для проверки введенного слова
    private func checkGuess() {
        guard let guess = guessTextField.text, !guess.isEmpty else {
            resultLabel.text = "Please enter a word"
            resultLabel.textColor = .red
            return
        }
        
        if model.check(word: guess) {
            resultLabel.text = "Correct!"
            resultLabel.textColor = .green
        } else {
            resultLabel.text = "Wrong, try again."
            resultLabel.textColor = .red
        }
    }
    
    // Метод для открытия поста
    @objc private func openPost() {
        let postViewController = PostViewController()
        navigationController?.pushViewController(postViewController, animated: true)
    }
}
