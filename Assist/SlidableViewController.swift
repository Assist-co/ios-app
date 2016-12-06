//
//  SlidableViewController.swift
//  Assist
//
//  Created by Hasham Ali on 12/3/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

class SlidableViewController: UIViewController {
    var slidingViewController: SlidingViewController!
    var isUISetup = false
    /*
     SlidingViewController loads all the child view controllers first which blocks on the main thread.
     To fix that issue we do the loading in the background and must ensure that all UI operations 
     are done on the mainthread. So for example using MBProgressHud on load.
     Perform all UI operations for the child view controllers in this method. This method gets
     executed on the mainthread.
     */
    func setupMainThreadOperations(){}
}
