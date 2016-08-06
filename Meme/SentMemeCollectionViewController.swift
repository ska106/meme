//
//  SentMemeCollectionViewController.swift
//  Meme
//
//  Created by Sudeep Agrawal on 8/3/16.
//  Copyright © 2016 Agrawal. All rights reserved.
//

import Foundation
import UIKit

class SentMemeCollectionViewController: UICollectionViewController
{
    @IBOutlet weak var sentMemeCollectionFlowLayout: UICollectionViewFlowLayout!
    
    var memes:[MemeModel]
                {
                    return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
                }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        let space : CGFloat = 3.0
        let dimension = (self.view.frame.width) - (2*space) / 3
        sentMemeCollectionFlowLayout.minimumInteritemSpacing = space
        sentMemeCollectionFlowLayout.minimumLineSpacing = space
        sentMemeCollectionFlowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
    }
    
    /*
     * Get the number of items to be displayed in the collection
     */
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int
    {
        return self.memes.count
    }
    
    /*
     * Cell for Collection at Index path
     */
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell
    {
        let myCell = collectionView.dequeueReusableCellWithReuseIdentifier("memeCollectionCell", forIndexPath: indexPath) as! SentMemeCollectionCell
        if(self.memes.count>0)
        {
            myCell.collectionImageCell.image = self.memes[indexPath.row].savedMemeImage
        }
        return myCell
    }
    
    /*
     * Display the DetailView controller when an image is selected from the Collection.
     */
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath)
    {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.memeImage = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}
