import UIKit
import SnapKit

class ProfileHeaderView: UIView {
    // UI elements
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profile_avatar") // Устанавливаем изображение
        imageView.contentMode = .scaleAspectFit // Режим контента
        imageView.layer.cornerRadius = 50
        imageView.backgroundColor = .lightGray
        imageView.layer.borderWidth = 3
        imageView.layer.borderColor = UIColor.black.cgColor
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Hipster Cat"
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    let bioLabel: UILabel = {
        let label = UILabel()
        label.text = "Listening to music"
        label.font = UIFont.systemFont(ofSize: 16) // Шриф текста
        label.textColor = .gray // Цвет текста
        return label
    }()
    
    let statusTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter your status"
        textField.layer.borderWidth = 2
        textField.layer.borderColor = UIColor.black.cgColor // Устанавливаем цвет границы
        textField.layer.cornerRadius = 12 // Устанавливаем радиус загруления углов
        textField.layer.masksToBounds = true // Обрезаем содержимое по границам
        textField.borderStyle = .roundedRect // Устанавливаем стиль границы
        return textField
    }()
    
    let actionButton: CustomButton = {
        let button = CustomButton(
            title: "Set Status", // Текст на кнопке
            titleColor: .white, // Цвет текста на кнопке
            backgroundColor: .blue, // Цвет фона кнопки
            font: UIFont.systemFont(ofSize: 18)
        ) {
            print("Status button pressed") // Действие при нажатии кнопки
        }
        return button
    }()
    
    private var statusText: String = ""
    
    var status: String {
        return statusText
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        addSubview(profileImageView)
        addSubview(nameLabel)
        addSubview(bioLabel)
        addSubview(statusTextField)
        addSubview(actionButton)
        
        profileImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(16)
            make.leading.equalToSuperview().offset(20)
            make.size.equalTo(CGSize(width: 100, height: 100))
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(27)
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
        }
        
        bioLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(8)
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
        }
        
        statusTextField.snp.makeConstraints { make in
            make.top.equalTo(bioLabel.snp.bottom).offset(8)
            make.leading.equalTo(profileImageView.snp.trailing).offset(16)
            make.trailing.equalToSuperview().offset(-20)
            make.height.equalTo(40)
        }
        
        actionButton.snp.makeConstraints { make in
            make.top.equalTo(statusTextField.snp.bottom).offset(16)
            make.leading.trailing.equalToSuperview().inset(20)
            make.height.equalTo(50)
        }
        
        // Add action for button
        actionButton.addTarget(self, action: #selector(buttonPressed), for: .touchUpInside)
        
        // Добавляем обработчик для нажатия на изображение профиля
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageViewTapped))
        profileImageView.addGestureRecognizer(tapGesture)
    }
    
    @objc private func statusTextChanged(_ textField: UITextField) {
        if let text = textField.text {
            statusText = text // Обновляем статус при изменении текста
        }
    }
    
    @objc private func profileImageViewTapped() {
        NotificationCenter.default.post(name: NSNotification.Name("AvatarTapped"), object: profileImageView)
    }
    
    @objc private func buttonPressed() {
        statusText = statusTextField.text ?? "" // Обновляем статус при нажатии на кнопку
        print("Status: \(status)") // Печатаем статус в консоль
    }
}
