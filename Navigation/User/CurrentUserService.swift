class CurrentUserService: UserService {
    private var currentUser: User

    init(user: User) {
        self.currentUser = user
    }

    func getUser(login: String) -> User? {
        return currentUser.login == login ? currentUser : nil
    }
}
