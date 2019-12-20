//
//  Scoring.swift
//  FoodTracker
//
//  Created by Justin Zhang on 10/19/19.
//

import Foundation

public class Scoring {

    private let difference: Int
    private var type: ScoringType {
        getScoreType()
    }
    private var points: Int {
        getPoints()
    }

    public init(difference: Int) {
        self.difference = difference
//        self.type = getScoreType()
    }

    public func getMessage() -> String {
        switch type {
        case .perfect:
            return "Perfect Hit!"
        case .close:
            return "You were only \(difference) away from the target!"
        case .far:
            return "You were \(difference) away from the target. Try again!"
        }
    }

    private func getScoreType() -> ScoringType {
        if difference == 0 {
            return .perfect
        } else if difference < 5 {
            return .close
        } else {
            return .far
        }
    }

    public func getPoints() -> Int {
        switch type {
        case .perfect:
            return 3
        case .close:
            return 1
        case .far:
            return 0
        }
    }

    private enum ScoringType {
        case perfect
        case close
        case far
    }
}
