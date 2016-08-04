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
}
