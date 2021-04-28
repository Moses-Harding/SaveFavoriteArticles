//
//  HomeViewController.swift
//  SaveFavoriteArticles
//
//  Created by Moses Harding on 2/12/21.
//

import UIKit

extension UICollectionView {
    var fullyVisibleCells : [UICollectionViewCell] {
        return self.visibleCells.filter { cell in
            let cellRect = self.convert(cell.frame, to: self.superview)
            return self.frame.contains(cellRect) }
    }
    
}

class HomeViewController: UIViewController, TopStoryDelegate {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var sectionTable: UITableView!
    @IBOutlet weak var topStoryCollection: UICollectionView!
    @IBOutlet weak var topStoryCollectionFlow: UICollectionViewFlowLayout!
    
    var sectionCellIdentifier = "SectionCell"
    var topStoryCellIdentifier = "TopStoryCell"
    
    var homeData = HomeData()
    
    var isScrolling = false
    var contentOffset: CGFloat = 0
    
    var categoryContainers = [String:StoryDataContainer]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        homeData.delegate = self
        
        configureTableView()
        configureCollectionView()
        
        dateLabel.text = DateFormatter.localizedString(from: Date(), dateStyle: .short, timeStyle: .none)
        dateLabel.sizeToFit()
        
        getContainers()
    }
    
    func getContainers() {
        
        for (key, _) in homeData.sections {
            let collection = StoryDataContainer(filter: key)
        }
    }
    
    func configureCollectionView() {
        
        topStoryCollection.delegate = self
        topStoryCollection.dataSource = self
        
        let nib = UINib(nibName: topStoryCellIdentifier, bundle: nil)
        topStoryCollection.register(nib, forCellWithReuseIdentifier: topStoryCellIdentifier)
        
        topStoryCollection.decelerationRate = .fast
    }
    
    func configureTableView() {
        
        sectionTable.delegate = self
        sectionTable.dataSource = self
        
        let nib = UINib(nibName: sectionCellIdentifier, bundle: nil)
        sectionTable.register(nib, forCellReuseIdentifier: sectionCellIdentifier)
    }
}

extension HomeViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homeData.stories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = topStoryCollection.dequeueReusableCell(withReuseIdentifier: topStoryCellIdentifier, for: indexPath) as? TopStoryCell  else {
            fatalError()
        }
        
        guard let story = homeData.getStory(at: indexPath) else {
            return cell
        }
        
        cell.titleLabel.text = story.article.title
        
        if let image = story.image {
            cell.storyImageView.image = image
        } else {
            self.addImage(from: story, cell: cell)
        }
        
        return cell
    }
    
    private func addImage(from story: Story, cell: TopStoryCell? = nil, storyDetailView: StoryDetailView? = nil) {
        
        guard let url = URL(string: story.article.multimedia[0].url) else { return }
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    if cell != nil {
                        cell?.storyImageView.image = image
                    } else if storyDetailView != nil {
                        storyDetailView?.imageView.image = image
                    }
                    story.image = image
                }
            }
        }
        
        task.resume()
    }
}

extension HomeViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        guard let story = homeData.getStory(at: indexPath) else {
            return
        }
        
        let newView = StoryDetailView(story: story, parent: self.view)
        
        if let image = story.image {
            newView.imageView.image = image
        } else {
            self.addImage(from: story, storyDetailView: newView)
        }
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
        if isScrolling { return }
        
        for indexPath in topStoryCollection.indexPathsForVisibleItems {
            guard let topStoryCell = topStoryCollection.dequeueReusableCell(withReuseIdentifier: topStoryCellIdentifier, for: indexPath) as? TopStoryCell else { return }
            
            let cellRect = topStoryCollection.convert(topStoryCell.frame, to: topStoryCollection.superview)
            if scrollView.contentOffset.x < self.contentOffset && cellRect.origin.x < 0 {
                isScrolling = true
                UIView.animate(withDuration: 0.15, animations: {
                    self.topStoryCollection.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
                }, completion: { _ in
                    self.isScrolling = false
                    self.contentOffset = scrollView.contentOffset.x
                })
            } else if scrollView.contentOffset.x >= self.contentOffset && cellRect.origin.x >= 0 {
                isScrolling = true
                UIView.animate(withDuration: 0.15, animations: {
                    self.topStoryCollection.scrollToItem(at: indexPath, at: UICollectionView.ScrollPosition.centeredHorizontally, animated: false)
                }, completion: { _ in
                    self.isScrolling = false
                    self.contentOffset = scrollView.contentOffset.x
                })
            }
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let scrollWidth = view.safeAreaLayoutGuide.layoutFrame.width * 0.9
        let scrollHeight = view.safeAreaLayoutGuide.layoutFrame.height * 0.525
        
        return CGSize(width: scrollWidth, height: scrollHeight)
    }
}

extension HomeViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        for indexPath in indexPaths {
            if let story = homeData.getStory(at: indexPath) {
                self.addImage(from: story)
            }
        }
    }
}

extension HomeViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: sectionCellIdentifier) as? SectionCell else {
            fatalError()
        }
        
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "StoryView") as! StoryController
        vc.filter = homeData.sections[indexPath.row].0
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension HomeViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return homeData.sections.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: sectionCellIdentifier) as? SectionCell else {
            fatalError()
        }
        
        let title = homeData.sections[indexPath.row].0
        
        switch title {
        case "nyregion":
            cell.titleLabel.text = "NY Region"
        case "realestate":
            cell.titleLabel.text = "Real Estate"
        case "sundayreview":
            cell.titleLabel.text = "Sunday Review"
        case "us":
            cell.titleLabel.text = "US"
        default:
            cell.titleLabel.text = title.capitalized
        }
        
        cell.sectionIcon.image = UIImage(systemName: homeData.sections[indexPath.row].1)
        
        return cell
    }
}

protocol TopStoryDelegate {
    var topStoryCollection: UICollectionView! { get set }
}
