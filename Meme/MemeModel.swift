//
//  MemeModel.swift
//  Meme
//
//  Created by Sudeep Agrawal on 7/16/16.
//  Copyright © 2016 Agrawal. All rights reserved.
//

import Foundation
import UIKit

// As per the rubic evaluation all the meme images must be stored in this struct.
struct MemeModel
{
    var topLabel:String!
    var bottomLabel:String!
    var originalImage = UIImage()
    var savedMemeImage = UIImage();
}