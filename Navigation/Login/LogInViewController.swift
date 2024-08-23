import UIKit
import FirebaseAuth

// Контроллер для входа и регистрации
class LoginViewController: UIViewController {
    weak var coordinator: LoginCoordinator? // Слабая ссылка на координатор, чтобы избежать циклических ссылок
    var checkerService: CheckerServiceProtocol? // Сервис для проверки учетных данных и регистрации
    
    // Поле для ввода email
    private lazy var emailTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email" // Подсказка внутри текстового поля
        textField.autocapitalizationType = .none // Отключаем автокапитализацию
        textField.autocorrectionType = .no // Отключаем автокоррекцию
        textField.keyboardType = .emailAddress // Устанавливаем тип клавиатуры для ввода email
        textField.borderStyle = .roundedRect // Закругленные края текстового поля
        textField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged) // Добавляем таргет для отслеживания изменения текста
        return textField
    }()
    
    // Поле для ввода пароля
    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password" // Подсказка внутри текстового поля
        textField.isSecureTextEntry = true // Текст скрыт, как обычно для пароля
        textField.borderStyle = .roundedRect // Закругленные края текстового поля
        textField.addTarget(self, action: #selector(textFieldsDidChange), for: .editingChanged) // Добавляем таргет для отслеживания изменения текста
        return textField
    }()
    
    // Кнопка для входа
    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Login", for: .normal) // Заголовок кнопки
        button.isEnabled = false  // Кнопка отключена по умолчанию, включается только если оба поля заполнены
        button.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside) // Добавляем таргет для нажатия на кнопку
        return button
    }()
    
    // Кнопка для регистрации
    private lazy var signUpButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Up", for: .normal) // Заголовок кнопки
        button.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside) // Добавляем таргет для нажатия на кнопку
        return button
    }()
    
    // Метод, вызываемый при загрузке ViewController
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground // Устанавливаем цвет фона
        checkerService = CheckerService() // Инициализация сервиса проверки учетных данных
        setupView() // Настройка интерфейса
    }
    
    // Метод для проверки заполненности текстовых полей и включения кнопки логина
    @objc private func textFieldsDidChange() {
        let isEmailFilled = !(emailTextField.text?.isEmpty ?? true) // Проверяем, что поле email не пустое
        let isPasswordFilled = !(passwordTextField.text?.isEmpty ?? true) // Проверяем, что поле пароля не пустое
        loginButton.isEnabled = isEmailFilled && isPasswordFilled // Кнопка активируется, если оба поля заполнены
    }
    
    // Метод, вызываемый при нажатии на кнопку Login
    @objc private func loginButtonTapped() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return } // Проверка на заполненность полей
        
        // Проверка учетных данных через сервис
        checkerService?.checkCredentials(email: email, password: password) { [weak self] result in
            switch result {
            case .success:
                // Если вход успешен, вызываем метод завершения логина у координатора
                self?.coordinator?.didFinishLogin()
            case .failure(let error):
                // В случае ошибки показываем алерт с описанием ошибки
                self?.showError(error)
            }
        }
    }
    
    // Метод, вызываемый при нажатии на кнопку Sign Up
    @objc private func signUpButtonTapped() {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return } // Проверка на заполненность полей
        
        // Регистрация нового пользователя через сервис
        checkerService?.signUp(email: email, password: password) { [weak self] result in
            switch result {
            case .success:
                // Если регистрация успешна, вызываем метод завершения логина у координатора
                self?.coordinator?.didFinishLogin()
            case .failure(let error):
                // В случае ошибки показываем алерт с описанием ошибки
                self?.showError(error)
            }
        }
    }
    
    // Метод для отображения ошибки через UIAlertController
    private func showError(_ error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // Настройка и добавление элементов интерфейса на экран
    private func setupView() {
        view.addSubview(emailTextField)
        view.addSubview(passwordTextField)
        view.addSubview(loginButton)
        view.addSubview(signUpButton)
        setupConstraints() // Устанавливаем ограничения для элементов интерфейса
    }

    // Установка ограничений для элементов интерфейса
    private func setupConstraints() {
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        loginButton.translatesAutoresizingMaskIntoConstraints = false
        signUpButton.translatesAutoresizingMaskIntoConstraints = false
        
        // Устанавливаем ограничения для элементов на экране
        NSLayoutConstraint.activate([
            emailTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor), // Центрируем emailTextField по горизонтали
            emailTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100), // Устанавливаем отступ сверху
            emailTextField.widthAnchor.constraint(equalToConstant: 200), // Ширина поля
            emailTextField.heightAnchor.constraint(equalToConstant: 40), // Высота поля
            
            passwordTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor), // Центрируем passwordTextField по горизонтали
            passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: 20), // Отступ от emailTextField
            passwordTextField.widthAnchor.constraint(equalToConstant: 200), // Ширина поля
            passwordTextField.heightAnchor.constraint(equalToConstant: 40), // Высота поля
            
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), // Центрируем loginButton по горизонтали
            loginButton.topAnchor.constraint(equalTo: passwordTextField.bottomAnchor, constant: 20), // Отступ от passwordTextField
            loginButton.widthAnchor.constraint(equalToConstant: 200), // Ширина кнопки
            loginButton.heightAnchor.constraint(equalToConstant: 40), // Высота кнопки
            
            signUpButton.centerXAnchor.constraint(equalTo: view.centerXAnchor), // Центрируем signUpButton по горизонтали
            signUpButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20), // Отступ от loginButton
            signUpButton.widthAnchor.constraint(equalToConstant: 200), // Ширина кнопки
            signUpButton.heightAnchor.constraint(equalToConstant: 40) // Высота кнопки
        ])
    }

}
