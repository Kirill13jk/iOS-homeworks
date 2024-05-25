
import UIKit

class ProfileTableHeaderView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupView()
    }
    private func setupView() {
        self.backgroundColor = .lightGray
    }
    
}
