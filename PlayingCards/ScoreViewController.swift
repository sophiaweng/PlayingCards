//
//  ScoreViewController.swift
//  PlayingCards
//
//  Created by 翁淑惠 on 2020/11/30.
//

import UIKit

class ScoreViewController: UIViewController {
    
    @IBOutlet weak var resultTextView: UITextView!
    let resultAry: Array<String>
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        for result in resultAry {
            if resultTextView.text!.contains("尚無資料") {
                resultTextView.text! = result
            } else {
                resultTextView.text! += ("\n\n"+result)
            }
        }
    }
    
    init?(coder: NSCoder, resultAry: Array<String>) {
        self.resultAry = resultAry
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
