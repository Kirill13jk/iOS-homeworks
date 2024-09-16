import UIKit

public struct Post {
    public let title: String
    public let author: String
    public let description: String
    public let image: UIImage?
    public let likes: Int
    public let views: Int

    // Явный public инициализатор
    public init(title: String, author: String, description: String, image: UIImage?, likes: Int, views: Int) {
        self.title = title
        self.author = author
        self.description = description
        self.image = image
        self.likes = likes
        self.views = views
    }

    // Добавляем статический метод внутри структуры
    public static func makeMockPosts() -> [Post] {
        let image1 = UIImage(named: "post_image1")!
        let image2 = UIImage(named: "post_image2")!
        let image3 = UIImage(named: "post_image3")!
        let image4 = UIImage(named: "post_image4")!

        return [
            Post(title: "User", author: "user123", description: "Just enjoying the sunny day! 😎", image: image1, likes: 35, views: 500),
            Post(title: "Girl", author: "traveler_girl", description: "Exploring new places is my passion! 🌍✈️", image: image2, likes: 120, views: 1000),
            Post(title: "Foodie", author: "foodie_forever", description: "Delicious sushi for dinner tonight! 🍣", image: image4, likes: 80, views: 750),
            Post(title: "Fitness", author: "fitnessfanatic", description: "Morning workout done! 💪 Feeling energized!", image: image3, likes: 65, views: 600)
        ]
    }
}
