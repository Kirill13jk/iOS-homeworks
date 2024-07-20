import UIKit

class LoginViewController: UIViewController {
    weak var coordinator: LoginCoordinator?  // Слабая ссылка на координатора для избежания циклов сильных ссылок
    var loginDelegate: LoginViewControllerDelegate?  // Делегат для проверки логина и пароля
    
    private lazy var emailOrPhoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email or phone"  // Устанавливаем подсказку в поле ввода
        textField.backgroundColor = .systemGray6  // Устанавливаем цвет фона
        textField.layer.borderWidth = 0.5  // Устанавливаем толщину границы
        textField.layer.borderColor = UIColor.lightGray.cgColor  // Устанавливаем цвет границы
        textField.layer.cornerRadius = 10  // Устанавливаем закругленные углы
        textField.layer.masksToBounds = true  // Обрезаем содержимое по границам
        textField.autocorrectionType = .no  // Отключаем автокоррекцию
        textField.keyboardType = .emailAddress  // Устанавливаем тип клавиатуры (email)
        textField.returnKeyType = .next  // Устанавливаем тип клавиши возврата (следующий)
        textField.translatesAutoresizingMaskIntoConstraints = false  // Отключаем автоматические констрейнты
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView  // Добавление отступа слева
        textField.leftViewMode = .always
        return textField
    }()
    
    private lazy var passwordTextFieldLazy: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"  // Устанавливаем подсказку в поле ввода
        textField.backgroundColor = .systemGray6  // Устанавливаем цвет фона
        textField.layer.borderWidth = 0.5  // Устанавливаем толщину границы
        textField.layer.borderColor = UIColor.lightGray.cgColor  // Устанавливаем цвет границы
        textField.layer.cornerRadius = 10  // Устанавливаем закругленные углы
        textField.layer.masksToBounds = true  // Обрезаем содержимое по границам
        textField.isSecureTextEntry = true  // Устанавливаем ввод текста с маскировкой
        textField.autocorrectionType = .no  // Отключаем автокоррекцию
        textField.returnKeyType = .done  // Устанавливаем тип клавиши возврата (готово)
        textField.translatesAutoresizingMaskIntoConstraints = false  // Отключаем автоматические констрейнты
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView  // Добавление отступа слева
        textField.leftViewMode = .always
        return textField
    }()
    
    private lazy var loginButton: CustomButton = {
        let button = CustomButton(
            title: "Log In",  // Текст на кнопке
            titleColor: .white,  // Цвет текста на кнопке
            backgroundColor: .blue,  // Цвет фона кнопки
            font: UIFont.systemFont(ofSize: 16)  // Шрифт текста на кнопке
        ) { [weak self] in
            self?.loginButtonTapped()  // Действие при нажатии кнопки
        }
        if let bluePixel = UIImage(named: "blue_pixel") {
            button.setBackgroundImage(bluePixel.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0), for: .normal)  // Установка фонового изображения для кнопки
        }
        return button
    }()
    
    private lazy var appIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "app icon"))
        imageView.contentMode = .scaleAspectFit  // Устанавливаем режим содержимого
        imageView.translatesAutoresizingMaskIntoConstraints = false  // Отключаем автоматические констрейнты
        return imageView
    }()
    
    private lazy var bruteForceButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Подобрать пароль", for: .normal)  // Устанавливаем текст на кнопке
        button.addTarget(self, action: #selector(didTapBruteForceButton), for: .touchUpInside)  // Устанавливаем действие при нажатии кнопки
        button.translatesAutoresizingMaskIntoConstraints = false  // Отключаем автоматические констрейнты
        return button
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView(style: .large)
        indicator.translatesAutoresizingMaskIntoConstraints = false  // Отключаем автоматические констрейнты
        return indicator
    }()
    
    let passwordBruteForcer = PasswordBruteForcer()  // Инициализируем экземпляр класса PasswordBruteForcer
    
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
            return
        }
        
        if loginDelegate?.check(login: login, password: password) == true {
            coordinator?.didFinishLogin()  // Завершаем процесс логина при успешной проверке
        } else {
            let alert = UIAlertController(title: "Error", message: "Invalid username or password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)  // Показываем сообщение об ошибке
        }
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
