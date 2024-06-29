
import UIKit


protocol LoginViewControllerDelegate: AnyObject {
    func check(login: String, password: String) -> Bool
}


class LoginViewController: UIViewController {
    @IBOutlet weak var loginTextField: UITextField! // Поле для ввода логина
    @IBOutlet weak var passwordTextField: UITextField! // Поле для ввода пароля
    @IBOutlet weak var errorLabel: UILabel! // Метка для вывода ошибок

    var userService: UserService!
    
    var loginDelegate: LoginViewControllerDelegate?
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        
        // Проверка, что IBOutlet подключены
        guard let loginTextField = loginTextField, let passwordTextField = passwordTextField else {
            showLoginError("Text fields should not be nil")
            
            return
        }
        
        // Проверка, что текстовые поля не пустые
        guard let login = loginTextField.text, let password = passwordTextField.text, !login.isEmpty, !password.isEmpty else {
            showLoginError("Text fields should not be empty")

            return
        }

        // Проверка логина и пароля через делегат
        if loginDelegate?.check(login: login, password: password) == true {

            if let user = userService.getUser(login: login) {
                let profileVC = ProfileViewController()
                profileVC.user = user
                navigationController?.pushViewController(profileVC, animated: true)
            }
        } else {
            showLoginError("Invalid login credentials")
        }
    }
    
    private func showLoginError(_ message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - UI Elements
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()

    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var logoImageView: UIImageView = {
        let imageView = UIImageView(image: UIImage(named: "VKLogo"))
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    private lazy var emailOrPhoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Email or phone"
        textField.backgroundColor = .systemGray6
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.autocorrectionType = .no
        textField.keyboardType = .emailAddress
        textField.returnKeyType = .next
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()

    private lazy var passwordTextFieldLazy: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Password"
        textField.backgroundColor = .systemGray6
        textField.layer.borderWidth = 0.5
        textField.layer.borderColor = UIColor.lightGray.cgColor
        textField.layer.cornerRadius = 10
        textField.layer.masksToBounds = true
        textField.isSecureTextEntry = true
        textField.autocorrectionType = .no
        textField.returnKeyType = .done
        textField.translatesAutoresizingMaskIntoConstraints = false
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: textField.frame.height))
        textField.leftView = paddingView
        textField.leftViewMode = .always
        
        return textField
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Log In", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.layer.masksToBounds = true
        button.translatesAutoresizingMaskIntoConstraints = false
        if let bluePixel = UIImage(named: "blue_pixel") {
            button.setBackgroundImage(bluePixel.stretchableImage(withLeftCapWidth: 0, topCapHeight: 0), for: .normal)
        }
        button.addTarget(self, action: #selector(loginButtonTapped(_:)), for: .touchUpInside)
        return button
    }()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
        userService = TestUserService()
        #else
        userService = CurrentUserService(user: User(login: "realuser", fullName: "Real User", avatar: UIImage(named: "avatar") ?? UIImage(), status: "Real status"))
        #endif
        
        setupView()
        setupConstraints()
        setupKeyboardObservers()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupKeyboardObservers()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        removeKeyboardObservers()
    }

    @objc func willShowKeyboard(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else { return }
        let keyboardHeight = keyboardFrame.cgRectValue.height
        scrollView.contentInset.bottom = keyboardHeight
        scrollView.verticalScrollIndicatorInsets.bottom = keyboardHeight
    }

    @objc func willHideKeyboard(_ notification: Notification) {
        scrollView.contentInset.bottom = .zero
        scrollView.verticalScrollIndicatorInsets.bottom = .zero
    }

    // MARK: - Private Methods
    private func setupView() {
        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        contentView.addSubview(logoImageView)
        contentView.addSubview(emailOrPhoneTextField)
        contentView.addSubview(passwordTextFieldLazy)
        contentView.addSubview(loginButton)
    }

    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),

            logoImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            logoImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 120),
            logoImageView.widthAnchor.constraint(equalToConstant: 100),
            logoImageView.heightAnchor.constraint(equalToConstant: 100),

            emailOrPhoneTextField.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 30),
            emailOrPhoneTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            emailOrPhoneTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            emailOrPhoneTextField.heightAnchor.constraint(equalToConstant: 50),

            passwordTextFieldLazy.topAnchor.constraint(equalTo: emailOrPhoneTextField.bottomAnchor, constant: 16),
            passwordTextFieldLazy.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            passwordTextFieldLazy.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            passwordTextFieldLazy.heightAnchor.constraint(equalToConstant: 50),

            loginButton.topAnchor.constraint(equalTo: passwordTextFieldLazy.bottomAnchor, constant: 30),
            loginButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            loginButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            loginButton.heightAnchor.constraint(equalToConstant: 50),
            loginButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -30)
        ])
    }

    private func setupKeyboardObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(willShowKeyboard(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(willHideKeyboard(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func removeKeyboardObservers() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}
