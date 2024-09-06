import UIKit

class ImageDetailViewController: UIViewController {
    var image: UIImage?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = view.bounds
        view.addSubview(imageView)
    }
}
