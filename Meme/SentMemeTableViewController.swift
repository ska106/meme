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
    var memes:[MemeModel]
                {
                    return (UIApplication.sharedApplication().delegate as! AppDelegate).memes
                }
    
    @IBOutlet var memeTableView: UITableView!
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
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
        let favoriteThingForRow = self.memes[indexPath.row]
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
        detailController.memeImage = self.memes[indexPath.row]
        self.navigationController!.pushViewController(detailController, animated: true)
    }
}
