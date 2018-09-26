import Foundation

struct Book {
    var title:String
    var author:String
    var numberOfLikes:Int
    var numberOfFollowers:Int
    var coverImage:String
    var plot:String
    var root:String
    
    init(title:String,author:String,numberOfLikes:Int,numberOfFollowers:Int,coverImage:String,plot:String,root:String) {
        self.title = title
        self.author = author
        self.coverImage = coverImage
        self.numberOfFollowers = numberOfFollowers
        self.numberOfLikes = numberOfLikes
        self.plot = plot
        self.root = root
    }
    
}


struct Category {
    
    var categoryDescription:String
    var categoryImage:String
    var categoryName:String
    

    
}
