import UIKit
import iOSIntPackage

// Контроллер для отображения фото галереи
class PhotosViewController: UIViewController, ImageLibrarySubscriber {
    
    // Создаем UICollectionView для отображения изображений
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let itemSpacing: CGFloat = 8 // Расстояние между элементами
        let itemsPerRow: CGFloat = 3 // Количество элементов в строке
        // Расчет ширины элемента с учетом отступов и количества элементов в строке
        let width = (UIScreen.main.bounds.width - (itemsPerRow + 1) * itemSpacing) / itemsPerRow
        layout.itemSize = CGSize(width: width, height: width)
        layout.sectionInset = UIEdgeInsets(top: itemSpacing, left: itemSpacing, bottom: itemSpacing, right: itemSpacing)
        layout.minimumLineSpacing = itemSpacing // Минимальное расстояние между строками
        layout.minimumInteritemSpacing = itemSpacing // Минимальное расстояние между элементами в строке
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .white
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var images: [UIImage] = [] // Массив для хранения изображений
    private var imagePublisher: ImagePublisherFacade? // Экземпляр ImagePublisherFacade

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(collectionView)
        
        // Устанавливаем констрейнты для collectionView
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // Регистрируем PhotosCollectionViewCell для использования в collectionView
        collectionView.register(PhotosCollectionViewCell.self, forCellWithReuseIdentifier: "PhotoCell")
        
        // Показываем navigation bar
        navigationController?.setNavigationBarHidden(false, animated: true)
        
        // Инициализация imagePublisher и подписка на обновления
        imagePublisher = ImagePublisherFacade()
        imagePublisher?.subscribe(self)
        
        // Передаем пользовательские изображения
        let userImages: [UIImage] = loadUserImages()
        // Проверка, что все 20 изображений загружены
        assert(userImages.count == 20, "Должно быть загружено 20 изображений, но загружено \(userImages.count)")
        imagePublisher?.addImagesWithTimer(time: 0.5, repeat: userImages.count, userImages: userImages)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // Отменяем подписку при деинициализации контроллера
    deinit {
        imagePublisher?.removeSubscription(for: self)
    }
    
    // Метод для загрузки пользовательских изображений
    private func loadUserImages() -> [UIImage] {
        var images = [UIImage]()
        for i in 1...20 {
            if let image = UIImage(named: "photo\(i)") {
                images.append(image)
            }
        }
        return images
    }
    
    // Метод для получения изображений от ImagePublisherFacade
    func receive(images: [UIImage]) {
        // Добавляем уникальные изображения в массив, удаляя дубликаты
        let uniqueReceivedImages = images.unique()
        self.images.append(contentsOf: uniqueReceivedImages)
        self.images = self.images.unique()
        self.collectionView.reloadData() // Перезагружаем данные коллекции
    }
}

// Расширение для реализации протокола UICollectionViewDataSource и UICollectionViewDelegate
extension PhotosViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count // Количество элементов соответствует количеству изображений в массиве
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Декьюим ячейку с идентификатором "PhotoCell"
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "PhotoCell", for: indexPath) as! PhotosCollectionViewCell
        cell.configure(with: images[indexPath.item]) // Настраиваем ячейку с изображением
        return cell
    }
}

// Расширение для удаления дубликатов из массива
extension Array where Element: Equatable {
    func unique() -> [Element] {
        var uniqueValues: [Element] = []
        for value in self {
            if !uniqueValues.contains(value) {
                uniqueValues.append(value)
            }
        }
        return uniqueValues
    }
}
