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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
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
}
