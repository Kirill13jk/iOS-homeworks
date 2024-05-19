//
//  FeedViewController.swift
//  Navigation
//
//  Created by prom1 on 26.04.2024.
//

import UIKit

class FeedViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        view.backgroundColor = .yellow
        title = "Лента"
        
        _ = Post(title: "Заголовок поста")
        
        let button = UIButton(type: .system)
        button.setTitle("Перейти к посту", for: .normal)
        button.addTarget(self, action: #selector(showPost), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 200, height: 50)
        button.center = view.center
        view.addSubview(button)
    }
    
    @objc func showPost() {
        let postViewController = PostViewController()
        
        let post = Post(title: "Заголовок поста")
        postViewController.post = post
        navigationController?.pushViewController(postViewController, animated: true)
    }
}
