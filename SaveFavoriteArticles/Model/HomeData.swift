//
//  MainData.swift
//  SaveFavoriteArticles
//
//  Created by Moses Harding on 2/12/21.
//

import Foundation
import UIKit

class HomeData {
    
    var sections: [(String, String)] = [("arts","paintpalette.fill"), ("automobiles","car.fill"), ("books","books.vertical.fill"), ("business","briefcase.fill"), ("fashion","bag.fill"), ("food","leaf.fill"), ("health","cross.case.fill"), ("home","house.fill"), ("insider","eye.fill"), ("magazine","book.fill"), ("movies","film.fill"), ("nyregion","tram.tunnel.fill"), ("obituaries","person.crop.square"), ("opinion","bubble.right.fill"), ("politics","person.3.fill"), ("realestate","house.circle.fill"), ("science","waveform.path.ecg"), ("sports","sportscourt.fill"), ("sundayreview","bookmark.fill"), ("technology","tv.fill"), ("theater","music.mic"), ("t-magazine","greetingcard.fill"), ("travel","airplane"), ("upshot", "arrow.triangle.merge"), ("us","flag.fill"), ("world","globe")]
    
    var stories = [Story]()
    
    var delegate: TopStoryDelegate?

    init() {
        retrieveStories()
    }
    
    func retrieveStories() {

        let url = URL(string: "https://api.nytimes.com/svc/topstories/v2/home.json?api-key=" + NYTimesAPI.shared.appKey)!

        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let foundData = data {
                if let results = try? JSONDecoder().decode(Results.self, from: foundData) {
                    for eachResult in results.results {
                        let newStory = Story(article: eachResult)

                        if !self.stories.contains(newStory) {
                            self.stories.append(newStory)
                        }
                    }
                    DispatchQueue.main.async {
                        self.delegate?.topStoryCollection.reloadData()
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
    
    func reset() {
        stories = []
    }
}
