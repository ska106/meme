//
//  SentMemeTableViewController.swift
//  Meme
//
//  Created by Sudeep Agrawal on 8/3/16.
//  Copyright © 2016 Agrawal. All rights reserved.
//

import Foundation
import UIKit

class SentMemeTableViewController:UITableViewController
{
    var memes:[MemeModel]!
    
    @IBOutlet var memeTableView: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // For the image to scale properly.
        memeTableView.contentMode = UIViewContentMode.ScaleAspectFit
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        self.memes = (UIApplication.sharedApplication().delegate as! AppDelegate).memes
        print ("[TableVC] :::: Total sized of sent memes =  \(memes.count) " )
        memeTableView.reloadData()
    }
    
    
    /**
     * Number of Rows
     */
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return self.memes.count
    }
    
    /**
     * Cell For Row At Index Path
     */
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("memeTableCell")! as! SentMemeTableCell
        let favoriteThingForRow = self.memes![indexPath.row]
        cell.imageCell.image = favoriteThingForRow.savedMemeImage
        cell.labelCell.text = "TOP:"+favoriteThingForRow.topLabel + " BOTTOM: " + favoriteThingForRow.bottomLabel
        return cell
    }
    
    /*
     * Display the DetailView controller when an image is selected from the Table.
     */
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath)
    {
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("MemeDetailViewController") as! MemeDetailViewController
        detailController.memeImage = self.memes![indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
    
    /*
     * Added a swipe to delete function in the table vie to delete a sent meme.
     * Ref: http://stackoverflow.com/questions/24103069/swift-add-swipe-to-delete-tableviewcell
     */
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath)
    {
        if (editingStyle == UITableViewCellEditingStyle.Delete)
        {
            if let tv = memeTableView
            {
                self.memes!.removeAtIndex(indexPath.row)
                tv.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
                // to update the global memme repository
                (UIApplication.sharedApplication().delegate as! AppDelegate).memes = self.memes
            }
        }
    }
}
