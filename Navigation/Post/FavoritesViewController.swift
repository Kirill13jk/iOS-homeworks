import UIKit
import CoreData
import StorageService


class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {

    weak var coordinator: FavoriteCoordinator?
    var tableView: UITableView!

    // Добавляем NSFetchedResultsController
    var fetchedResultsController: NSFetchedResultsController<FavoritePostE>!

    var currentAuthorFilter: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupFetchedResultsController()

        let filterButton = UIBarButtonItem(title: "Фильтр", style: .plain, target: self, action: #selector(showFilterAlert))
        let clearFilterButton = UIBarButtonItem(title: "Сбросить", style: .plain, target: self, action: #selector(clearFilter))
        navigationItem.rightBarButtonItems = [clearFilterButton, filterButton]
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try? fetchedResultsController.performFetch()
        tableView.reloadData()
    }

    // MARK: - Настройка таблицы
    func setupTableView() {
        tableView = UITableView(frame: view.bounds)
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
    }

    // MARK: - Настройка NSFetchedResultsController
    func setupFetchedResultsController() {
        let context = CoreDataManager.shared.context
        let fetchRequest: NSFetchRequest<FavoritePostE> = FavoritePostE.fetchRequest()

        // Применяем фильтр по автору, если он есть
        if let authorFilter = currentAuthorFilter {
            fetchRequest.predicate = NSPredicate(format: "author == %@", authorFilter)
        }

        let sortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor]

        fetchedResultsController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )

        fetchedResultsController.delegate = self

        do {
            try fetchedResultsController.performFetch()
        } catch {
            print("Ошибка при выполнении запроса: \(error)")
        }
    }

    // MARK: - UITableViewDataSource методы
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fetchedResultsController.sections?[section].numberOfObjects ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostTableViewCell
        let favoritePost = fetchedResultsController.object(at: indexPath)

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

    // MARK: - Удаление поста
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Удалить") { [weak self] (action, view, completionHandler) in
            self?.deleteFavoritePost(at: indexPath)
            completionHandler(true)
        }

        return UISwipeActionsConfiguration(actions: [deleteAction])
    }

    func deleteFavoritePost(at indexPath: IndexPath) {
        let postToDelete = fetchedResultsController.object(at: indexPath)
        let context = CoreDataManager.shared.context

        context.delete(postToDelete)

        do {
            try context.save()
            print("Пост удалён из избранного")
        } catch {
            print("Ошибка при удалении поста: \(error)")
        }
    }

    // MARK: - NSFetchedResultsControllerDelegate методы
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>,
                    didChange anObject: Any,
                    at indexPath: IndexPath?,
                    for type: NSFetchedResultsChangeType,
                    newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let newIndexPath = newIndexPath {
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        case .delete:
            if let indexPath = indexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        case .update:
            if let indexPath = indexPath {
                let cell = tableView.cellForRow(at: indexPath) as! PostTableViewCell
                let favoritePost = fetchedResultsController.object(at: indexPath)
                let post = Post(
                    title: favoritePost.title ?? "",
                    author: favoritePost.author ?? "",
                    description: favoritePost.content ?? "",
                    image: favoritePost.imageData != nil ? UIImage(data: favoritePost.imageData!) : nil,
                    likes: Int(favoritePost.likes),
                    views: Int(favoritePost.views)
                )
                cell.configure(with: post, isFavorite: true)
            }
        case .move:
            if let indexPath = indexPath, let newIndexPath = newIndexPath {
                tableView.deleteRows(at: [indexPath], with: .automatic)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        @unknown default:
            fatalError("Неизвестный тип изменения в NSFetchedResultsController")
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    // MARK: - Фильтр
    @objc func showFilterAlert() {
        let alert = UIAlertController(title: "Фильтр по автору", message: "Введите имя автора", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Имя автора"
        }

        let applyAction = UIAlertAction(title: "Применить", style: .default) { [weak self] _ in
            if let authorName = alert.textFields?.first?.text, !authorName.isEmpty {
                self?.currentAuthorFilter = authorName
                self?.setupFetchedResultsController()
                self?.tableView.reloadData()
            }
        }

        let cancelAction = UIAlertAction(title: "Отмена", style: .cancel, handler: nil)

        alert.addAction(applyAction)
        alert.addAction(cancelAction)

        present(alert, animated: true, completion: nil)
    }

    @objc func clearFilter() {
        currentAuthorFilter = nil
        setupFetchedResultsController()
        tableView.reloadData()
    }
}
