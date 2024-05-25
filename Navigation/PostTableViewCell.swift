import UIKit

class PostTableViewCell: UITableViewCell {
    let postTitleLabel = UILabel()
    let postAuthorLabel = UILabel()
    let postDescriptionLabel = UILabel()
    let postImageView = UIImageView()
    let postLikesLabel = UILabel()
    let postViewsLabel = UILabel()
    



    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCell()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupCell()
    }

    private func setupCell() {
        // Настройка UI элементов и добавление их в contentView
        postImageView.translatesAutoresizingMaskIntoConstraints = false
        postTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        postAuthorLabel.translatesAutoresizingMaskIntoConstraints = false
        postDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        postLikesLabel.translatesAutoresizingMaskIntoConstraints = false
        postViewsLabel.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(postImageView)
        contentView.addSubview(postTitleLabel)
        contentView.addSubview(postAuthorLabel)
        contentView.addSubview(postDescriptionLabel)
        contentView.addSubview(postLikesLabel)
        contentView.addSubview(postViewsLabel)

        // Установите констрейнты для элементов
        NSLayoutConstraint.activate([
            postImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            postImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            postImageView.widthAnchor.constraint(equalToConstant: 500),
            postImageView.heightAnchor.constraint(equalToConstant: 240),

            postTitleLabel.topAnchor.constraint(equalTo: postImageView.bottomAnchor, constant: 16),
            postTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            postTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            postAuthorLabel.topAnchor.constraint(equalTo: postTitleLabel.bottomAnchor, constant: 16),
            postAuthorLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            postAuthorLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            postDescriptionLabel.topAnchor.constraint(equalTo: postAuthorLabel.bottomAnchor, constant: 16),
            postDescriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            postDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),

            postLikesLabel.topAnchor.constraint(equalTo: postDescriptionLabel.bottomAnchor, constant: 16),
            postLikesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),

            postViewsLabel.topAnchor.constraint(equalTo: postDescriptionLabel.bottomAnchor, constant: 16),
            postViewsLabel.leadingAnchor.constraint(equalTo: postLikesLabel.trailingAnchor, constant: 10),
            postViewsLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            postViewsLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -16)
        ])
        postDescriptionLabel.textColor = UIColor.gray
    }

    func configure(with post: Post) {
        postTitleLabel.text = post.title
        postAuthorLabel.text = "Author: \(post.author)"
        postDescriptionLabel.text = post.description
        postImageView.contentMode = .scaleAspectFit
        postImageView.image = post.image
        postLikesLabel.text = "Likes: \(post.likes)"
        postViewsLabel.text = "Views: \(post.views)"
    }
}
