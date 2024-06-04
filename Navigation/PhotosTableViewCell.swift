import UIKit

class PhotosTableViewCell: UITableViewCell {
    
    private var photoImageViews: [UIImageView] = []
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Photos"
        label.font = UIFont.boldSystemFont(ofSize: 24)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let arrowImage: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "arrow.right"), for: .normal)
        button.tintColor = .gray
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    private func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(arrowImage)
        contentView.addSubview(stackView)
        
        for i in 1...4 {
            let imageView = UIImageView()
            imageView.contentMode = .scaleAspectFill
            imageView.clipsToBounds = true
            imageView.layer.cornerRadius = 8
            imageView.backgroundColor = .lightGray
            imageView.translatesAutoresizingMaskIntoConstraints = false
            if let image = UIImage(named: "photo\(i)") {
                imageView.image = image
            }
            photoImageViews.append(imageView)
            stackView.addArrangedSubview(imageView)
        }
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            
            arrowImage.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor),
            arrowImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            
            stackView.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 12),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            stackView.heightAnchor.constraint(equalToConstant: (UIScreen.main.bounds.width - 12*2 - 8*3) / 4),
                                    
            contentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 160)
        ])
    }
}
