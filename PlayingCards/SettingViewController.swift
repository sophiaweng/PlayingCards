//
//  SettingViewController.swift
//  PlayingCards
//
//  Created by 翁淑惠 on 2020/11/30.
//

import UIKit
import SafariServices

class SettingViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    @IBSegueAction func setCardBack(_ coder: NSCoder, sender: Any?, segueIdentifier: String?) -> GameViewController? {
        GameViewController(coder: coder, setBack: segueIdentifier ?? "blue")
    }
    
    @IBAction func showWebSite(_ sender: UIButton) {
        //show Sophia's Medium
        if let url = URL(string: "https://medium.com/@sophiasophiaweng") {
            let safariController = SFSafariViewController(url: url)
            present(safariController, animated: true, completion: nil)
        }
    }

}
