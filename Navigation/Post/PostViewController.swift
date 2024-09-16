import UIKit
import CoreData
import StorageService

class PostViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PostTableViewCellDelegate {
    func postTableViewCellDidTapFavoriteButton(_ cell: PostTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let post = posts[indexPath.row]
        savePostToFavorites(post)
        
        // Обновляем иконку на кнопке избранного
        cell.favoriteButton.setImage(UIImage(systemName: "star.fill"), for: .normal)
    }
    
    
    var tableView: UITableView!
    var posts: [Post] = [] // Массив постов

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .systemBackground
        title = "Лента"
        
        // Добавляем кнопку "Info" в навигационную панель
        let infoButton = UIBarButtonItem(title: "Info", style: .plain, target: self, action: #selector(showInfoViewController))
        navigationItem.rightBarButtonItem = infoButton

        setupTableView()
        loadPosts()
    }
    
    // Метод для настройки UITableView
    func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }

    // Метод для загрузки постов
    func loadPosts() {
        posts = Post.makeMockPosts()
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource методы

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        let post = posts[indexPath.row]
        let isFavorite = isPostInFavorites(post)
        cell.configure(with: post, isFavorite: isFavorite)

        cell.delegate = self // Устанавливаем делегата
        return cell
    }
    
    func isPostInFavorites(_ post: Post) -> Bool {
        let backgroundContext = CoreDataManager.shared.backgroundContext
        let fetchRequest: NSFetchRequest<FavoritePostE> = FavoritePostE.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@ AND author == %@", post.title, post.author)

        do {
            let results = try backgroundContext.fetch(fetchRequest)
            return !results.isEmpty
        } catch {
            print("Ошибка при проверке избранного: \(error)")
            return false
        }
    }


    // MARK: - PostTableViewCellDelegate метод

    func postTableViewCellDidDoubleTap(_ cell: PostTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let post = posts[indexPath.row]
        savePostToFavorites(post)
    }

    // Метод для сохранения поста в избранное
    func savePostToFavorites(_ post: Post) {
        let backgroundContext = CoreDataManager.shared.backgroundContext

        backgroundContext.perform {
            // Проверяем, нет ли уже этого поста в избранном
            let fetchRequest: NSFetchRequest<Navigation.FavoritePostE> = Navigation.FavoritePostE.fetchRequest()

            fetchRequest.predicate = NSPredicate(format: "title == %@ AND author == %@", post.title, post.author)

            do {
                let results: [Navigation.FavoritePostE] = try backgroundContext.fetch(fetchRequest)

                if results.isEmpty {
                    // Создаем новый объект FavoritePostE
                    let favoritePost = FavoritePostE(context: backgroundContext)
                    favoritePost.title = post.title
                    favoritePost.author = post.author
                    favoritePost.content = post.description
                    favoritePost.likes = Int64(post.likes)
                    favoritePost.views = Int64(post.views)
                    if let image = post.image {
                        favoritePost.imageData = image.pngData()
                    }

                    // Сохраняем контекст
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


    // MARK: - UITableViewDelegate методы (если нужны)

    // Реализуйте другие методы UITableViewDelegate, если это необходимо

    // MARK: - Обработка кнопки Info

    @objc func showInfoViewController() {
        let infoViewController = InfoViewController()
        present(infoViewController, animated: true, completion: nil)
    }
}
