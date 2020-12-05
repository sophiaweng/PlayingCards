//
//  Card.swift
//  PlayingCards
//
//  Created by 翁淑惠 on 2020/12/4.
//

import Foundation

struct Card {
    var name: String = ""
    var suit: Float = 0
    var number: Int = 0
    var image: String = ""
}

enum Suit: Float {
    case spade = 0.4
    case heart = 0.3
    case diamond = 0.2
    case club = 0.1
}
