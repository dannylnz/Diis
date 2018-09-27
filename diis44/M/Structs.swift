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
    var category:String
    

    
}

struct Chapter {
    
    var title:String
    var value:String
    var root:String

    
    
    
}
class Downloader {
    class func loadFileAsync(url: URL, completion: @escaping (String?, Error?) -> Void)
    {
        let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        let destinationUrl = documentsUrl.appendingPathComponent(url.lastPathComponent)
        
        if FileManager().fileExists(atPath: destinationUrl.path)
        {
            completion(destinationUrl.path, nil)
        }
        else
        {
            let session = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: nil)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            let task = session.dataTask(with: request, completionHandler:
            {
                data, response, error in
                if error == nil
                {
                    if let response = response as? HTTPURLResponse
                    {
                        if response.statusCode == 200
                        {
                            if let data = data
                            {
                                if let _ = try? data.write(to: destinationUrl, options: Data.WritingOptions.atomic)
                                {
                                    completion(destinationUrl.path, error)
                                }
                                else
                                {
                                    completion(destinationUrl.path, error)
                                }
                            }
                            else
                            {
                                completion(destinationUrl.path, error)
                            }
                        }
                    }
                }
                else
                {
                    completion(destinationUrl.path, error)
                }
            })
            task.resume()
        }
}
}
