//
//  ViewController.swift
//  SaveFavoriteArticles
//
//  Created by Moses Harding on 2/10/21.
//

import UIKit



class StoryController: UIViewController, StoryControl {

    

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var tagScroll: UIScrollView!
    
    var tagView = TagStack()
    
    var refreshControl = UIRefreshControl()
    
    var storyData: StoryDataContainer!
    var filter: String?
    
    var currentStory: Story?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = 200
        tableView.separatorColor = UIColor.label
        tableView.rowHeight = UITableView.automaticDimension
        
        refreshControl.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        tableView.register(StoryDataTableViewCell.self)
        tableView.addSubview(refreshControl)
        
        storyData = StoryDataContainer(filter: self.filter)

        storyData.delegate = self
    }
    
    func addTagView() {
        
        tagScroll.addSubview(tagView)
        tagView.translatesAutoresizingMaskIntoConstraints = false
        
        tagView.leadingAnchor.constraint(equalTo: tagScroll.leadingAnchor).isActive = true
        tagView.trailingAnchor.constraint(equalTo: tagScroll.trailingAnchor).isActive = true
        tagView.topAnchor.constraint(equalTo: tagScroll.topAnchor).isActive = true
        tagView.bottomAnchor.constraint(equalTo: tagScroll.bottomAnchor).isActive = true
        tagView.widthAnchor.constraint(greaterThanOrEqualTo: tagScroll.widthAnchor).isActive = true
        
        tagView.spacing = 10
    }
    
    func setFilter(from filter: String) {
        
        storyData.reset()
        storyData.filter(by: filter)
    }
    
    func loadTags() {
        
        let sortedTags = storyData.tags.sorted { $0.1 > $1.1}
        
        tagView.removeTags()
        
        sortedTags.forEach { tagView.addTag($0.0) }
    }
    
    @objc func refresh(_ sender: AnyObject) {

        storyData.retrieveStories()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
}

extension StoryController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let story = storyData.getStory(at: indexPath) else { return }
        
        if currentStory == nil {
            currentStory = story
        } else if currentStory?.article.title != story.article.title {
            currentStory = story
        } else {
            
            guard let url = URL(string: story.article.url) else { return }
            
            UIApplication.shared.open(url)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let favoriteAction = UISwipeActionsConfiguration(actions: [makeFavoriteContextualAction(forRowAt: indexPath)])
        return favoriteAction
    }
    
    private func makeFavoriteContextualAction(forRowAt indexPath: IndexPath) -> UIContextualAction {
        
        let action = UIContextualAction(style: .normal, title: "")  { (action, swipeButtonView, completion) in
            
            guard let cell = self.tableView.cellForRow(at: indexPath) as? StoryDataTableViewCell else { return }
            
            let isFavorite = self.storyData.setFavorite(at: indexPath)
            cell.setFavorite(isFavorite)
            completion(true)
        }
        
        action.backgroundColor = .systemPink
        action.image = UIImage(systemName: "heart.fill")
        return action
    }
}

extension StoryController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return storyData.stories.count
    }
    
    //MARK: Set Data
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "StoryDataTableViewCell") as? StoryDataTableViewCell, let story = storyData.getStory(at: indexPath) else { fatalError() }
        
        cell.titleLabel.text = story.article.title
        cell.abstractLabel.text = story.article.abstract
        cell.setTags(section: story.article.section, subsection: story.article.subsection)
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        let string = story.article.updated_date
        if let date = formatter.date(from: string) {
            cell.dateLabel.text = DateFormatter.localizedString(from: date, dateStyle: .medium, timeStyle: .short)
        } else {
            cell.dateLabel.text = story.article.updated_date
        }
        
        addImage(from: story, to: cell)
        
        return cell
    }
    
    private func addImage(from story: Story, to cell: StoryDataTableViewCell) {
        
        guard let url = URL(string: story.article.multimedia[0].url) else { return }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    cell.storyImageView.image = image
                    return
                }
            }
        }
        
        task.resume()
    }
}

protocol StoryControl {

    var tableView: UITableView! { get set }
    var tagView: TagStack { get set }
    
    func loadTags()
    func setFilter(from filter: String)
}
