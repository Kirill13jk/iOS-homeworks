import UIKit

// Протокол делегата для проверки логина и пароля
protocol LoginViewControllerDelegate: AnyObject {
    func check(login: String, password: String) -> Bool
}

class LoginViewController: UIViewController {
    // Слабая ссылка на координатор для избежания циклов сильных ссылок
        weak var coordinator: LoginCoordinator?
    
    // Поле для ввода логина или email, заданное программно
    private lazy var emailOrPhoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email or phone" // Подсказка в поле ввода
        textField.backgroundColor = .systemGray6 // Фон поля ввода
        textField.layer.borderWidth = 0.5 // Толщина границы поля ввода
        textField.layer.borderColor = UIColor.lightGray.cgColor // Цвет границы поля ввода
        textField.layer.cornerRadius = 10 // Закругленные углы
        textField.layer.masksToBounds = true // Обрезка содержимого по границам
        textField.autocorrectionType = .no // Отключение автокоррекции
        textField.keyboardType = .emailAddress // Тип клавиатуры (email)
        textField.returnKeyType = .next // Тип клавиши возврата (следующий)
        textField.translatesAutoresizingMaskIntoConstraints = false // Отключение автоматических констрейнтов

        // Добавление отступа слева
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always

        return textField
    }()

    // Поле для ввода пароля, заданное программно
    private lazy var passwordTextFieldLazy: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password" // Подсказка в поле ввода
        textField.backgroundColor = .systemGray6 // Фон поля ввода
        textField.layer.borderWidth = 0.5 // Толщина границы поля ввода
        textField.layer.borderColor = UIColor.lightGray.cgColor // Цвет границы поля ввода
        textField.layer.cornerRadius = 10 // Закругленные углы
        textField.layer.masksToBounds = true // Обрезка содержимого по границам
        textField.isSecureTextEntry = true // Ввод текста с маскировкой
        textField.autocorrectionType = .no // Отключение автокоррекции
        textField.returnKeyType = .done // Тип клавиши возврата (готово)
        textField.translatesAutoresizingMaskIntoConstraints = false // Отключение автоматических констрейнтов

        // Добавление отступа слева
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always

        return textField
    }()

    // Кнопка входа, заданная программно
    private lazy var loginButton: CustomButton = {
        let button = CustomButton(
            title: "Log In", // Текст на кнопке
            titleColor: .white, backgroundColor: .blue,// Цвет фона кнопки(nil, так как у нас используется изображение)
            font: UIFont.systemFont(ofSize: 16)
        ) { [weak self] in
            self?.loginButtonTapped() // Действие, выполняемое при нажатие кнопки
        }
        
        if let bluePixel = UIImage(named: "blue_pixel") {
            // Установка фонового изображения для кнопки
            button.setBackgroundImage(bluePixel.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0), for: .normal)
        }
        
        return button
    }()

    var userService: UserService! // Сервис для получения данных пользователя
    var loginDelegate: LoginViewControllerDelegate? // Делегат для проверки логина и пароля

    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("View did load") // Отладочный вывод
        
        #if DEBUG
        // Использование тестового сервиса пользователя для отладки
        userService = TestUserService()
        #else
        // Использование реального сервиса пользователя
        userService = CurrentUserService(user: User(login: "admin", fullName: "Real User", avatar: UIImage(named: "avatar") ?? UIImage(), status: "Real status"))
        #endif
        
        // Делегат инициализируется в SceneDelegate через фабрику
        
        setupView() // Настройка представления
        setupConstraints() // Настройка констрейнтов
        setupKeyboardObservers() // Настройка наблюдателей за клавиатурой
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardObservers() // Настройка наблюдателей за клавиатурой при появлении представления
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers() // Удаление наблюдателей за клавиатурой при исчезновении представления
    }

    // Метод для обработки нажатия на кнопку входа
    @objc func loginButtonTapped() {
        print("Login button tapped") // Отладочный вывод
        
        // Проверка, что текстовые поля не пустые
        guard let login = emailOrPhoneTextField.text, let password = passwordTextFieldLazy.text, !login.isEmpty, !password.isEmpty else {
            showLoginError("Text fields should not be empty") // Отображение ошибки, если поля пустые
            print("Text fields are empty") // Отладочный вывод
            return
        }
        
        print("Login: \(login), Password: \(password)") // Отладочный вывод

        // Проверка логина и пароля через делегат
        if loginDelegate?.check(login: login, password: password) == true {
            print("Login successful") // Отладочный вывод

            // Получаем пользователя по логину через userService
            if let user = userService.getUser(login: login) {
                let profileVC = ProfileViewController()
                profileVC.user = user // Передаем данные пользователя в ProfileViewController
                print("Navigating to ProfileViewController") // Отладочный вывод
                navigationController?.pushViewController(profileVC, animated: true) // Переход на экран профиля
            } else {
                print("User not found") // Отладочный вывод, если пользователь не найден
            }
        } else {
            print("Invalid login credentials") // Отладочный вывод, если логин или пароль неверны
            showLoginError("Invalid login credentials") // Отображение ошибки
        }
    }
    
    // Метод для отображения ошибки входа
    private func showLoginError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UI Elements
    // Программное создание скролл-вью
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    // Программное создание контент-вью
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    // Программное создание логотипа
    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "VKLogo"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // MARK: - Private Methods
    // Настройка представления
    private func setupView() {
        view.backgroundColor = .white // Устанавливаем белый фон для представления
        view.addSubview(scrollView) // Добавляем скролл-вью в представление
        scrollView.addSubview(contentView) // Добавляем контент-вью в скролл-вью

        // Добавляем элементы интерфейса в контент-вью
        contentView.addSubview(logoImageView)
        contentView.addSubview(emailOrPhoneTextField)
        contentView.addSubview(passwordTextFieldLazy)
        contentView.addSubview(loginButton)
    }

    // Настройка констрейнтов
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // Констрейнты для скролл-вью
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            // Констрейнты для контент-вью
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            // Констрейнты для логотипа
            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),

            // Констрейнты для поля ввода логина
            emailOrPhoneTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 30),
            emailOrPhoneTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            emailOrPhoneTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            emailOrPhoneTextField.heightAnchor.constraint(equalToConstant: 50),

            // Констрейнты для поля ввода пароля
            passwordTextFieldLazy.topAnchor.constraint(equalTo: emailOrPhoneTextField.bottomAnchor, constant: 16),
            passwordTextFieldLazy.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            passwordTextFieldLazy.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            passwordTextFieldLazy.heightAnchor.constraint(equalToConstant: 50),

            // Констрейнты для кнопки входа
            loginButton.topAnchor.constraint(equalTo: passwordTextFieldLazy.bottomAnchor, constant: 30),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }

    // Настройка наблюдателей за клавиатурой
    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // Удаление наблюдателей за клавиатурой
    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    // Метод, вызываемый при появлении клавиатуры
    @objc func willShowKeyboard(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        scrollView.contentInset.bottom = keyboardHeight
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
    }

    // Метод, вызываемый при скрытии клавиатуры
    @objc func willHideKeyboard(_ notification: Notification) {
        scrollView.contentInset.bottom = .zero
        scrollView.verticalScrollIndicatorInsets.bottom = .zero
    }
}
