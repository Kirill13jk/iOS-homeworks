import UIKit
import AVFoundation

class TrackViewController: UIViewController {
    weak var coordinator: TrackCoordinator?
    
    var audioPlayer: AVAudioPlayer? // AVAudioPlayer для воспроизведения аудио
    var playPauseButton: UIButton! // Кнопка воспроизведения/паузы
    var stopButton: UIButton! // Кнопка остановки
    var trackLabel: UILabel! // Метка для названия текущего трека
    var nextTrackButton: UIButton! // Кнопка следующего трека
    var previousTrackButton: UIButton! // Кнопка предыдущего трека
    var trackSlider: UISlider! // Ползунок для прогресса трека
    var trackTableView: UITableView! // Таблица для списка треков
    var currentTimeLabel: UILabel! // Метка для текущего времени трека
    var durationLabel: UILabel! // Метка для общей длительности трека
    var timer: Timer? // Таймер для обновления ползунка и меток времени
    
    // Список треков с названиями и файлами
    let tracks = [
        (name: "PRAISES - Elevation Rhytm", file: "track1"),
        (name: "PRAISES (remix)- Elevation Rhytm, Forrest Frank", file: "track2"),
        (name: "GOOD DAY - Forrest Frank", file: "track3"),
        (name: "TILL THE WALLS LIVE - PlanetBoom", file: "track4"),
        (name: "WE ARE ONE - Spitfire", file: "track5")
    ]
    var currentTrackIndex = 0 // Текущий индекс трека

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        setupUI() // Настраиваем элементы интерфейса
        loadTrack(named: tracks[currentTrackIndex].file) // Загружаем первый трек
    }
    
    // Настройка UI элементов
    func setupUI() {
        // Метка для названия трека
        trackLabel = UILabel()
        trackLabel.textAlignment = .center
        trackLabel.font = UIFont.boldSystemFont(ofSize: 18)
        trackLabel.textColor = .black
        trackLabel.numberOfLines = 0 // Позволяет переносить текст на новую строку
        trackLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackLabel)
        
        // Ползунок для прогресса трека
        trackSlider = UISlider()
        trackSlider.translatesAutoresizingMaskIntoConstraints = false
        trackSlider.addTarget(self, action: #selector(sliderValueChanged(_:)), for: .valueChanged)
        view.addSubview(trackSlider)
        
        // Кнопка предыдущего трека
        previousTrackButton = UIButton(type: .system)
        previousTrackButton.setImage(UIImage(named: "previous"), for: .normal)
        previousTrackButton.addTarget(self, action: #selector(previousTrackTapped), for: .touchUpInside)
        previousTrackButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(previousTrackButton)
        
        // Кнопка воспроизведения/паузы
        playPauseButton = UIButton(type: .system)
        playPauseButton.setImage(UIImage(named: "play"), for: .normal)
        playPauseButton.addTarget(self, action: #selector(playPauseTapped), for: .touchUpInside)
        playPauseButton.translatesAutoresizingMaskIntoConstraints = false
        playPauseButton.imageView?.contentMode = .scaleAspectFit
        view.addSubview(playPauseButton)
        
        // Кнопка остановки
        stopButton = UIButton(type: .system)
        stopButton.setImage(UIImage(named: "stop"), for: .normal)
        stopButton.addTarget(self, action: #selector(stopTapped), for: .touchUpInside)
        stopButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stopButton)
        
        // Кнопка следующего трека
        nextTrackButton = UIButton(type: .system)
        nextTrackButton.setImage(UIImage(named: "next"), for: .normal)
        nextTrackButton.addTarget(self, action: #selector(nextTrackTapped), for: .touchUpInside)
        nextTrackButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(nextTrackButton)
        
        // Метка для текущего времени трека
        currentTimeLabel = UILabel()
        currentTimeLabel.textAlignment = .left
        currentTimeLabel.font = UIFont.systemFont(ofSize: 14)
        currentTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(currentTimeLabel)
        
        // Метка для общей длительности трека
        durationLabel = UILabel()
        durationLabel.textAlignment = .right
        durationLabel.font = UIFont.systemFont(ofSize: 14)
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(durationLabel)
        
        // Таблица для списка треков
        trackTableView = UITableView()
        trackTableView.delegate = self
        trackTableView.dataSource = self
        trackTableView.register(UITableViewCell.self, forCellReuseIdentifier: "trackCell")
        trackTableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(trackTableView)
        
        setupConstraints() // Устанавливаем ограничения для UI элементов
    }
    
    // Настройка ограничений для UI элементов
    func setupConstraints() {
        NSLayoutConstraint.activate([
            trackLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            trackLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            trackLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            trackSlider.topAnchor.constraint(equalTo: trackLabel.bottomAnchor, constant: 20),
            trackSlider.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            trackSlider.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            currentTimeLabel.topAnchor.constraint(equalTo: trackSlider.bottomAnchor, constant: 8),
            currentTimeLabel.leadingAnchor.constraint(equalTo: trackSlider.leadingAnchor),
            
            durationLabel.topAnchor.constraint(equalTo: trackSlider.bottomAnchor, constant: 8),
            durationLabel.trailingAnchor.constraint(equalTo: trackSlider.trailingAnchor),
            
            playPauseButton.topAnchor.constraint(equalTo: currentTimeLabel.bottomAnchor, constant: 20),
            playPauseButton.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: -50),
            playPauseButton.widthAnchor.constraint(equalToConstant: 80),
            playPauseButton.heightAnchor.constraint(equalToConstant: 80),
            
            stopButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor),
            stopButton.leadingAnchor.constraint(equalTo: playPauseButton.trailingAnchor, constant: 20),
            stopButton.widthAnchor.constraint(equalToConstant: 80),
            stopButton.heightAnchor.constraint(equalToConstant: 80),
            
            previousTrackButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor),
            previousTrackButton.trailingAnchor.constraint(equalTo: playPauseButton.leadingAnchor, constant: -20),
            previousTrackButton.widthAnchor.constraint(equalToConstant: 80),
            previousTrackButton.heightAnchor.constraint(equalToConstant: 80),
            
            nextTrackButton.centerYAnchor.constraint(equalTo: playPauseButton.centerYAnchor),
            nextTrackButton.leadingAnchor.constraint(equalTo: stopButton.trailingAnchor, constant: 20),
            nextTrackButton.widthAnchor.constraint(equalToConstant: 80),
            nextTrackButton.heightAnchor.constraint(equalToConstant: 80),
            
            trackTableView.topAnchor.constraint(equalTo: playPauseButton.bottomAnchor, constant: 20),
            trackTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            trackTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            trackTableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    // Загрузка трека
    func loadTrack(named trackName: String) {
        guard let url = Bundle.main.url(forResource: trackName, withExtension: "mp3") else {
            print("Error: Audio file not found.")
            return
        }
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.prepareToPlay()
            audioPlayer?.delegate = self
            trackLabel.text = tracks[currentTrackIndex].name
            trackSlider.maximumValue = Float(audioPlayer?.duration ?? 0)
            durationLabel.text = formatTime(audioPlayer?.duration ?? 0)
            startTimer()
        } catch {
            print("Error loading audio file: \(error)")
        }
    }

    // Действие кнопки Play/Pause
    @objc func playPauseTapped() {
        guard let player = audioPlayer else { return }
        if player.isPlaying {
            player.pause()
            playPauseButton.setImage(UIImage(named: "play"), for: .normal)
        } else {
            player.play()
            playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
            startTimer()
        }
    }
    
    // Действие кнопки Stop
    @objc func stopTapped() {
        guard let player = audioPlayer else { return }
        player.stop()
        player.currentTime = 0
        playPauseButton.setImage(UIImage(named: "play"), for: .normal)
        updateSlider()
        stopTimer()
    }
    
    // Действие кнопки Next
    @objc func nextTrackTapped() {
        currentTrackIndex = (currentTrackIndex + 1) % tracks.count
        loadTrack(named: tracks[currentTrackIndex].file)
        playAudio()
    }
    
    // Действие кнопки Previous
    @objc func previousTrackTapped() {
        currentTrackIndex = (currentTrackIndex - 1 + tracks.count) % tracks.count
        loadTrack(named: tracks[currentTrackIndex].file)
        playAudio()
    }
    
    // Воспроизведение аудио
    func playAudio() {
        audioPlayer?.play()
        playPauseButton.setImage(UIImage(named: "pause"), for: .normal)
        startTimer()
    }
    
    // Обновление ползунка и меток времени
    @objc func updateSlider() {
        guard let player = audioPlayer else { return }
        trackSlider.value = Float(player.currentTime)
        currentTimeLabel.text = formatTime(player.currentTime)
    }
    
    // Форматирование времени
    func formatTime(_ time: TimeInterval) -> String {
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        return String(format: "%02i:%02i", minutes, seconds)
    }
    
    // Обновление времени и ползунка
    func startTimer() {
        stopTimer()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateSlider), userInfo: nil, repeats: true)
    }
    
    // Остановка таймера
    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    @objc func sliderValueChanged(_ sender: UISlider) {
        audioPlayer?.currentTime = TimeInterval(sender.value)
        updateSlider()
    }
}

// MARK: - AVAudioPlayerDelegate
extension TrackViewController: AVAudioPlayerDelegate {
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        playPauseButton.setImage(UIImage(named: "play"), for: .normal)
        stopTimer()
    }
}

// MARK: - UITableViewDelegate and UITableViewDataSource
extension TrackViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "trackCell", for: indexPath)
        cell.textLabel?.text = tracks[indexPath.row].name
        cell.textLabel?.numberOfLines = 0 // Позволяет переносить текст на новую строку
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        currentTrackIndex = indexPath.row
        loadTrack(named: tracks[currentTrackIndex].file)
        playAudio()
    }
}
