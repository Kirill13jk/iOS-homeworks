import UIKit

// Определение собственного домена ошибок
enum LoginError: Error {
    case invalidUsernameLength  // Ошибка: длина логина меньше 6 символов
    case invalidPasswordLength  // Ошибка: длина пароля меньше 8 символов
    case authenticationFailed   // Ошибка: неудачная авторизация
}

// Результат успешной авторизации
struct AuthenticationSuccess {
    let username: String
}

class LoginViewController: UIViewController {
    weak var coordinator: LoginCoordinator?  // Слабая ссылка на координатора для избежания циклов сильных ссылок
    var loginDelegate: LoginViewControllerDelegate?  // Делегат для проверки логина и пароля
    
    // Поле ввода для email или телефона
    private lazy var emailOrPhoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email or phone"  // Подсказка в поле ввода
        textField.backgroundColor = .systemGray6  // Фон поля ввода
        textField.layer.borderWidth = 0.5  // Толщина границы поля ввода
        textField.layer.borderColor = UIColor.lightGray.cgColor  // Цвет границы
        textField.layer.cornerRadius = 10  // Закругленные углы
        textField.layer.masksToBounds = true  // Обрезаем содержимое по границам
        textField.autocorrectionType = .no  // Отключение автокоррекции
        textField.keyboardType = .emailAddress  // Тип клавиатуры (email)
        textField.returnKeyType = .next  // Тип клавиши возврата (следующий)
        textField.translatesAutoresizingMaskIntoConstraints = false  // Отключаем автоматические констрейнты
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView  // Добавляем отступ слева
        textField.leftViewMode = .always
        return textField
    }()
    
    // Поле ввода для пароля
    private lazy var passwordTextFieldLazy: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"  // Подсказка в поле ввода
        textField.backgroundColor = .systemGray6  // Фон поля ввода
        textField.layer.borderWidth = 0.5  // Толщина границы поля ввода
        textField.layer.borderColor = UIColor.lightGray.cgColor  // Цвет границы
        textField.layer.cornerRadius = 10  // Закругленные углы
        textField.layer.masksToBounds = true  // Обрезаем содержимое по границам
        textField.isSecureTextEntry = true  // Ввод текста с маскировкой
        textField.autocorrectionType = .no  // Отключение автокоррекции
        textField.returnKeyType = .done  // Тип клавиши возврата (готово)
        textField.translatesAutoresizingMaskIntoConstraints = false  // Отключаем автоматические констрейнты
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView  // Добавляем отступ слева
        textField.leftViewMode = .always
        return textField
    }()
    
    // Кнопка для выполнения логина
    private lazy var loginButton: CustomButton = {
        let button = CustomButton(
            title: "Log In",  // Текст на кнопке
            titleColor: .white,  // Цвет текста кнопки
            backgroundColor: .systemBlue,  // Цвет фона кнопки
            font: UIFont.systemFont(ofSize: 16)  // Шрифт текста на кнопке
        ) { [weak self] in
            self?.loginButtonTapped()  // Действие при нажатии кнопки
        }
        if let bluePixel = UIImage(named: "blue_pixel") {
            button.setBackgroundImage(bluePixel.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0), for: .normal)  // Установка фонового изображения для кнопки
        }
        return button
    }()
    
    // Изображение иконки приложения
    private lazy var appIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "app icon"))
        imageView.contentMode = .scaleAspectFit  // Режим отображения содержимого
        imageView.translatesAutoresizingMaskIntoConstraints = false  // Отключаем автоматические констрейнты
        return imageView
    }()
    
    // Кнопка для запуска brute force атаки на пароль
    private lazy var bruteForceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Подобрать пароль", for: .normal)  // Текст на кнопке
        button.addTarget(self, action: #selector(didTapBruteForceButton), for: .touchUpInside)  // Действие при нажатии кнопки
        button.translatesAutoresizingMaskIntoConstraints = false  // Отключаем автоматические констрейнты
        return button
    }()
    
    // Индикатор активности (спиннер)
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false  // Отключаем автоматические констрейнты
        return indicator
    }()
    
    let passwordBruteForcer = PasswordBruteForcer()  // Инициализация класса для подбора пароля
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemGray6  // Устанавливаем цвет фона
        title = "Login"  // Устанавливаем заголовок контроллера
        setupView()  // Настраиваем элементы интерфейса
        setupConstraints()  // Настраиваем констрейнты
        setupKeyboardObservers()  // Настраиваем наблюдателей за клавиатурой
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardObservers()  // Настраиваем наблюдателей за клавиатурой перед появлением view
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()  // Удаляем наблюдателей за клавиатурой перед исчезновением view
    }
    
    private func setupView() {
        view.addSubview(appIconImageView)  // Добавляем иконку приложения
        view.addSubview(emailOrPhoneTextField)  // Добавляем поле ввода email или телефона
        view.addSubview(passwordTextFieldLazy)  // Добавляем поле ввода пароля
        view.addSubview(loginButton)  // Добавляем кнопку входа
        view.addSubview(bruteForceButton)  // Добавляем кнопку подбора пароля
        view.addSubview(activityIndicator)  // Добавляем индикатор активности
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Констрейнты для иконки AppIcon
            appIconImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            appIconImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50),
            appIconImageView.widthAnchor.constraint(equalToConstant: 100),
            appIconImageView.heightAnchor.constraint(equalToConstant: 100),
            
            // Констрейнты для поля ввода логина
            emailOrPhoneTextField.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            emailOrPhoneTextField.topAnchor.constraint(equalTo: appIconImageView.bottomAnchor, constant: 30),
            emailOrPhoneTextField.widthAnchor.constraint(equalToConstant: 200),
            emailOrPhoneTextField.heightAnchor.constraint(equalToConstant: 50),
            
            // Констрейнты для поля ввода пароля
            passwordTextFieldLazy.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            passwordTextFieldLazy.topAnchor.constraint(equalTo: emailOrPhoneTextField.bottomAnchor, constant: 10),
            passwordTextFieldLazy.widthAnchor.constraint(equalToConstant: 200),
            passwordTextFieldLazy.heightAnchor.constraint(equalToConstant: 50),
            
            // Констрейнты для кнопки входа
            loginButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            loginButton.topAnchor.constraint(equalTo: passwordTextFieldLazy.bottomAnchor, constant: 20),
            loginButton.widthAnchor.constraint(equalToConstant: 200),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            
            // Констрейнты для кнопки подбора пароля
            bruteForceButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bruteForceButton.topAnchor.constraint(equalTo: loginButton.bottomAnchor, constant: 20),
            
            // Констрейнты для индикатора активности
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            activityIndicator.topAnchor.constraint(equalTo: bruteForceButton.bottomAnchor, constant: 20)
        ])
    }
    
    @objc func loginButtonTapped() {
        guard let login = emailOrPhoneTextField.text, let password = passwordTextFieldLazy.text else {
            showErrorAlert(message: "Please enter both username and password.")  // Отображаем сообщение об ошибке
            return
        }
        
        let result = authenticateUser(login: login, password: password)  // Пытаемся авторизовать пользователя
        
        switch result {
        case .success(_):
            coordinator?.didFinishLogin()  // Завершаем процесс логина при успешной проверке
        case .failure(let error):
            handleError(error)  // Обрабатываем ошибку
        }
    }
    
    // Метод для проверки логина и пароля с использованием Checker
    private func authenticateUser(login: String, password: String) -> Result<AuthenticationSuccess, LoginError> {
        // Проверка длины логина
        guard login.count >= 6 else {
            return .failure(.invalidUsernameLength)
        }
        
        // Проверка длины пароля
        guard password.count >= 8 else {
            return .failure(.invalidPasswordLength)
        }
        
        // Используем Checker для проверки логина и пароля
        let isAuthenticated = Checker.shared.check(login: login, password: password)

        if isAuthenticated {
            let success = AuthenticationSuccess(username: login)
            return .success(success)
        } else {
            return .failure(.authenticationFailed)
        }
    }

    // Метод для обработки ошибок
    private func handleError(_ error: LoginError) {
        var message = ""
        
        switch error {
        case .invalidUsernameLength:
            message = "Username must be at least 6 characters long."
        case .invalidPasswordLength:
            message = "Password must be at least 8 characters long."
        case .authenticationFailed:
            message = "Authentication failed. Please check your credentials."
        }
        
        showErrorAlert(message: message)  // Показываем сообщение об ошибке
    }

    // Метод для отображения ошибки с помощью Alert
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    @objc func didTapBruteForceButton() {
        passwordTextFieldLazy.isSecureTextEntry = true  // Делаем поле пароля защищенным
        activityIndicator.startAnimating()  // Запускаем индикатор активности
        
        let randomPassword = generateRandomPassword(length: 4)  // Генерируем случайный пароль
        print("Randomly generated password: \(randomPassword)")
        
        passwordBruteForcer.bruteForce(passwordToUnlock: randomPassword) { [weak self] foundPassword in
            guard let self = self else { return }
            self.activityIndicator.stopAnimating()  // Останавливаем индикатор активности
            self.passwordTextFieldLazy.isSecureTextEntry = false  // Делаем пароль видимым
            self.passwordTextFieldLazy.text = foundPassword  // Отображаем найденный пароль
            print("Password found: \(foundPassword)")
        }
    }
    
    func generateRandomPassword(length: Int) -> String {
        let characters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<length).map { _ in characters.randomElement()! })  // Генерируем случайный пароль
    }
    
    // MARK: - Обработка клавиатуры
    
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func willShowKeyboard(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        _ = keyboardFrame.cgRectValue.height  // Получаем высоту клавиатуры
    }
    
    @objc func willHideKeyboard(_ notification: Notification) {}
}
