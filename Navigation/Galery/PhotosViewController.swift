import UIKit
import iOSIntPackage

class PhotosViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // Создаем экземпляр ImageProcessor для обработки изображений
    var imageProcessor = ImageProcessor()
    // Массив необработанных изображений
    var rawImages: [UIImage] = []
    // Массив обработанных изображений
    var processedImages: [UIImage] = []

    // Создаем переменную для UICollectionView
    var collectionView: UICollectionView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Устанавливаем белый фон для отладки и общего вида
        view.backgroundColor = .white
        
        // Создаем layout для коллекции с отступами между элементами
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 8
        // Размер элемента рассчитывается исходя из ширины экрана и отступов
        let itemSize = (view.frame.width - spacing * 4) / 3
        layout.itemSize = CGSize(width: itemSize, height: itemSize)
        layout.minimumInteritemSpacing = spacing // Отступ между элементами по горизонтали
        layout.minimumLineSpacing = spacing // Отступ между элементами по вертикали
        layout.sectionInset = UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing) // Отступы для секции коллекции
        
        // Создаем и настраиваем UICollectionView с заданным layout
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        collectionView.backgroundColor = .white // Устанавливаем белый фон для коллекции
        collectionView.dataSource = self // Устанавливаем источник данных
        collectionView.delegate = self // Устанавливаем делегата
        // Регистрируем ячейку для использования в коллекции
        collectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "cell")
        view.addSubview(collectionView) // Добавляем коллекцию на экран
        
        // Загружаем необработанные изображения
        rawImages = loadRawImages()
        
        // Проверяем, что изображения загружены
        guard !rawImages.isEmpty else {
            print("Не удалось загрузить изображения")
            return
        }

        print("Загружено \(rawImages.count) изображений")

        // Обрабатываем изображения с использованием заданного уровня качества обслуживания (QoS)
        processImagesWithQualityOfService(.userInitiated)
    }
    
    // Метод для загрузки необработанных изображений из ресурсов проекта
    func loadRawImages() -> [UIImage] {
        var images: [UIImage] = []
        for i in 1...20 {
            // Загружаем изображения с именами "photo1", "photo2", и т.д.
            if let image = UIImage(named: "photo\(i)") {
                images.append(image)
            } else {
                print("Изображение photo\(i) не найдено")
            }
        }
        return images
    }

    // Метод для обработки изображений с использованием заданного QoS
    func processImagesWithQualityOfService(_ qos: QualityOfService) {
        let startTime = CFAbsoluteTimeGetCurrent() // Замеряем начальное время
        
        // Обрабатываем изображения на отдельном потоке
        imageProcessor.processImagesOnThread(sourceImages: rawImages, filter: .fade, qos: qos) { [weak self] processedCGImages in
            guard let self = self else { return }
            // Преобразуем массив CGImage? в массив UIImage
            self.processedImages = processedCGImages.compactMap { cgImage in
                if let cgImage = cgImage {
                    return UIImage(cgImage: cgImage)
                } else {
                    return nil
                }
            }
            
            let timeElapsed = CFAbsoluteTimeGetCurrent() - startTime // Вычисляем время обработки
            print("Время обработки с qos \(qos): \(timeElapsed) секунд")
            
            // Обновляем UI на главном потоке
            DispatchQueue.main.async {
                self.collectionView.reloadData() // Перезагружаем данные коллекции
            }
        }
    }
    
    // MARK: - UICollectionViewDataSource

    // Метод для определения количества элементов в секции коллекции
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return processedImages.count
    }

    // Метод для создания и конфигурации ячейки коллекции
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)
        
        // Удаляем старые изображения из ячейки, если они есть
        for subview in cell.contentView.subviews {
            subview.removeFromSuperview()
        }
        
        // Создаем и настраиваем UIImageView для отображения обработанного изображения
        let imageView = UIImageView(image: processedImages[indexPath.item])
        imageView.contentMode = .scaleAspectFill // Устанавливаем режим отображения
        imageView.clipsToBounds = true // Обрезаем изображение по границам UIImageView
        imageView.frame = cell.contentView.bounds // Устанавливаем размер UIImageView равный размеру ячейки
        cell.contentView.addSubview(imageView) // Добавляем UIImageView в ячейку
        
        return cell
    }
    
    // MARK: - UICollectionViewDelegateFlowLayout

    // Метод для установки минимального отступа между элементами по горизонтали
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }

    // Метод для установки минимального отступа между элементами по вертикали
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
}
