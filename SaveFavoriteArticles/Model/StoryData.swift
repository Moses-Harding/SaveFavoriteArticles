//
//  Story Data.swift
//  SaveFavoriteArticles
//
//  Created by Moses Harding on 2/8/21.
//

import Foundation
import UIKit



class StoryDataContainer {
    
    var stories = [Story]()
    
    var tags: [(String, Int)] = []
    
    var delegate: StoryControl?
    
    var filter: String = "home"
    
    init(filter: String?) {
        
        if filter != nil {
            self.filter = filter!
        }
        retrieveStories()
    }
    
    func retrieveStories() {

        let url = URL(string: "https://api.nytimes.com/svc/topstories/v2/\(filter).json?api-key=" + NYTimesAPI.shared.appKey)!

        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let foundData = data {
                if let results = try? JSONDecoder().decode(Results.self, from: foundData) {
                    for eachResult in results.results {
                        let newStory = Story(article: eachResult)
                        if !self.stories.contains(newStory) {
                            
                            let section = newStory.article.section
                                self.stories.append(newStory)
                            
                            var foundTag = false
                            
                            //IMPROVE
                            for i in 0 ..< self.tags.count {
                                let tag = self.tags[i]
                                if section == tag.0 {
                                    self.tags[i] = (tag.0, tag.1 + 1)
                                    foundTag = true
                                }
                            }
                            
                            if !foundTag {
                                self.tags.append((section, 1))
                            }
                        }
                    }
                    DispatchQueue.main.async {
                        if let tableView = self.delegate?.tableView {
                            tableView.reloadData()
                        }
                        
                        self.delegate?.loadTags()
                    }
                }
            }
        })
        task.resume()
    }
    
    func setFavorite(at indexPath: IndexPath) -> Bool {
        
        let story = stories[indexPath.row]
        story.isFavorite = !story.isFavorite
        return story.isFavorite
    }
    
    func getStory(at indexPath: IndexPath) -> Story? {
        if indexPath.row < stories.count {
            return stories[indexPath.row]
        } else {
            return nil
        }
    }
    
    func filter(by filter: String) {
        
        self.filter = filter
        retrieveStories()
    }
    
    func reset() {
        
        filter = "home"
        stories = []
    }
}

class Story: Equatable {
    
    static func == (lhs: Story, rhs: Story) -> Bool {
        return lhs.article.url == rhs.article.url
    }
    
    var article: Article!
    var isFavorite = false
    var image: UIImage?
    
    init(article: Article) {
        self.article = article
    }
}

struct Results: Codable {
    
    var results: [Article]
    var status: String
    var copyright: String
}

struct Article: Codable {
    
    var section: String
    var subsection: String
    var title: String
    var abstract: String
    var url: String
    var byline: String
    var item_type: String
    var updated_date: String
    var created_date: String
    var published_date: String
    var kicker: String
    var multimedia: [MultiMedia]
}

struct MultiMedia: Codable {
    var url: String
    var format: String
    var height: Int
    var width: Int
    var caption: String
    var copyright: String
}
