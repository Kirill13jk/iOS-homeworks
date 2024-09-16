import UIKit
import StorageService
import iOSIntPackage

protocol PostTableViewCellDelegate: AnyObject {
    func postTableViewCellDidDoubleTap(_ cell: PostTableViewCell)
    func postTableViewCellDidTapFavoriteButton(_ cell: PostTableViewCell)
}

class PostTableViewCell: UITableViewCell {
    
    let favoriteButton = UIButton()

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
        
        // Отключаем автоматические ограничения для favoriteButton
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false

        // Устанавливаем изображение для кнопки
        favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        favoriteButton.tintColor = .systemBlue

        // Добавляем обработчик нажатия
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)

        // Добавляем кнопку в contentView
        contentView.addSubview(favoriteButton)

        // Устанавливаем ограничения для favoriteButton
        NSLayoutConstraint.activate([
            favoriteButton.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            favoriteButton.widthAnchor.constraint(equalToConstant: 24),
            favoriteButton.heightAnchor.constraint(equalToConstant: 24),
        ])

        // Устанавливаем ограничения для postImageView
        NSLayoutConstraint.activate([
            // Верхний отступ от верхней части contentView
            postImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
                postImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
                postImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
                postImageView.heightAnchor.constraint(equalToConstant: 240),

            // Устанавливаем ограничения для postTitleLabel
            postTitleLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 16),
            postTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            postTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            // Устанавливаем ограничения для postAuthorLabel
            postAuthorLabel.topAnchor.constraint(equalTo: postTitleLabel.bottomAnchor, constant: 16),
            postAuthorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            postAuthorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            // Устанавливаем ограничения для postDescriptionLabel
            postDescriptionLabel.topAnchor.constraint(equalTo: postAuthorLabel.bottomAnchor, constant: 16),
            postDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            postDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            // Устанавливаем ограничения для postLikesLabel
            postLikesLabel.topAnchor.constraint(equalTo: postDescriptionLabel.bottomAnchor, constant: 16),
            postLikesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),

            // Устанавливаем ограничения для postViewsLabel
            postViewsLabel.topAnchor.constraint(equalTo: postDescriptionLabel.bottomAnchor, constant: 16),
            postViewsLabel.leadingAnchor.constraint(equalTo: postLikesLabel.trailingAnchor, constant: 10),
            postViewsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            postViewsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])

        // Добавляем распознаватель двойного нажатия
        let doubleTapGesture = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTap))
        doubleTapGesture.numberOfTapsRequired = 2
        self.addGestureRecognizer(doubleTapGesture)
        
        postDescriptionLabel.textColor = UIColor.gray
    }
    
    @objc private func favoriteButtonTapped() {
        delegate?.postTableViewCellDidTapFavoriteButton(self)
    }

    @objc private func handleDoubleTap() {
        delegate?.postTableViewCellDidDoubleTap(self)
    }

    // Метод для конфигурации ячейки с данными поста
    func configure(with post: Post, isFavorite: Bool) {
        postTitleLabel.text = post.title
        postAuthorLabel.text = "Author: \(post.author)"
        postDescriptionLabel.text = post.description
        postImageView.contentMode = .scaleAspectFill
        postLikesLabel.text = "Likes: \(post.likes)"
        postViewsLabel.text = "Views: \(post.views)"

        // Применение фильтра для изображения
        if let image = post.image {
            applyFilter(to: image)
        }

        // Установка состояния кнопки "Избранное"
        if isFavorite {
            favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
        } else {
            favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
        }
    }

    // Метод для применения фильтра к изображению
    private func applyFilter(to image: UIImage) {
        let processor = ImageProcessor()
        processor.processImage(sourceImage: image, filter: .chrome, completion: { processedImage in
            DispatchQueue.main.async {
                self.postImageView.image = processedImage
            }
        })
    }
}
