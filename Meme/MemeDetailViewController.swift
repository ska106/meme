//
//  MemeDetailViewController.swift
//  Meme
//
//  Created by Sudeep Agrawal on 8/6/16.
//  Copyright © 2016 Agrawal. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController:UIViewController
{
    
    @IBOutlet weak var memeImageView: UIImageView!
    var memeImage:MemeModel!
    
    override func prefersStatusBarHidden() -> Bool
    {
        return true     // status bar should be hidden
    }
    
    override func viewWillAppear(animated: Bool)
    {
        super.viewWillAppear(animated)
        memeImageView.image = memeImage?.savedMemeImage
        
        //Hide the tab bar at the bottom of the view.
        self.tabBarController?.tabBar.hidden = true
    }
    
    override func viewWillDisappear(animated: Bool)
    {
        super.viewWillDisappear(animated)
        
        //Unhide the tab bar at the bottom of the view.
        self.tabBarController?.tabBar.hidden = false
    }
}
