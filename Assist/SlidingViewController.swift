//
//  SlidingViewController.swift
//  Assist
//
//  Created by Hasham Ali on 12/3/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

class SlidingViewController: UIViewController {
    
    var mainViewController: UIViewController! {
        didSet {
            view.layoutIfNeeded()
            mainViewController.view.frame = mainContent.frame
            mainViewController.view.setNeedsLayout()
            mainViewController.view.layoutIfNeeded()
            mainContent.addSubview(mainViewController.view)
        }
    }
    
    var leftViewController: UIViewController! {
        didSet {
            view.layoutIfNeeded()
            leftViewController.view.setNeedsLayout()
            leftViewController.view.layoutIfNeeded()
            leftContent.addSubview(leftViewController.view)
        }
    }
    
    var rightViewController: UIViewController! {
        didSet {
            view.layoutIfNeeded()
            rightViewController.view.setNeedsLayout()
            rightViewController.view.layoutIfNeeded()
            rightContent.addSubview(rightViewController.view)
        }
    }
    
    @IBOutlet weak var mainContent: UIView!
    @IBOutlet weak var leftContent: UIView!
    @IBOutlet weak var rightContent: UIView!
    
    private var originalLeftMargin: CGFloat!
    private var originalMainMargin: CGFloat!
    private var originalRightMargin: CGFloat!
    
    enum CurrentPosition {
        case left
        case middle
        case right
    }
    
    private var currentPosition = CurrentPosition.middle

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func showLeftContent() {
        UIView.animate(withDuration: 0.25, animations: {
            self.rightContent.frame.origin.x = 2 * self.rightContent.bounds.width
            self.mainContent.frame.origin.x = self.rightContent.bounds.width
            self.leftContent.frame.origin.x = 0
        })
        currentPosition = .left
    }
    
    func showRightContent() {
        UIView.animate(withDuration: 0.25, animations: {
            self.rightContent.frame.origin.x = 0
            self.mainContent.frame.origin.x = -self.leftContent.bounds.width
            self.leftContent.frame.origin.x = -2 * self.leftContent.bounds.width
        })
        currentPosition = .right
    }
    
    func showMainContent() {
        UIView.animate(withDuration: 0.25, animations: {
            self.rightContent.frame.origin.x = self.rightContent.bounds.width
            self.mainContent.frame.origin.x = 0
            self.leftContent.frame.origin.x = -self.leftContent.bounds.width
        })
        currentPosition = .middle
    }

    @IBAction func onViewPan(_ panGestureRecognizer: UIPanGestureRecognizer) {
        let translation = panGestureRecognizer.translation(in: view)
        let velocity = panGestureRecognizer.velocity(in: view)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.began {
            originalLeftMargin = leftContent.frame.origin.x
            originalMainMargin = mainContent.frame.origin.x
            originalRightMargin = rightContent.frame.origin.x
        } else if panGestureRecognizer.state == UIGestureRecognizerState.changed {
            let potentialLeftMargin = originalLeftMargin + translation.x
            if potentialLeftMargin >= (-2 * leftContent.bounds.width) && potentialLeftMargin <= 0 {
                leftContent.frame.origin.x = potentialLeftMargin
            }
            
            let potentialMainMargin = originalMainMargin + translation.x
            if potentialMainMargin >= -leftContent.bounds.width && potentialMainMargin <= rightContent.bounds.width {
                mainContent.frame.origin.x = potentialMainMargin
            }
            
            let potentialRightMargin = originalRightMargin + translation.x
            if potentialRightMargin >= 0 && potentialLeftMargin <= (2 * rightContent.bounds.width) {
                rightContent.frame.origin.x = potentialRightMargin
            }
        } else if panGestureRecognizer.state == UIGestureRecognizerState.ended {
            if abs(velocity.x) > abs(velocity.y) {
                if velocity.x > 0 {
                    slideRight()
                } else {
                    slideLeft()
                }
            } else {
                switch self.currentPosition {
                case .left:
                    if abs(translation.x) > view.frame.width/2 {
                        showMainContent()
                    } else {
                        showLeftContent()
                    }
                case .middle:
                    if abs(translation.x) > view.frame.width/2 && translation.x < 0 {
                        showRightContent()
                    } else if abs(translation.x) > view.frame.width/2 && translation.x > 0 {
                        showLeftContent()
                    } else {
                        showMainContent()
                    }
                case .right:
                    if abs(translation.x) > view.frame.width/2 {
                        showMainContent()
                    } else {
                        showRightContent()
                    }
                }
            }

        } else if panGestureRecognizer.state == UIGestureRecognizerState.cancelled {
            
        }
    }
    
    private func slideLeft() {
        if (rightContent.frame.origin.x > rightContent.bounds.width) {
            showMainContent()
        } else {
            showRightContent()
        }
    }
    
    private func slideRight() {
        if (leftContent.frame.origin.x < -leftContent.bounds.width) {
            showMainContent()
        } else {
            showLeftContent()
        }
    }
}
