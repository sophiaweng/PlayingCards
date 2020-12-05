//
//  GameViewController.swift
//  PlayingCards
//
//  Created by 翁淑惠 on 2020/11/30.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet weak var robotCard: UIButton!
    @IBOutlet weak var playerCard: UIButton!
    @IBOutlet weak var rdmCard1: UIButton!
    @IBOutlet weak var rdmCard2: UIButton!
    @IBOutlet weak var rdmCard3: UIButton!
    @IBOutlet weak var rdmCard4: UIButton!
    @IBOutlet weak var robotScoreLabel: UILabel!
    @IBOutlet weak var playerScoreLabel: UILabel!
    @IBOutlet weak var countDownLabel: UILabel!
    
    var timer = Timer()
    var countDownSec: Int!
    let setBack: String!
    var cardAry: Array<Card>?
    var resultAry: Array<String>?
    var robotResult: Float?
    var playerResult: Float?
    var robotRandomCard: Card?
    var playerRandomCard: Card?
    var robotScore: Int!
    var playerScore: Int!
    
    init?(coder: NSCoder, setBack: String) {
        self.setBack = setBack
        super.init(coder: coder)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //start count down
        countDownSec = 15
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerCountDown), userInfo: nil, repeats: true)
        //set card back image
        rdmCard1.setImage(UIImage(named: "back_"+setBack), for: .normal)
        rdmCard2.setImage(UIImage(named: "back_"+setBack), for: .normal)
        rdmCard3.setImage(UIImage(named: "back_"+setBack), for: .normal)
        rdmCard4.setImage(UIImage(named: "back_"+setBack), for: .normal)
        robotCard.setImage(UIImage(named: "back_"+setBack), for: .normal)
        playerCard.setImage(UIImage(named: "back_nocolor"), for: .normal)
        //init all cards and result cards and score
        getShuffledCards()
        resultAry = []
        robotResult = 0
        playerResult = 0
        robotRandomCard = nil
        playerRandomCard = nil
        robotScore = 0
        playerScore = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        //stop count down
        timer.invalidate()
    }
    
    @objc func timerCountDown() {
        countDownSec -= 1
        countDownLabel.text = String(format: "%02i:%02i", (countDownSec/60), (countDownSec))
        if countDownSec == 0 {
            timer.invalidate()
            alertTimeoutMsg()
        }
    }
    
    func alertTimeoutMsg() {
        let timeoutController = UIAlertController(title: "時間終了", message: "", preferredStyle: .actionSheet)
        let finishAction  = UIAlertAction(title: "結束遊戲", style: .default) {(UIAlertAction) in
            //do nothing
        }
        timeoutController.addAction(finishAction)
        present(timeoutController, animated: true, completion: nil)
    }
    
    @IBAction func pickCard(_ sender: UIButton) {
        if sender.currentTitle == "robotCard" {
            //show robot's card
            if robotCard.currentImage == UIImage(named: "back_"+setBack) {
                robotRandomCard = getRandomCard()
                robotResult = Float(robotRandomCard!.number) + robotRandomCard!.suit
                robotCard.setImage(UIImage(named: robotRandomCard!.image), for: .normal)
                //scoring
                if robotResult! > 0, playerResult! > 0 {
                    scoring()
                }
            }
        } else {
            //show player's card
            if self.playerCard.currentImage == UIImage(named: "back_nocolor") {
                //move selected card
                let animateView = UIImageView(image: UIImage(named: "back_"+setBack))
                animateView.frame = CGRect(x: sender.frame.minX, y: sender.frame.minY, width: sender.frame.width, height: sender.frame.height)
                view.addSubview(animateView)
                UIViewPropertyAnimator.runningPropertyAnimator(withDuration: 0.5, delay: 0, options: .curveLinear) { [self] in
                    animateView.center.x += (playerCard.center.x-animateView.center.x)
                    animateView.center.y -= (animateView.center.y-playerCard.center.y)
                } completion: { [self] _ in
                    //show player's card
                    playerRandomCard = getRandomCard()
                    playerResult = Float(playerRandomCard!.number) + playerRandomCard!.suit
                    sender.setImage(UIImage(named: "back_nocolor"), for: .normal)
                    playerCard.setImage(UIImage(named: playerRandomCard!.image), for: UIControl.State.normal)
                    animateView.removeFromSuperview()
                    //scoring
                    if robotResult! > 0, playerResult! > 0 {
                        scoring()
                    }
                }
            }
        }
    }
    
    func scoring() {
        if robotResult! > playerResult! {
            robotScore += 1
            robotScoreLabel.text = String(robotScore)
            resultAry?.append("😭 電腦 ["+robotRandomCard!.name+"] 贏 玩家 ["+playerRandomCard!.name+"] ")
            alertResultMsg(winner: "😭 電腦")
        } else if robotResult! < playerResult! {
            playerScore += 1
            playerScoreLabel.text = String(playerScore)
            resultAry?.append("😭 玩家 ["+playerRandomCard!.name+"] 贏 電腦 ["+robotRandomCard!.name+"] ")
            alertResultMsg(winner: "🥳 玩家")
        } else {
            alertResultMsg(winner: "😱 ？？")
        }
        robotResult = 0
        playerResult = 0
    }
    
    func alertResultMsg(winner: String) {
        if countDownSec > 0 {
            let resultController = UIAlertController(title: winner+"贏了", message: winner+"+1分", preferredStyle: .alert)
            let backAction  = UIAlertAction(title: "不玩了", style: .default) { (UIAlertAction) in
                //do nothing
            }
            let contAction = UIAlertAction(title: "繼續玩", style: .default) { (UIAlertAction) in
                //reset table cards
                self.rdmCard1.setImage(UIImage(named: "back_"+self.setBack), for: .normal)
                self.rdmCard2.setImage(UIImage(named: "back_"+self.setBack), for: .normal)
                self.rdmCard3.setImage(UIImage(named: "back_"+self.setBack), for: .normal)
                self.rdmCard4.setImage(UIImage(named: "back_"+self.setBack), for: .normal)
                self.robotCard.setImage(UIImage(named: "back_"+self.setBack), for: .normal)
                self.playerCard.setImage(UIImage(named: "back_nocolor"), for: .normal)
            }
            resultController.addAction(backAction)
            resultController.addAction(contAction)
            present(resultController, animated: true, completion: nil)
        }
    }
    
    func getShuffledCards() {
        cardAry = getAllCards().shuffled()
    }

    func getRandomCard() -> Card {
        //avoid get duplicated card
        if cardAry!.count == 0 {
            getShuffledCards()
        }
        let card = cardAry![0]
        cardAry!.remove(at: 0)
        return card
    }
    
    func getAllCards() -> Array<Card> {
        cardAry = [
            //Spade
            Card(name: "♠️黑桃2", suit: Suit.spade.rawValue, number: 2, image: "2S"),
            Card(name: "♠️黑桃3", suit: Suit.spade.rawValue, number: 3, image: "3S"),
            Card(name: "♠️黑桃4", suit: Suit.spade.rawValue, number: 4, image: "4S"),
            Card(name: "♠️黑桃5", suit: Suit.spade.rawValue, number: 5, image: "5S"),
            Card(name: "♠️黑桃6", suit: Suit.spade.rawValue, number: 6, image: "6S"),
            Card(name: "♠️黑桃7", suit: Suit.spade.rawValue, number: 7, image: "7S"),
            Card(name: "♠️黑桃8", suit: Suit.spade.rawValue, number: 8, image: "8S"),
            Card(name: "♠️黑桃9", suit: Suit.spade.rawValue, number: 9, image: "9S"),
            Card(name: "♠️黑桃10", suit: Suit.spade.rawValue, number: 10, image: "10S"),
            Card(name: "♠️黑桃J", suit: Suit.spade.rawValue, number: 11, image: "JS"),
            Card(name: "♠️黑桃Q", suit: Suit.spade.rawValue, number: 12, image: "QS"),
            Card(name: "♠️黑桃K", suit: Suit.spade.rawValue, number: 13, image: "KS"),
            Card(name: "♠️黑桃A", suit: Suit.spade.rawValue, number: 14, image: "AS"),
            //Heart
            Card(name: "❤️愛心2", suit: Suit.heart.rawValue, number: 2, image: "2H"),
            Card(name: "❤️愛心3", suit: Suit.heart.rawValue, number: 3, image: "3H"),
            Card(name: "❤️愛心4", suit: Suit.heart.rawValue, number: 4, image: "4H"),
            Card(name: "❤️愛心5", suit: Suit.heart.rawValue, number: 5, image: "5H"),
            Card(name: "❤️愛心6", suit: Suit.heart.rawValue, number: 6, image: "6H"),
            Card(name: "❤️愛心7", suit: Suit.heart.rawValue, number: 7, image: "7H"),
            Card(name: "❤️愛心8", suit: Suit.heart.rawValue, number: 8, image: "8H"),
            Card(name: "❤️愛心9", suit: Suit.heart.rawValue, number: 9, image: "9H"),
            Card(name: "❤️愛心10", suit: Suit.heart.rawValue, number: 10, image: "10H"),
            Card(name: "❤️愛心J", suit: Suit.heart.rawValue, number: 11, image: "JH"),
            Card(name: "❤️愛心Q", suit: Suit.heart.rawValue, number: 12, image: "QH"),
            Card(name: "❤️愛心K", suit: Suit.heart.rawValue, number: 13, image: "KH"),
            Card(name: "❤️愛心A", suit: Suit.heart.rawValue, number: 14, image: "AH"),
            //Diamond
            Card(name: "♦️方塊2", suit: Suit.diamond.rawValue, number: 2, image: "2D"),
            Card(name: "♦️方塊3", suit: Suit.diamond.rawValue, number: 3, image: "3D"),
            Card(name: "♦️方塊4", suit: Suit.diamond.rawValue, number: 4, image: "4D"),
            Card(name: "♦️方塊5", suit: Suit.diamond.rawValue, number: 5, image: "5D"),
            Card(name: "♦️方塊6", suit: Suit.diamond.rawValue, number: 6, image: "6D"),
            Card(name: "♦️方塊7", suit: Suit.diamond.rawValue, number: 7, image: "7D"),
            Card(name: "♦️方塊8", suit: Suit.diamond.rawValue, number: 8, image: "8D"),
            Card(name: "♦️方塊9", suit: Suit.diamond.rawValue, number: 9, image: "9D"),
            Card(name: "♦️方塊10", suit: Suit.diamond.rawValue, number: 10, image: "10D"),
            Card(name: "♦️方塊J", suit: Suit.diamond.rawValue, number: 11, image: "JD"),
            Card(name: "♦️方塊Q", suit: Suit.diamond.rawValue, number: 12, image: "QD"),
            Card(name: "♦️方塊K", suit: Suit.diamond.rawValue, number: 13, image: "KD"),
            Card(name: "♦️方塊A", suit: Suit.diamond.rawValue, number: 14, image: "AD"),
            //Club
            Card(name: "♣️梅花2", suit: Suit.club.rawValue, number: 2, image: "2C"),
            Card(name: "♣️梅花3", suit: Suit.club.rawValue, number: 3, image: "3C"),
            Card(name: "♣️梅花4", suit: Suit.club.rawValue, number: 4, image: "4C"),
            Card(name: "♣️梅花5", suit: Suit.club.rawValue, number: 5, image: "5C"),
            Card(name: "♣️梅花6", suit: Suit.club.rawValue, number: 6, image: "6C"),
            Card(name: "♣️梅花7", suit: Suit.club.rawValue, number: 7, image: "7C"),
            Card(name: "♣️梅花8", suit: Suit.club.rawValue, number: 8, image: "8C"),
            Card(name: "♣️梅花9", suit: Suit.club.rawValue, number: 9, image: "9C"),
            Card(name: "♣️梅花10", suit: Suit.club.rawValue, number: 10, image: "10C"),
            Card(name: "♣️梅花J", suit: Suit.club.rawValue, number: 11, image: "JC"),
            Card(name: "♣️梅花Q", suit: Suit.club.rawValue, number: 12, image: "QC"),
            Card(name: "♣️梅花K", suit: Suit.club.rawValue, number: 13, image: "KC"),
            Card(name: "♣️梅花A", suit: Suit.club.rawValue, number: 14, image: "AC")
            ]
        return cardAry!
    }
    @IBSegueAction func showScoreList(_ coder: NSCoder) -> ScoreViewController? {
        return ScoreViewController(coder: coder, resultAry: resultAry!)
    }
    
}
