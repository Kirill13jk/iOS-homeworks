import UIKit
import CoreData
import StorageService


class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    weak var coordinator: FavoriteCoordinator?

    var tableView: UITableView!
    var favoritePosts: [FavoritePostE] = []
    
    var currentAuthorFilter: String?


    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchFavoritePosts()
        
        let filterButton = UIBarButtonItem(title: "Фильтр", style: .plain, target: self, action: #selector(showFilterAlert))
        let clearFilterButton = UIBarButtonItem(title: "Сбросить", style: .plain, target: self, action: #selector(clearFilter))
        navigationItem.rightBarButtonItems = [clearFilterButton, filterButton]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fetchFavoritePosts() // Обновляем данные при появлении экрана
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {

        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] (action, view, completionHandler) in
            self?.deleteFavoritePost(at: indexPath)
            completionHandler(true)
        }

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
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

        // Применяем фильтр, если нужно
        if let authorFilter = currentAuthorFilter {
            fetchRequest.predicate = NSPredicate(format: "author == %@", authorFilter)
        }

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
        let post = Post(
            title: favoritePost.title ?? "",
            author: favoritePost.author ?? "",
            description: favoritePost.content ?? "",
            image: favoritePost.imageData != nil ? UIImage(data: favoritePost.imageData!) : nil,
            likes: Int(favoritePost.likes),
            views: Int(favoritePost.views)
        )

        cell.configure(with: post, isFavorite: true)

        return cell
    }

    func deleteFavoritePost(at indexPath: IndexPath) {
        let postToDelete = favoritePosts[indexPath.row]
        let context = CoreDataManager.shared.context

        context.delete(postToDelete)
        favoritePosts.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)

        do {
            try context.save()
            print("Пост удалён из избранного")
        } catch {
            print("Ошибка при удалении поста: \(error)")
        }
    }
    
    @objc func showFilterAlert() {
        let alert = UIAlertController(title: "Фильтр по автору", message: "Введите имя автора", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Имя автора"
        }

        let applyAction = UIAlertAction(title: "Применить", style: .default) { [weak self] _ in
            if let authorName = alert.textFields?.first?.text, !authorName.isEmpty {
                self?.currentAuthorFilter = authorName
                self?.fetchFavoritePosts()
            }
        }

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)

        alert.addAction(applyAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

    @objc func clearFilter() {
        currentAuthorFilter = nil
        fetchFavoritePosts()
    }

}

