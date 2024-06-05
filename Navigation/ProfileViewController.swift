import UIKit

class ProfileViewController: UIViewController {

    private let tableView = UITableView()
    private let profileHeaderView = ProfileHeaderView()
    private let overlayView = UIView()
    private let closeButton = UIButton(type: .system)
    private var avatarOriginalFrame: CGRect?
    private var enlargedAvatarImageView: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        view.addSubview(tableView)

        setupTableViewConstraints()

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(PostTableViewCell.self, forCellReuseIdentifier: "PostCell")
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: "PhotosCell")

        NotificationCenter.default.addObserver(self, selector: #selector(handleAvatarTapped(_:)), name: NSNotification.Name("AvatarTapped"), object: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupTableHeaderView()
    }

    private func setupTableViewConstraints() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }

    private func setupTableHeaderView() {
        tableView.tableHeaderView = profileHeaderView
    }

    @objc private func handleAvatarTapped(_ notification: Notification) {
        guard let avatarImageView = notification.object as? UIImageView else { return }

        avatarOriginalFrame = avatarImageView.superview?.convert(avatarImageView.frame, to: nil)

        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        overlayView.alpha = 0
        overlayView.frame = view.bounds
        view.addSubview(overlayView)

        closeButton.setImage(UIImage(systemName: "xmark"), for: .normal)
        closeButton.tintColor = .white
        closeButton.alpha = 0
        closeButton.addTarget(self, action: #selector(handleCloseButton), for: .touchUpInside)
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(closeButton)
        NSLayoutConstraint.activate([
            closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 30),
            closeButton.heightAnchor.constraint(equalToConstant: 30)
        ])

        enlargedAvatarImageView = UIImageView(image: avatarImageView.image)
        enlargedAvatarImageView!.contentMode = .scaleAspectFill
        enlargedAvatarImageView!.clipsToBounds = true
        enlargedAvatarImageView!.frame = avatarOriginalFrame!
        enlargedAvatarImageView!.layer.cornerRadius = 0
        enlargedAvatarImageView!.layer.masksToBounds = true
        view.addSubview(enlargedAvatarImageView!)

        UIView.animate(withDuration: 0.5, animations: {
            self.enlargedAvatarImageView!.frame = CGRect(x: 0, y: (self.view.frame.height - self.view.frame.width) / 2, width: self.view.frame.width, height: self.view.frame.width)
            self.overlayView.alpha = 1
        }) { _ in
            UIView.animate(withDuration: 0.3) {
                self.closeButton.alpha = 1
            }
        }
    }

    @objc private func handleCloseButton() {
        guard let enlargedAvatarImageView = self.enlargedAvatarImageView else { return }

        UIView.animate(withDuration: 0.3, animations: {
            self.closeButton.alpha = 0
        }) { _ in
            UIView.animate(withDuration: 0.5, animations: {
                enlargedAvatarImageView.frame = self.avatarOriginalFrame!
                self.overlayView.alpha = 0
            }) { _ in
                enlargedAvatarImageView.removeFromSuperview()
                self.overlayView.removeFromSuperview()
                self.closeButton.removeFromSuperview()
                self.enlargedAvatarImageView = nil
            }
        }
    }
}

extension ProfileViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return posts.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PhotosCell", for: indexPath) as? PhotosTableViewCell else {
                return UITableViewCell()
            }
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as? PostTableViewCell else {
                return UITableViewCell()
            }
            let post = posts[indexPath.row]
            cell.configure(with: post)
            return cell
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if section == 0 {
            return profileHeaderView
        }
        return nil
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return UITableView.automaticDimension
        }
        return 0
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let photoGalleryVC = PhotosViewController()
            navigationController?.pushViewController(photoGalleryVC, animated: true)
        }
    }
}
