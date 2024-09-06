import UIKit

class DocumentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    weak var coordinator: DocumentCoordinator?
    
    private var tableView: UITableView!
    private var images: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Documents"
        view.backgroundColor = .white
        
        setupTableView()
        setupNavigationBar()
        loadImagesFromDocumentsDirectory()
    }
    
    private func setupTableView() {
        tableView = UITableView(frame: view.bounds, style: .plain)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        view.addSubview(tableView)
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Добавить фотографию", style: .plain, target: self, action: #selector(addPhotoTapped))
    }
    
    @objc private func addPhotoTapped() {
        let alertController = UIAlertController(title: "Enter file name", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "File name"
        }
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            if let fileName = alertController.textFields?.first?.text, !fileName.isEmpty {
                self.presentImagePicker(fileName: fileName)
            } else {
                self.presentImagePicker(fileName: UUID().uuidString)
            }
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }

    private func presentImagePicker(fileName: String) {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        picker.modalPresentationStyle = .fullScreen
        picker.accessibilityLabel = fileName
        present(picker, animated: true, completion: nil)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[.originalImage] as? UIImage, let fileName = picker.accessibilityLabel {
            saveImage(image, withName: fileName)
            loadImagesFromDocumentsDirectory()
        }
    }

    private func saveImage(_ image: UIImage, withName name: String) {
        let fileManager = FileManager.default
        let documentsURL = getDocumentsDirectory()
        let fileURL = documentsURL.appendingPathComponent(name + ".jpg")
        if let data = image.jpegData(compressionQuality: 0.8) {
            fileManager.createFile(atPath: fileURL.path, contents: data, attributes: nil)
        }
    }

    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let fileName = images[indexPath.row]
        
        let imagePath = getDocumentsDirectory().appendingPathComponent(fileName).path
        if let image = UIImage(contentsOfFile: imagePath) {
            cell.imageView?.image = image
        }
        
        let fileAttributes = try? FileManager.default.attributesOfItem(atPath: imagePath)
        if let fileSize = fileAttributes?[.size] as? Int, let creationDate = fileAttributes?[.creationDate] as? Date {
            let formatter = DateFormatter()
            formatter.dateStyle = .short
            formatter.timeStyle = .short
            cell.detailTextLabel?.text = "Size: \(fileSize) bytes, Created: \(formatter.string(from: creationDate))"
        }
        
        cell.textLabel?.text = fileName
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let fileName = images[indexPath.row]
        let imagePath = getDocumentsDirectory().appendingPathComponent(fileName).path
        
        if let image = UIImage(contentsOfFile: imagePath) {
            let detailVC = ImageDetailViewController()
            detailVC.image = image
            navigationController?.pushViewController(detailVC, animated: true)
        }
    }

    // MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            deleteImage(named: images[indexPath.row])
            loadImagesFromDocumentsDirectory()
        }
    }
    
    private func deleteImage(named imageName: String) {
        let fileManager = FileManager.default
        let documentsURL = getDocumentsDirectory()
        let fileURL = documentsURL.appendingPathComponent(imageName)
        do {
            try fileManager.removeItem(at: fileURL)
        } catch {
            print("Failed to delete image: \(error.localizedDescription)")
        }
    }
    
    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func loadImagesFromDocumentsDirectory() {
        let fileManager = FileManager.default
        let documentsURL = getDocumentsDirectory()
        do {
            images = try fileManager.contentsOfDirectory(atPath: documentsURL.path)
            tableView.reloadData()
        } catch {
            print("Failed to load images: \(error.localizedDescription)")
        }
    }
}
