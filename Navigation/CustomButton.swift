import UIKit

// Кастомная кнопка с преднастроенными параметрами
class CustomButton: UIButton {
    
    private var action: (() -> Void)?
    
    // Инициализатор с параметрами title, titleColor и замыканием для действия
    init(title: String, titleColor: UIColor, backgroundColor: UIColor, font: UIFont, action: @escaping () -> Void) {
        super.init(frame: .zero) // Вызываем инициализатор суперкласса
        self.setTitle(title, for: .normal) // Устанавливаем текст кнопки
        self.setTitleColor(titleColor, for: .normal) // Устанавливаем цвет кнопки
        self.backgroundColor = backgroundColor // Устанавливаем цвет фона кнопки
        self.titleLabel?.font = font // Шрифт текста кнопки
        self.action = action // Сохраняем переданное действие в переменную
        self.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside) // Добавляем целевое действие для нажатия на кнопку
        self.layer.cornerRadius = 10 // Закругляем углы кнопки
        self.layer.masksToBounds = true // Устанавливаем маску для границ, чтобы закругленные углы были видны
        self.translatesAutoresizingMaskIntoConstraints = false // Отключаем автазадаваемые констрейты
    }
    
    // Требуемый инициализатор для кодирования из Interface Builder(не используется, но должен быть реализован)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc private func buttonTapped() {
        action?() // Выполняем сохраненное действие
    }
}
