import UIKit

// Контроллер для экрана логина
class LoginViewController: UIViewController {
    // Слабая ссылка на координатор для избежания циклов сильных ссылок
    weak var coordinator: LoginCoordinator?
    // Делегат для проверки логина и пароля
    var loginDelegate: LoginViewControllerDelegate?

    // Поле для ввода логина или email
    private lazy var emailOrPhoneTextField: UITextField = {
        let textField = UITextField()
        // Устанавливаем подсказку в поле ввода
        textField.placeholder = "Email or phone"
        // Устанавливаем цвет фона
        textField.backgroundColor = .systemGray6
        // Устанавливаем толщину границы
        textField.layer.borderWidth = 0.5
        // Устанавливаем цвет границы
        textField.layer.borderColor = UIColor.lightGray.cgColor
        // Устанавливаем закругленные углы
        textField.layer.cornerRadius = 10
        // Обрезаем содержимое по границам
        textField.layer.masksToBounds = true
        // Отключаем автокоррекцию
        textField.autocorrectionType = .no
        // Устанавливаем тип клавиатуры (email)
        textField.keyboardType = .emailAddress
        // Устанавливаем тип клавиши возврата (следующий)
        textField.returnKeyType = .next
        // Отключаем автоматические констрейнты
        textField.translatesAutoresizingMaskIntoConstraints = false

        // Добавление отступа слева
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always

        return textField
    }()

    // Поле для ввода пароля
    private lazy var passwordTextFieldLazy: UITextField = {
        let textField = UITextField()
        // Устанавливаем подсказку в поле ввода
        textField.placeholder = "Password"
        // Устанавливаем цвет фона
        textField.backgroundColor = .systemGray6
        // Устанавливаем толщину границы
        textField.layer.borderWidth = 0.5
        // Устанавливаем цвет границы
        textField.layer.borderColor = UIColor.lightGray.cgColor
        // Устанавливаем закругленные углы
        textField.layer.cornerRadius = 10
        // Обрезаем содержимое по границам
        textField.layer.masksToBounds = true
        // Устанавливаем ввод текста с маскировкой
        textField.isSecureTextEntry = true
        // Отключаем автокоррекцию
        textField.autocorrectionType = .no
        // Устанавливаем тип клавиши возврата (готово)
        textField.returnKeyType = .done
        // Отключаем автоматические констрейнты
        textField.translatesAutoresizingMaskIntoConstraints = false

        // Добавление отступа слева
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always

        return textField
    }()

    // Кнопка входа
    private lazy var loginButton: CustomButton = {
        let button = CustomButton(
            title: "Log In", // Текст на кнопке
            titleColor: .white, // Цвет текста на кнопке
            backgroundColor: .blue, // Цвет фона кнопки
            font: UIFont.systemFont(ofSize: 16) // Шрифт текста на кнопке
        ) { [weak self] in
            self?.loginButtonTapped() // Действие при нажатии кнопки
        }
        
        // Установка фонового изображения для кнопки, если оно есть
        if let bluePixel = UIImage(named: "blue_pixel") {
            button.setBackgroundImage(bluePixel.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0), for: .normal)
        }
        
        return button
    }()

    // Иконка AppIcon
    private lazy var appIconImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "app icon"))
        // Устанавливаем режим содержимого
        imageView.contentMode = .scaleAspectFit
        // Отключаем автоматические констрейнты
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    // Метод, вызываемый после загрузки view
    override func viewDidLoad() {
        super.viewDidLoad()
        // Устанавливаем белый фон для view
        view.backgroundColor = .systemGray6
        // Устанавливаем заголовок контроллера
        title = "Login"

        // Настраиваем элементы интерфейса и констрейнты
        setupView()
        setupConstraints()
        setupKeyboardObservers()
    }

    // Метод, вызываемый перед появлением view
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardObservers()
    }

    // Метод, вызываемый перед исчезновением view
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }

    // Настройка элементов интерфейса
    private func setupView() {
        view.addSubview(appIconImageView)
        view.addSubview(emailOrPhoneTextField)
        view.addSubview(passwordTextFieldLazy)
        view.addSubview(loginButton)
    }

    // Настройка констрейнтов
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
            loginButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }

    // Метод, вызываемый при нажатии на кнопку входа
    @objc func loginButtonTapped() {
        guard let login = emailOrPhoneTextField.text, let password = passwordTextFieldLazy.text else {
            return
        }

        if loginDelegate?.check(login: login, password: password) == true {
            coordinator?.didFinishLogin()
        } else {
            let alert = UIAlertController(title: "Error", message: "Invalid username or password", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
    }

    // MARK: - Обработка клавиатуры

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
        _ = keyboardFrame.cgRectValue.height
        // Настройка отступа контента для scrollView
    }

    // Метод, вызываемый при скрытии клавиатуры
    @objc func willHideKeyboard(_ notification: Notification) {
        // Сброс отступа контента для scrollView
    }
}
