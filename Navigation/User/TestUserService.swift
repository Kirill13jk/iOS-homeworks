import UIKit

class TestUserService: UserService {
    private var testUser: User

    init() {
        self.testUser = User(login: "testuser", fullName: "Test User", avatar: UIImage(named: "test_avatar") ?? UIImage(), status: "Test status")
    }

    func getUser(login: String) -> User? {
        return testUser.login == login ? testUser : nil
    }
}
