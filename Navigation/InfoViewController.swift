//
//  InfoViewController.swift
//  Navigation
//
//  Created by prom1 on 26.04.2024.
//

import UIKit

class InfoViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .gray
        
        let button = UIButton(type: .system)
        button.setTitle("Показать сообщение", for: .normal)
        button.addTarget(self, action: #selector(showAlert), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.center = view.center
        view.addSubview(button)
    }
    
    @objc func showAlert() {
        let alertController = UIAlertController(title: "Заголовок", message: "Сообщение", preferredStyle: .alert)
        let action1 = UIAlertAction(title: "Action 1", style: .default) { _ in
            print("Action 1")
        }
        let action2 = UIAlertAction(title: "Action 2", style: .default) { _ in
            print("Action 2")
        }
        alertController.addAction(action1)
        alertController.addAction(action2)
        present(alertController, animated: true, completion: nil)
        
    }
}

