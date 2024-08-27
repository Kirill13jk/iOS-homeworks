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
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = self
        present(picker, animated: true, completion: nil)
    }
    
    // MARK: - UIImagePickerControllerDelegate
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        if let image = info[.originalImage] as? UIImage {
            saveImage(image)
            loadImagesFromDocumentsDirectory()
        }
    }
    
    // MARK: - UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = images[indexPath.row]
        return cell
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
    
    // MARK: - File Management
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
    
    private func saveImage(_ image: UIImage) {
        let fileManager = FileManager.default
        let documentsURL = getDocumentsDirectory()
        let fileName = UUID().uuidString + ".jpg"
        let fileURL = documentsURL.appendingPathComponent(fileName)
        if let data = image.jpegData(compressionQuality: 0.8) {
            fileManager.createFile(atPath: fileURL.path, contents: data, attributes: nil)
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
}
