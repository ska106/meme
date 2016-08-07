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
    @IBOutlet var sentMemeCollectionView: UICollectionView!
    
    var memes:[MemeModel]
                {
                    return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
                }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Made the back ground color as white to be consistent with the Table View Controller.
        sentMemeCollectionView.backgroundColor = UIColor.whiteColor()
        
        
        // For the image to scale properly.
        sentMemeCollectionView.contentMode = UIViewContentMode.ScaleAspectFill
        
        let space : CGFloat = 2.0
        
        //decide the dimension based on the orientation of the device.
        let dimension = (UIDevice.currentDevice().orientation.isPortrait) ?  (self.view.frame.width - (2 * space)) / 3.0 : (self.view.frame.height - (2 * space)) / 3.0
        sentMemeCollectionFlowLayout.minimumInteritemSpacing = space
        sentMemeCollectionFlowLayout.minimumLineSpacing = space
        sentMemeCollectionFlowLayout.itemSize = CGSizeMake(dimension, dimension)
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        
        //Ref: http://stackoverflow.com/questions/29090837/uicollectionview-not-refreshing
        sentMemeCollectionView.reloadData()
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
