import UIKit

class FileService {
    static let shared = FileService()
    
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func saveImage(_ image: UIImage, withName name: String) {
        let fileURL = getDocumentsDirectory().appendingPathComponent(name)
        if let data = image.jpegData(compressionQuality: 0.8) {
            FileManager.default.createFile(atPath: fileURL.path, contents: data, attributes: nil)
        }
    }
    
    func loadImages() -> [String] {
        let documentsURL = getDocumentsDirectory()
        let contents = try? FileManager.default.contentsOfDirectory(atPath: documentsURL.path)
        return contents ?? []
    }
    
    func deleteImage(named name: String) {
        let fileURL = getDocumentsDirectory().appendingPathComponent(name)
        try? FileManager.default.removeItem(at: fileURL)
    }
}
