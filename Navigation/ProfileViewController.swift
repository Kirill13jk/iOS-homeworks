import UIKit

class ProfileViewController: UIViewController {
    
    // Создаем экземпляр ProfileHeaderView
    let headerView = ProfileHeaderView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        // Устанавливаем серый фон
        view.backgroundColor = .lightGray
        
        // Добавляем ProfileHeaderView как subview
        view.addSubview(headerView)
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        // Задаем frame для headerView равный frame корневого view
        headerView.frame = view.bounds
    }
}
