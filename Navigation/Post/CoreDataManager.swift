import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    // Инициализация NSPersistentContainer
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model") // Имя должно совпадать с именем вашего .xcdatamodeld файла
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Не удалось загрузить хранилище данных: \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // Контекст для выполнения операций
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // Метод для сохранения контекста
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Не удалось сохранить контекст: \(nserror), \(nserror.userInfo)")
            }
        }
    }
}
