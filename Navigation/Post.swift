import UIKit

struct Post {
    let title: String
    let author: String
    let description: String
    let image: UIImage
    let likes: Int
    let views: Int
}

let image1 = UIImage(named: "post_image1")!
let image2 = UIImage(named: "post_image2")!
let image3 = UIImage(named: "post_image3")!
let image4 = UIImage(named: "post_image4")!

let posts: [Post] = [
    Post(title: "User", author: "user123", description: "Just enjoying the sunny day! 😎", image: image1, likes: 35, views: 500),
    Post(title: "Girl", author: "traveler_girl", description: "Exploring new places is my passion! 🌍✈️", image: image2, likes: 120, views: 1000),
    Post(title: "Foodie", author: "foodie_forever", description: "Delicious sushi for dinner tonight! 🍣", image: image4, likes: 80, views: 750),
    Post(title: "Fitness", author: "fitnessfanatic", description: "Morning workout done! 💪 Feeling energized!", image: image3, likes: 65, views: 600)
]
