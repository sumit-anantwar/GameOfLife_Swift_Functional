//
//  Cell.swift
//  GameOfLife
//
//  Created by Sumit Anantwar on 05/08/2018.
//  Copyright © 2018 Sumit Anantwar. All rights reserved.
//

import Foundation

// MARK: - Cell State Enum
enum State {
    case Alive, Dead, Unborn
}

// MARK: - Cell
class Cell {
    let x: Int, y: Int
    var state: State
    var neighbours: [Cell]
    
    init(x: Int, y:Int) {
        self.x = x
        self.y = y
        self.state = .Unborn
        self.neighbours = [Cell]()
    }

}

// MARK: - Hashable
extension Cell: Hashable {
    
    var hashValue: Int {
        return x + y * 1_000
    }
}
// MARK: Equatable
func == (lhs: Cell, rhs: Cell) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y
}

