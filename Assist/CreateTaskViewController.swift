//
//  CreateTaskViewController.swift
//  Assist
//
//  Created by christopher ketant on 12/2/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

class CreateTaskViewController: UIViewController, UIScrollViewDelegate, UITextViewDelegate, UIGestureRecognizerDelegate {
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var textView: UITextView!
    private var createTaskToolBarView: CreateTaskToolBarView!
    private var tagListView: TagListView!
    private var isFirstAppearance: Bool = false
    private let placeholderText = "Enter task here!"
    private var isTagListShowing: Bool = false
    override var canBecomeFirstResponder: Bool{
        get{
            return true
        }
    }
    override var inputAccessoryView: UIView{
        get{
            return self.toolBarBuilder()
        }
    }
    
    //MARK:- View Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.scrollView.contentSize = self.view.frame.size;
        self.scrollView.contentSize.height = self.scrollView.contentSize.height
    }
    
    //MARK:- UITextViewDelegate
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray && !self.isFirstAppearance {
            textView.text = nil
            textView.textColor = UIColor.black
        }else{
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            self.isFirstAppearance = false
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = self.placeholderText
            textView.textColor = UIColor.lightGray
        }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = textView.text as NSString?
        let updatedText = currentText?.replacingCharacters(in: range, with: text)
        if (updatedText?.isEmpty)! {
            
            textView.text = self.placeholderText
            textView.textColor = UIColor.lightGray
            
            textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
            
            return false
        }
        else if textView.textColor == UIColor.lightGray && !text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.black
        }
        
        return true
    }
    
    //MARK:- UIScrollView Delegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 && !scrollView.isDragging {
            UIView.animate(withDuration: 0.3, animations: {
                scrollView.contentOffset.y = 0
            }, completion: { (success: Bool) in
                
            })
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > 0 && !scrollView.isDragging {
            UIView.animate(withDuration: 0.3, animations: {
                scrollView.contentOffset.y = 0
            }, completion: { (success: Bool) in
                
            })
        }

    }
    
    //MARK:- Action
    
    func toolBarPressed(button: UIButton){
        self.createTaskToolBarView.backgroundColor = UIColor.groupTableViewBackground
        if !self.isTagListShowing {
            self.textView.resignFirstResponder()
            UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseIn, animations: {
                let y = (self.view.frame.size.height - self.tagListView.frame.size.height)
                self.tagListView.frame = CGRect(x: 0,
                                                y: y,
                                                width: self.tagListView.frame.size.width,
                                                height: self.tagListView.frame.size.height)
            }) { (success: Bool) in
                
            }
            self.view.addSubview(self.tagListView)
            self.view.bringSubview(toFront: self.tagListView)
            self.isTagListShowing = true
        }
    }
    
    func toolBarHighlighted(button: UIButton){
        self.createTaskToolBarView.backgroundColor = UIColor.lightGray
    }
    
    //MARK:- Utils
    
    fileprivate func setup(){
        self.tagListView = UINib(nibName: "TagListView", bundle: nil)
            .instantiate(withOwner: nil, options: nil)[0] as! TagListView
        self.tagListView.frame.size.width = self.view.frame.size.width
        self.textView.text = self.placeholderText
        self.textView.textColor = UIColor.lightGray
        self.textView.frame.size.height = 0
        self.textView.becomeFirstResponder()
    }
    
    fileprivate func toolBarBuilder() -> UIView{
        self.createTaskToolBarView = UINib(nibName: "CreateTaskToolBarView", bundle: nil)
            .instantiate(withOwner: nil, options: nil)[0] as! CreateTaskToolBarView
        self.createTaskToolBarView.frame.size.width = self.view.frame.size.width
        self.createTaskToolBarView.backgroundColor = UIColor.groupTableViewBackground
        self.createTaskToolBarView.selectButton.addTarget(self, action: #selector(toolBarPressed(button:)), for: .touchUpInside)
        self.createTaskToolBarView.selectButton.addTarget(self, action: #selector(toolBarHighlighted(button:)), for: .touchDown)
        return self.createTaskToolBarView
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

}
