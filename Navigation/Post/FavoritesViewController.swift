import UIKit

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    weak var coordinator: FavoriteCoordinator?

    var tableView: UITableView!
    var favoritePosts: [FavoritePostE] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchFavoritePosts()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavoritePosts() // Обновляем данные при появлении экрана
    }

    func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }

    func fetchFavoritePosts() {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<FavoritePostE> = FavoritePostE.fetchRequest()

        do {
            favoritePosts = try context.fetch(fetchRequest)
            tableView.reloadData()
        } catch {
            print("Ошибка при загрузке данных: \(error)")
        }
    }

    // MARK: - UITableViewDataSource методы

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return favoritePosts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        let favoritePost = favoritePosts[indexPath.row]

        // Создаем объект Post для переиспользования метода configure
        let post = Post(title: favoritePost.title ?? "",
                        description: favoritePost.content ?? "",
                        image: favoritePost.imageData != nil ? UIImage(data: favoritePost.imageData!) : nil,
                        likes: Int(favoritePost.likes),
                        views: Int(favoritePost.views),
                        author: favoritePost.author ?? "")

        cell.configure(with: post)

        return cell
    }

    // MARK: - UITableViewDelegate методы (если нужны)

    // Реализуйте методы UITableViewDelegate, если это необходимо
}

