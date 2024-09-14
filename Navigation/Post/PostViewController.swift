import UIKit
import CoreData
import StorageService

class PostsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, PostTableViewCellDelegate {
    
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
        // Здесь вы должны загрузить ваши посты в массив posts
        // Например, если у вас есть функция получения постов из StorageService
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
        cell.configure(with: post)
        cell.delegate = self // Устанавливаем делегата
        return cell
    }

    // MARK: - PostTableViewCellDelegate метод

    func postTableViewCellDidDoubleTap(_ cell: PostTableViewCell) {
        guard let indexPath = tableView.indexPath(for: cell) else { return }
        let post = posts[indexPath.row]
        savePostToFavorites(post)
    }

    // Метод для сохранения поста в избранное
    func savePostToFavorites(_ post: Post) {
        let context = CoreDataManager.shared.context

        // Проверяем, нет ли уже этого поста в избранном
        let fetchRequest: NSFetchRequest<FavoritePostE> = FavoritePostE.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "title == %@ AND author == %@", post.title, post.author)

        do {
            let results = try context.fetch(fetchRequest)
            if results.isEmpty {
                // Создаем новый объект FavoritePostE
                let favoritePost = FavoritePostE(context: context)
                favoritePost.title = post.title
                favoritePost.author = post.author
                favoritePost.content = post.description
                favoritePost.likes = Int64(post.likes)
                favoritePost.views = Int64(post.views)
                if let image = post.image {
                    favoritePost.imageData = image.pngData()
                }

                // Сохраняем контекст
                CoreDataManager.shared.saveContext()
                print("Пост сохранён в избранное")
            } else {
                print("Пост уже находится в избранном")
            }
        } catch {
            print("Ошибка при сохранении поста: \(error)")
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
