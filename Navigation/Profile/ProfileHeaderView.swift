import UIKit
import SnapKit

class ProfileHeaderView: UIView {
    // Создаем и настраиваем элементы пользовательского интерфейса
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile_avatar") // Устанавливаем изображение профиля
        imageView.contentMode = .scaleAspectFit // Устанавливаем режим отображения изображения
        imageView.layer.cornerRadius = 50 // Скругляем углы изображения
        imageView.backgroundColor = .lightGray // Устанавливаем фон для изображения
        imageView.layer.borderWidth = 3 // Устанавливаем ширину границы
        imageView.layer.borderColor = UIColor.black.cgColor // Устанавливаем цвет границы
        imageView.clipsToBounds = true // Обрезаем изображение по границам view
        imageView.isUserInteractionEnabled = true // Разрешаем взаимодействие с изображением
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Hipster Cat" // Устанавливаем текст метки
        label.font = UIFont.boldSystemFont(ofSize: 20) // Устанавливаем шрифт и размер текста
        return label
    }()
    
    let bioLabel: UILabel = {
        let label = UILabel()
        label.text = "Listening to music" // Устанавливаем текст метки
        label.font = UIFont.systemFont(ofSize: 16) // Устанавливаем шрифт и размер текста
        label.textColor = .gray // Устанавливаем цвет текста
        return label
    }()
    
    let statusTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your status" // Устанавливаем текст placeholder
        textField.layer.borderWidth = 2 // Устанавливаем ширину границы
        textField.layer.borderColor = UIColor.black.cgColor // Устанавливаем цвет границы
        textField.layer.cornerRadius = 12 // Скругляем углы текстового поля
        textField.layer.masksToBounds = true // Обрезаем содержимое по границам
        textField.borderStyle = .roundedRect // Устанавливаем стиль границы
        textField.addTarget(ProfileHeaderView.self, action: #selector(statusTextChanged(_:)), for: .editingChanged) // Добавляем целевое действие для изменения текста
        return textField
    }()
    
    let actionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Set Status", for: .normal) // Текст на кнопке
        button.setTitleColor(.white, for: .normal) // Цвет текста на кнопке
        button.backgroundColor = .systemBlue // Цвет фона кнопки
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18)
        button.layer.cornerRadius = 12 // Скругляем углы кнопки
        button.layer.masksToBounds = true
        button.addTarget(ProfileHeaderView.self, action: #selector(buttonPressed), for: .touchUpInside) // Добавляем обработчик нажатия
        return button
    }()
    
    private var statusText: String = "" // Переменная для хранения статуса
    
    var status: String {
        return statusText // Геттер для получения текущего статуса
    }
    
    // Инициализатор для создания view в коде
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews() // Настройка и размещение всех подвидов
    }
    
    // Инициализатор для создания view из storyboard или xib
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews() // Настройка и размещение всех подвидов
    }
    
    // Метод для настройки и размещения всех подвидов
    private func setupViews() {
        // Добавляем все подвиды на главный view
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(bioLabel)
        addSubview(statusTextField)
        addSubview(actionButton)
        
        // Устанавливаем constraints для profileImageView
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16) // Отступ сверху
            make.leading.equalToSuperview().offset(20) // Отступ слева
            make.size.equalTo(CGSize(width: 100, height: 100)) // Размер изображения
        }
        
        // Устанавливаем constraints для nameLabel
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(27) // Отступ сверху
            make.leading.equalTo(profileImageView.snp.trailing).offset(16) // Отступ слева от изображения
            make.trailing.equalToSuperview().offset(-20) // Отступ справа
        }
        
        // Устанавливаем constraints для bioLabel
        bioLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8) // Отступ сверху от nameLabel
            make.leading.equalTo(profileImageView.snp.trailing).offset(16) // Отступ слева от изображения
            make.trailing.equalToSuperview().offset(-20) // Отступ справа
        }
        
        // Устанавливаем constraints для statusTextField
        statusTextField.snp.makeConstraints { make in
            make.top.equalTo(bioLabel.snp.bottom).offset(8) // Отступ сверху от bioLabel
            make.leading.equalTo(profileImageView.snp.trailing).offset(16) // Отступ слева от изображения
            make.trailing.equalToSuperview().offset(-20) // Отступ справа
            make.height.equalTo(40) // Высота текстового поля
        }
        
        // Устанавливаем constraints для actionButton
        actionButton.snp.makeConstraints { make in
            make.top.equalTo(statusTextField.snp.bottom).offset(16) // Отступ сверху от текстового поля
            make.leading.trailing.equalToSuperview().inset(20) // Отступы слева и справа
            make.height.equalTo(50) // Высота кнопки
        }
        
        // Добавляем обработчик для нажатия на кнопку
        actionButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        // Добавляем обработчик для нажатия на изображение профиля
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageViewTapped))
        profileImageView.addGestureRecognizer(tapGesture)
    }
    
    // Метод, вызываемый при изменении текста в текстовом поле
    @objc private func statusTextChanged(_ textField: UITextField) {
        if let text = textField.text {
            statusText = text // Обновляем статус при изменении текста
        }
    }
    
    // Метод, вызываемый при нажатии на изображение профиля
    @objc private func profileImageViewTapped() {
        NotificationCenter.default.post(name: NSNotification.Name("AvatarTapped"), object: profileImageView)
    }
    
    // Метод, вызываемый при нажатии на кнопку
    @objc private func buttonPressed() {
        statusText = statusTextField.text ?? "" // Обновляем статус при нажатии на кнопку
        print("Status: \(status)") // Печатаем статус в консоль
    }
}
