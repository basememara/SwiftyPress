//
//  SPPostCollectionViewController.swift
//  SwiftyPress
//
//  Created by Basem Emara on 4/3/16.
//
//

import UIKit
import ZamzamKit

public class SPPostCollectionViewController: UICollectionViewController, DataControllable, CHTCollectionViewDelegateWaterfallLayout {

    public let cellNibName = "PostCollectionViewCell"
    public var cellWidth = 0
    public let service = PostService()
    public var models: [Postable] = []
    public var activityIndicator: UIActivityIndicatorView?
    public var categoryMenu: [String] = []
    
    public var dataView: DataViewable {
        return collectionView!
    }

    public override func viewDidLoad() {
        super.viewDidLoad()
        didLoad()
        
        setupCollectionView()
    }
    
    public override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        // Dynamically calculate cell width for two columns
        cellWidth = Int(UIScreen.mainScreen().bounds.width / 2.0)
    }
    
    public func setupCollectionView() {
        // Create a waterfall layout
        let layout = CHTCollectionViewWaterfallLayout()
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        // Collection view attributes
        collectionView?.autoresizingMask = [UIViewAutoresizing.FlexibleHeight, UIViewAutoresizing.FlexibleWidth]
        collectionView?.alwaysBounceVertical = true
        
        // Add the waterfall layout to your collection view
        collectionView?.collectionViewLayout = layout
    }

    public override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }

    public override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }

    public override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView[indexPath] as! PostCollectionViewCell
        let model = models[indexPath.row]
        return cell.bind(model)
    }
    
    public func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let model = models[indexPath.row]
        
        // Determine dynamic size
        if model.imageURL != "" && model.imageWidth > 0 && model.imageHeight > 0 {
            let height = Float(model.imageHeight) * Float(cellWidth) / Float(model.imageWidth)
            return CGSize(width: cellWidth, height: Int(height + 48))
        } else {
            return CGSize(width: cellWidth, height: cellWidth)
        }
    }
    
    public override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        performSegueWithIdentifier(PostDetailViewController.detailSegueIdentifier, sender: nil)
    }
    
    public override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let indexPath = collectionView?.indexPathsForSelectedItems()?.first else { return }
        
        if let controller = segue.destinationViewController as? PostDetailViewController {
            // Store model on detail page if applicable
            controller.model = models[indexPath.row]
        }
    }

}