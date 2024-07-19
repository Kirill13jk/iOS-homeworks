import UIKit
import StorageService

class ProfileViewController: UIViewController {
    // Слабая ссылка на координатор для избежания циклов сильных ссылок
    weak var coordinator: ProfileCoordinator?

    // Создаем таблицу для отображения данных профиля и постов
    private let tableView = UITableView()
    // Создаем заголовок для профиля
    private let profileHeaderView = ProfileHeaderView()
    // Оверлей для анимации увеличения аватара
    private let overlayView = UIView()
    // Кнопка закрытия увеличенного аватара
    private let closeButton = UIButton(type: .system)
    // Оригинальная позиция аватара для анимации
    private var avatarOriginalFrame: CGRect?
    // Увеличенный аватар для анимации
    private var enlargedAvatarImageView: UIImageView?
    // Пользователь, информация о котором будет отображена
    var user: User?
    
    // Поле для аватара пользователя
    private lazy var avatarImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 50
        imageView.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(avatarTapped))
        imageView.addGestureRecognizer(tapGesture)
        return imageView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        // Настройка профиля
        setupProfile()
        // Настройка UI элементов
        setupUI()
        // Настройка таблицы и заголовка
        setupTableView()
        setupTableHeaderView()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: "PhotosCell")

        // Подписываемся на уведомление о нажатии на аватар
        NotificationCenter.default.addObserver(self, selector: #selector(handleAvatarTapped(_:)), name: NSNotification.Name("AvatarTapped"), object: nil)
    }
    
    // Метод для настройки профиля пользователя
    private func setupProfile() {
        guard let user = user else { return }
        avatarImageView.image = user.avatar
    }

    // Метод для настройки UI элементов
    private func setupUI() {
        view.addSubview(tableView) // Добавляем таблицу на главный view
    }

    // Метод для настройки таблицы
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    // Настройка заголовка таблицы
    private func setupTableHeaderView() {
        // Устанавливаем frame для profileHeaderView
        profileHeaderView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 200)
        
        // Добавляем avatarImageView в profileHeaderView
        profileHeaderView.addSubview(avatarImageView)
        
        // Настройка констрейнтов для avatarImageView внутри profileHeaderView
        NSLayoutConstraint.activate([
            avatarImageView.centerXAnchor.constraint(equalTo: profileHeaderView.centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: profileHeaderView.topAnchor, constant: 50),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // Установка profileHeaderView как tableHeaderView таблицы
        tableView.tableHeaderView = profileHeaderView
    }

    // Метод для обработки нажатия на аватар
    @objc private func handleAvatarTapped(_ notification: Notification) {
        guard let avatarImageView = notification.object as? UIImageView else { return }

        avatarOriginalFrame = avatarImageView.superview?.convert(avatarImageView.frame, to: nil)

        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlayView.alpha = 0
        overlayView.frame = view.bounds
        view.addSubview(overlayView)

        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .white
        closeButton.alpha = 0
        closeButton.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30)
        ])

        enlargedAvatarImageView = UIImageView(image: avatarImageView.image)
        enlargedAvatarImageView!.contentMode = .scaleAspectFill
        enlargedAvatarImageView!.clipsToBounds = true
        enlargedAvatarImageView!.frame = avatarOriginalFrame!
        enlargedAvatarImageView!.layer.cornerRadius = 0
        enlargedAvatarImageView!.layer.masksToBounds = true
        view.addSubview(enlargedAvatarImageView!)

        UIView.animate(withDuration: 0.5, animations: {
            self.enlargedAvatarImageView!.frame = CGRect(x: 0, y: (self.view.frame.height - self.view.frame.width) / 2, width: self.view.frame.width, height: self.view.frame.width)
            self.overlayView.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.closeButton.alpha = 1
            }
        }
    }

    // Метод для обработки нажатия на кнопку закрытия
    @objc private func handleCloseButton() {
        guard let enlargedAvatarImageView = self.enlargedAvatarImageView else { return }

        UIView.animate(withDuration: 0.3, animations: {
            self.closeButton.alpha = 0
        }) { _ in
            UIView.animate(withDuration: 0.5, animations: {
                enlargedAvatarImageView.frame = self.avatarOriginalFrame!
                self.overlayView.alpha = 0
            }) { _ in
                enlargedAvatarImageView.removeFromSuperview()
                self.overlayView.removeFromSuperview()
                self.closeButton.removeFromSuperview()
                self.enlargedAvatarImageView = nil
            }
        }
    }

    // Метод для обработки нажатия на аватар
    @objc private func avatarTapped() {
        NotificationCenter.default.post(name: NSNotification.Name("AvatarTapped"), object: avatarImageView)
    }
}

// Расширение для поддержки таблицы
extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return posts.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhotosCell", for: indexPath) as? PhotosTableViewCell else {
                return UITableViewCell()
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostTableViewCell else {
                return UITableViewCell()
            }
            let post = posts[indexPath.row]
            cell.configure(with: post)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil // Убираем заголовок секции
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0 // Устанавливаем высоту заголовка секции в 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let photoGalleryVC = PhotosViewController()
            navigationController?.pushViewController(photoGalleryVC, animated: true)
        }
    }
}
