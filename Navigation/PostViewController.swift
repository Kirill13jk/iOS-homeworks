import UIKit

class PostViewController: UIViewController {
    var post: Post? // Свойство для хранения поста
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .lightGray
        title = post?.title ?? "Пост"
        
        let infoButton = UIBarButtonItem(title: "Info", style: .plain, target: self, action: #selector(showInfoViewController))
        navigationItem.rightBarButtonItem = infoButton
    }
    
    @objc func showInfoViewController() {
        let infoViewController = InfoViewController()
        present(infoViewController, animated: true, completion: nil)
    }
}
