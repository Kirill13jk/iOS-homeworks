import UIKit

class PhotosTableViewController: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(PhotosTableViewCell.self, forCellReuseIdentifier: "PhotosCell")
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2 // Пример, чтобы ячейка Photos была в отдельной секции
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1 // Ячейка Photos
        }
        return 10 // Пример других ячеек
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotosCell", for: indexPath) as! PhotosTableViewCell
            return cell
        }
        let cell = UITableViewCell(style: .default, reuseIdentifier: "OtherCell")
        cell.textLabel?.text = "Other Cell \(indexPath.row)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let photosViewController = PhotosViewController()
            navigationController?.pushViewController(photosViewController, animated: true)
        }
    }
}
