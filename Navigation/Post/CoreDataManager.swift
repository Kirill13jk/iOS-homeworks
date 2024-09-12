import UIKit
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    
    // Ссылка на AppDelegate для доступа к persistentContainer
    private let persistentContainer: NSPersistentContainer
    
    private init() {
        // Инициализация persistentContainer
        persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }
    
    // MARK: - Контекст для работы с Core Data
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Сохранение контекста
    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

    // MARK: - Добавление публикации
    func savePost(title: String, author: String, likes: Int32, image: Data?, description: String, viewCount: Int32) {
        let newPost = Post(context: context)
        newPost.title = title
        newPost.author = author
        newPost.likes = likes
        newPost.image = image
        newPost.postDescription = description
        newPost.viewCount = viewCount
        
        saveContext()
    }
    
    // MARK: - Извлечение всех публикаций
    func fetchAllPosts() -> [Post] {
        let fetchRequest: NSFetchRequest<Post> = Post.fetchRequest()
        
        do {
            let posts = try context.fetch(fetchRequest)
            return posts
        } catch {
            print("Failed to fetch posts: \(error)")
            return []
        }
    }

    // MARK: - Удаление публикации
    func deletePost(_ post: Post) {
        context.delete(post)
        saveContext()
    }
}
