import Foundation
import CoreData

class CoreDataManager {
    static let shared = CoreDataManager()
    private init() {}
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model") // Замените "Model" на имя вашей модели
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
    
    // Фоновой конекст
    var backgroundContext: NSManagedObjectContext {
        return persistentContainer.newBackgroundContext()
    }
    
    // Метод для сохранения контекста
    func saveContext (context: NSManagedObjectContext) {
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
