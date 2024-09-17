import UIKit
import FirebaseAuth
import StorageService
import CoreData


class ProfileViewController: UIViewController, PostTableViewCellDelegate {

    // Метод делегата для обработки двойного нажатия на ячейку
    func postTableViewCellDidDoubleTap(_ cell: PostTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let post = posts[indexPath.row]
        savePostToFavorites(post)  // Сохраняем пост в избранное по двойному тапу
        // Обновляем иконку после добавления в избранное
        cell.favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
    }
    
    // Метод делегата для нажатия на кнопку избранного
    func postTableViewCellDidTapFavoriteButton(_ cell: PostTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let post = posts[indexPath.row]
        savePostToFavorites(post)
        // Обновляем иконку
        cell.favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
    }
    
    weak var coordinator: ProfileCoordinator?
    private var posts: [Post] = []

    private let tableView = UITableView()
    private let profileHeaderView = ProfileHeaderView()
    private let overlayView = UIView()
    private let closeButton = UIButton(type: .system)
    private var avatarOriginalFrame: CGRect?
    private var enlargedAvatarImageView: UIImageView?
    var user: User?
    
    let favoriteButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "star"), for: .normal)
        button.tintColor = .systemYellow
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
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

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOutTapped))
        
        setupProfile()
        setupUI()
        setupTableView()
        setupTableHeaderView()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: "PhotosCell")

        NotificationCenter.default.addObserver(self, selector: #selector(handleAvatarTapped(_:)), name: NSNotification.Name("AvatarTapped"), object: nil)
        
        loadPosts()
        
    }
    
    
    
    func savePostToFavorites(_ post: Post) {
        let backgroundContext = CoreDataManager.shared.backgroundContext

        backgroundContext.perform {
            let fetchRequest: NSFetchRequest<FavoritePostE> = FavoritePostE.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "title == %@ AND author == %@", post.title, post.author)

            do {
                let results = try backgroundContext.fetch(fetchRequest)
                if results.isEmpty {
                    let favoritePost = FavoritePostE(context: backgroundContext)
                    favoritePost.title = post.title
                    favoritePost.author = post.author
                    favoritePost.content = post.description
                    favoritePost.likes = Int64(post.likes)
                    favoritePost.views = Int64(post.views)
                    if let image = post.image {
                        favoritePost.imageData = image.pngData()
                    }

                    try backgroundContext.save()
                    print("Пост сохранён в избранное")
                } else {
                    print("Пост уже находится в избранном")
                }
            } catch {
                print("Ошибка при сохранении поста: \(error)")
            }
        }
    }

    
    private func setupLogoutButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Log Out", style: .plain, target: self, action: #selector(logOutTapped))
    }

    @objc private func logOutTapped() {
        do {
            try Auth.auth().signOut()  // Выполняем выход из Firebase
            coordinator?.didFinishLogout()  // Сообщаем координатору о завершении сессии
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
            // Здесь можно добавить отображение ошибки для пользователя
        }
    }

    
    private func setupProfile() {
        guard let user = user else { return }
        avatarImageView.image = user.avatar
    }

    private func setupUI() {
        view.addSubview(tableView)
    }

    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func setupTableHeaderView() {
        profileHeaderView.frame = CGRect(x: 0, y: 0, width: tableView.frame.width, height: 200)
        profileHeaderView.addSubview(avatarImageView)
        NSLayoutConstraint.activate([
            avatarImageView.centerXAnchor.constraint(equalTo: profileHeaderView.centerXAnchor),
            avatarImageView.topAnchor.constraint(equalTo: profileHeaderView.topAnchor, constant: 50),
            avatarImageView.widthAnchor.constraint(equalToConstant: 100),
            avatarImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        tableView.tableHeaderView = profileHeaderView
    }

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

    @objc private func avatarTapped() {
        NotificationCenter.default.post(name: NSNotification.Name("AvatarTapped"), object: avatarImageView)
    }

    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

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
            let isFavorite = isPostInFavorites(post)
            
            cell.configure(with: post, isFavorite: isFavorite)
            cell.delegate = self

            // Проверяем, находится ли пост в избранном, и обновляем иконку
            if isPostInFavorites(post) {
                cell.favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
            } else {
                cell.favoriteButton.setImage(UIImage(systemName: "star"), for: .normal)
            }

            return cell
        }
    }
    
    func isPostInFavorites(_ post: Post) -> Bool {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<FavoritePostE> = FavoritePostE.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@ AND author == %@", post.title, post.author)

        do {
            let results = try context.fetch(fetchRequest)
            return !results.isEmpty
        } catch {
            print("Ошибка при проверке избранного: \(error)")
            return false
        }
    }



    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let photoGalleryVC = PhotosViewController()
            navigationController?.pushViewController(photoGalleryVC, animated: true)
        }
    }
    
    private func loadPosts() {
        posts = Post.makeMockPosts() 
        tableView.reloadData()
    }

}
