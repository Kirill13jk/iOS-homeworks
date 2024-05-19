//
//  PostViewController.swift
//  Navigation
//
//  Created by prom1 on 26.04.2024.
//

import UIKit

class PostViewController: UIViewController {
    var post: Post? // Свойство для хранения поста
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Настраиваем внешний вид или добавляем другую логику, если необходимо
        view.backgroundColor = .lightGray
        title = post?.title ?? "Пост"
        
        // Добавляем кнопку в навигационную панель
        let infoButton = UIBarButtonItem(title: "Info", style: .plain, target: self, action: #selector(showInfoViewController))
        navigationItem.rightBarButtonItem = infoButton
    }
    
    @objc func showInfoViewController() {
        let infoViewController = InfoViewController()
        present(infoViewController, animated: true, completion: nil)
    }
}
