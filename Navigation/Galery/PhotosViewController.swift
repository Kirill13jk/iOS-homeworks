import UIKit
import iOSIntPackage

// Контроллер для отображения фото галереи
class PhotosViewController: UIViewController {
    
    // Создаем UICollectionView для отображения изображений
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let itemSpacing: CGFloat = 10
        let itemsPerRow: CGFloat = 3
        let width = (UIScreen.main.bounds.width - (itemsPerRow + 1) * itemSpacing) / itemsPerRow
        layout.itemSize = CGSize(width: width, height: width)
        layout.sectionInset = UIEdgeInsets(top: itemSpacing, left: itemSpacing, bottom: itemSpacing, right: itemSpacing)
        layout.minimumLineSpacing = itemSpacing
        layout.minimumInteritemSpacing = itemSpacing
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
        imagePublisher?.addImagesWithTimer(time: 0.5, repeat: 10)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    // Отменяем подписку при деинициализации контроллера
    deinit {
        imagePublisher?.removeSubscription(for: self)
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

// Подписываем PhotosViewController на протокол ImageLibrarySubscriber
extension PhotosViewController: ImageLibrarySubscriber {
    func receive(images: [UIImage]) {
        // Обновление коллекции изображений на главном потоке
        DispatchQueue.main.async {
            self.images.append(contentsOf: images) // Добавляем новые изображения в массив
            self.collectionView.reloadData() // Перезагружаем данные коллекции
        }
    }
}
