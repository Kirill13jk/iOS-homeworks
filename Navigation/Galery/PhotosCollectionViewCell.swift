import UIKit

// Класс ячейки для отображения фото в коллекции
class PhotosCollectionViewCell: UICollectionViewCell {
    
    // Создаем UIImageView для отображения изображения
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    // Инициализация при создании ячейки программно
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews() // Настраиваем вид ячейки
    }
    
    // Инициализация при создании ячейки из storyboard или xib
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews() // Настраиваем вид ячейки
    }
    
    // Метод для настройки вида ячейки
    private func setupViews() {
        contentView.addSubview(imageView) // Добавляем imageView в contentView ячейки
        
        // Устанавливаем констрейнты для imageView
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            imageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            imageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
    }
    
    // Метод для конфигурации ячейки с изображением
    func configure(with image: UIImage?) {
        imageView.image = image // Устанавливаем изображение в imageView
    }
}
