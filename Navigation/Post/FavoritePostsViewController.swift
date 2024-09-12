import UIKit

class FavoritePostsViewController: UIViewController {
    weak var coordinator: FavoriteCoordinator?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.title = "Favorite Posts"
        
        // Здесь вы будете загружать данные из Core Data и отображать их в таблице или коллекции
    }
}
