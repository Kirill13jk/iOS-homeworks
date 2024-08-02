import UIKit
import YouTubeiOSPlayerHelper

class YouTubeViewController: UIViewController, YTPlayerViewDelegate {
    weak var coordinator: YouTybeCoordinator?
    
    var playerView: YTPlayerView! // YouTube проигрыватель
    var videoTableView: UITableView! // Таблица для отображения списка видео
    
    // Список видео с названиями и идентификаторами YouTube
    let videos = [
        (title: "Crushing Snakes - Crowded", videoID: "6qUPAI-VVhY"),
        (title: "Love On Fire - Jeremy Riddle", videoID: "mYpjJ3TiJuA"),
        (title: "Lion - Elevation", videoID: "2go_dOJVwc4")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI() // Настраиваем элементы интерфейса
    }
    
    // Настройка UI элементов
    func setupUI() {
        // Инициализация YouTube Player
        playerView = YTPlayerView()
        playerView.delegate = self
        playerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(playerView)
        
        // Инициализация TableView для списка видео
        videoTableView = UITableView()
        videoTableView.delegate = self
        videoTableView.dataSource = self
        videoTableView.register(UITableViewCell.self, forCellReuseIdentifier: "videoCell")
        videoTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(videoTableView)
        
        // Установка ограничений для UI элементов
        setupConstraints()
    }
    
    // Установка ограничений для UI элементов
    func setupConstraints() {
        NSLayoutConstraint.activate([
            // Ограничения для YouTube Player
            playerView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            playerView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            playerView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            playerView.heightAnchor.constraint(equalToConstant: 300),
            
            // Ограничения для таблицы с видео
            videoTableView.topAnchor.constraint(equalTo: playerView.bottomAnchor),
            videoTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            videoTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            videoTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // Воспроизведение видео по его идентификатору
    func playVideo(videoID: String) {
        playerView.load(withVideoId: videoID)
    }
}

// MARK: - UITableViewDelegate и UITableViewDataSource
extension YouTubeViewController: UITableViewDelegate, UITableViewDataSource {
    // Количество строк в таблице
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return videos.count
    }
    
    // Конфигурация ячейки таблицы
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "videoCell", for: indexPath)
        cell.textLabel?.text = videos[indexPath.row].title
        return cell
    }
    
    // Действие при выборе ячейки таблицы
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedVideo = videos[indexPath.row]
        playVideo(videoID: selectedVideo.videoID) // Воспроизведение выбранного видео
    }
}
