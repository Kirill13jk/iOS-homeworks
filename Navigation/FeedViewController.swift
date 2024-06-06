import UIKit

class FeedViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemPurple
        
        // Создание UIStackView
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        // Создание кнопок
        let button1 = UIButton(type: .system)
        button1.setTitle("Open Post Super Man", for: .normal)
        button1.addTarget(self, action: #selector(openPost), for: .touchUpInside)
        
        button1.layer.backgroundColor = UIColor.white.cgColor
        button1.layer.cornerRadius = 12

        
        let button2 = UIButton(type: .system)
        button2.setTitle("Open Post Spider Man", for: .normal)
        button2.addTarget(self, action: #selector(openPost), for: .touchUpInside)
        
        button2.layer.backgroundColor = UIColor.systemGray5.cgColor
        button2.layer.cornerRadius = 12
        
        // Добавление кнопок в UIStackView
        stackView.addArrangedSubview(button1)
        stackView.addArrangedSubview(button2)
        
        // Добавление UIStackView на главный view
        view.addSubview(stackView)
        
        // Установка ограничений для UIStackView
        NSLayoutConstraint.activate([
            button1.widthAnchor.constraint(equalToConstant: 200),
            button1.heightAnchor.constraint(equalToConstant: 50),
            
            button2.heightAnchor.constraint(equalToConstant: 50),
            
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    @objc func openPost() {
        let postViewController = PostViewController()
        navigationController?.pushViewController(postViewController, animated: true)
    }
}
