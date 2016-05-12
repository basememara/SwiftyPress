//
//  RealmPostCollectionViewController.swift
//  SwiftyPress
//
//  Created by Basem Emara on 5/7/16.
//
//

import UIKit
import ZamzamKit
import RealmSwift
import RateLimit

class RealmPostCollectionViewController: UICollectionViewController, CHTCollectionViewDelegateWaterfallLayout, PostControllable {

    var notificationToken: NotificationToken?
    var models: Results<Post>?
    let service = PostService()
    let cellNibName: String? = "PostCollectionViewCell"
    
    lazy var cellWidth: Int = {
        return Int(UIScreen.mainScreen().bounds.width / 2.0)
    }()
    
    var dataView: DataViewable {
        return collectionView!
    }
    
    var indexPathForSelectedItem: NSIndexPath? {
        return collectionView?.indexPathsForSelectedItems()?.first
    }
    
    var categoryID: Int = 0 {
        didSet { 
            applyFilterAndSort(filter: categoryID > 0
                ? "ANY categories.id == \(categoryID)" : nil)
            didCategorySelect()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        didDataControllableLoad()
        setupCollectionView()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Retrieve latest posts not more than every X hours
        RateLimit.execute(name: "UpdatePostsFromRemote", limit: 10800) {
            service.updateFromRemote()
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        prepareForSegue(segue)
    }
    
    func didCategorySelect() {
    
    }
}

extension RealmPostCollectionViewController {
    
    func setupCollectionView() {
        // Create a waterfall layout
        let layout = CHTCollectionViewWaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        // Collection view attributes
        collectionView?.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        collectionView?.alwaysBounceVertical = true
        
        // Add the waterfall layout to your collection view
        collectionView?.collectionViewLayout = layout
    }

    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models?.count ?? 0
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView[indexPath] as! PostCollectionViewCell
        guard let model = models?[indexPath.row] else { return cell }
        return cell.bind(model)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        // Determine dynamic size
        if let model = models?[indexPath.row] where !model.imageURL.isEmpty && model.imageWidth > 0 && model.imageHeight > 0 {
            let height = Int((Float(model.imageHeight) * Float(cellWidth) / Float(model.imageWidth)) + 48)
            return CGSize(width: cellWidth, height: height)
        }
        
        // Placeholder image size if no image found
        return CGSize(width: cellWidth, height: 189)
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(PostDetailViewController.segueIdentifier, sender: nil)
    }
}