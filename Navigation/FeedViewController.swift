import UIKit

class FeedViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Создание UIStackView
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Создание кнопок
        let button1 = UIButton(type: .system)
        button1.setTitle("Open Post 1", for: .normal)
        button1.addTarget(self, action: #selector(openPost), for: .touchUpInside)
        
        let button2 = UIButton(type: .system)
        button2.setTitle("Open Post 2", for: .normal)
        button2.addTarget(self, action: #selector(openPost), for: .touchUpInside)
        
        // Добавление кнопок в UIStackView
        stackView.addArrangedSubview(button1)
        stackView.addArrangedSubview(button2)
        
        // Добавление UIStackView на главный view
        view.addSubview(stackView)
        
        // Установка ограничений для UIStackView
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func openPost() {
        let postViewController = PostViewController()
        navigationController?.pushViewController(postViewController, animated: true)
    }
}
