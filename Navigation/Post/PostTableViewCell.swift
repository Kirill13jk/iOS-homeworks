import UIKit
import StorageService
import iOSIntPackage

protocol PostTableViewCellDelegate: AnyObject {
    func postTableViewCellDidDoubleTap(_ cell: PostTableViewCell)
}


class PostTableViewCell: UITableViewCell {
    // Создаем UILabel для отображения заголовка поста
    let postTitleLabel = UILabel()
    // Создаем UILabel для отображения автора поста
    let postAuthorLabel = UILabel()
    // Создаем UILabel для отображения описания поста
    let postDescriptionLabel = UILabel()
    // Создаем UIImageView для отображения изображения поста
    let postImageView = UIImageView()
    // Создаем UILabel для отображения количества лайков
    let postLikesLabel = UILabel()
    // Создаем UILabel для отображения количества просмотров
    let postViewsLabel = UILabel()
    
    weak var delegate: PostTableViewCellDelegate?

    // Инициализатор для создания ячейки в коде
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell() // Настраиваем ячейку
    }

    // Инициализатор для создания ячейки из storyboard или xib
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell() // Настраиваем ячейку
    }

    // Метод для настройки ячейки
    private func setupCell() {
        // Отключаем автоматические ограничения для UI элементов
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        postTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        postAuthorLabel.translatesAutoresizingMaskIntoConstraints = false
        postDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        postLikesLabel.translatesAutoresizingMaskIntoConstraints = false
        postViewsLabel.translatesAutoresizingMaskIntoConstraints = false

        // Добавляем UI элементы в contentView ячейки
        contentView.addSubview(postImageView)
        contentView.addSubview(postTitleLabel)
        contentView.addSubview(postAuthorLabel)
        contentView.addSubview(postDescriptionLabel)
        contentView.addSubview(postLikesLabel)
        contentView.addSubview(postViewsLabel)

        // Устанавливаем ограничения для postImageView
        NSLayoutConstraint.activate([
            // Верхний отступ от верхней части contentView
            postImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                postImageView.heightAnchor.constraint(equalToConstant: 240),

            // Устанавливаем ограничения для postTitleLabel
            // Верхний отступ от нижней части postImageView
            postTitleLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 16),
            // Левый отступ от contentView
            postTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            // Правый отступ от contentView
            postTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            // Устанавливаем ограничения для postAuthorLabel
            // Верхний отступ от нижней части postTitleLabel
            postAuthorLabel.topAnchor.constraint(equalTo: postTitleLabel.bottomAnchor, constant: 16),
            // Левый отступ от contentView
            postAuthorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            // Правый отступ от contentView
            postAuthorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            // Устанавливаем ограничения для postDescriptionLabel
            // Верхний отступ от нижней части postAuthorLabel
            postDescriptionLabel.topAnchor.constraint(equalTo: postAuthorLabel.bottomAnchor, constant: 16),
            // Левый отступ от contentView
            postDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            // Правый отступ от contentView
            postDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            // Устанавливаем ограничения для postLikesLabel
            // Верхний отступ от нижней части postDescriptionLabel
            postLikesLabel.topAnchor.constraint(equalTo: postDescriptionLabel.bottomAnchor, constant: 16),
            // Левый отступ от contentView
            postLikesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),

            // Устанавливаем ограничения для postViewsLabel
            // Верхний отступ от нижней части postDescriptionLabel
            postViewsLabel.topAnchor.constraint(equalTo: postDescriptionLabel.bottomAnchor, constant: 16),
            // Левый отступ от правой части postLikesLabel
            postViewsLabel.leadingAnchor.constraint(equalTo: postLikesLabel.trailingAnchor, constant: 10),
            // Правый отступ от contentView
            postViewsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            // Нижний отступ от нижней части contentView
            postViewsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])

        // Добавляем распознаватель двойного нажатия
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapGesture)
        
        // Устанавливаем цвет текста для postDescriptionLabel
        postDescriptionLabel.textColor = UIColor.gray
    }

    @objc private func handleDoubleTap() {
        delegate?.postTableViewCellDidDoubleTap(self)
    }
    
    // Метод для конфигурации ячейки с данными поста
    func configure(with post: Post) {
        // Устанавливаем текст заголовка поста
        postTitleLabel.text = post.title
        // Устанавливаем текст автора поста
        postAuthorLabel.text = "Author: \(post.author)"
        // Устанавливаем текст описания поста
        postDescriptionLabel.text = post.description
        // Устанавливаем режим отображения изображения
        postImageView.contentMode = .scaleAspectFill
        // Устанавливаем текст количества лайков
        postLikesLabel.text = "Likes: \(post.likes)"
        // Устанавливаем текст количества просмотров
        postViewsLabel.text = "Views: \(post.views)"

        // Если у поста есть изображение, применяем фильтр
        if let image = post.image {
            applyFilter(to: image)
        }
    }

    // Метод для применения фильтра к изображению
    private func applyFilter(to image: UIImage) {
        // Создаем экземпляр процессора изображений
        let processor = ImageProcessor()
        // Применяем фильтр и обрабатываем изображение асинхронно
        processor.processImage(sourceImage: image, filter: .chrome, completion: { processedImage in
            // Обновляем изображение в UIImageView на главном потоке
            DispatchQueue.main.async {
                self.postImageView.image = processedImage
            }
        })
    }
}
