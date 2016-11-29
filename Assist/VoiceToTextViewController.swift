//
//  VoiceToTextViewController.swift
//  Assist
//
//  Created by Hasham Ali on 11/20/16.
//  Copyright © 2016 Assist. All rights reserved.
//

import UIKit

class VoiceToTextViewController: UIViewController {

    @IBOutlet weak var voiceButton: UIButton!
    @IBOutlet weak var voiceTextLabel: UILabel!
    
    private var homeViewController: HomeViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupCallback()
    }
    
    private func setupView() {
        voiceButton.layer.cornerRadius = voiceButton.bounds.height / 2
        voiceButton.backgroundColor = UIColor(hexString: "#c42f2fff")
        voiceButton.setImage(UIImage(named: "voice_icon"), for: .normal)
        voiceButton.contentMode = UIViewContentMode.center
        voiceButton.layer.shadowColor = UIColor.gray.cgColor
        voiceButton.layer.shadowOpacity = 0.5
        voiceButton.layer.shadowOffset = CGSize.zero
        voiceButton.layer.shadowRadius = 5
        
        voiceTextLabel.text = "Test message from voice!"
    }
    
    private func setupCallback() {
        let presenting = self.presentingViewController
        if let homeNavController = presenting as? UINavigationController {
            self.homeViewController = homeNavController.viewControllers.first as? HomeViewController
        }
    }

    @IBAction func onVoiceButtonClick(_ sender: UIButton) {
        if (VoiceToTextClient.sharedInstance.recordToggle(outputView: voiceTextLabel)) {
            dismiss(animated: true, completion: {
                self.homeViewController?.showMessageView(message: self.voiceTextLabel.text! + "\n")
            })
            
        }
    }
}
