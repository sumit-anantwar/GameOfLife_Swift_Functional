//
//  World.swift
//  GameOfLife
//
//  Created by Sumit Anantwar on 05/08/2018.
//  Copyright © 2018 Sumit Anantwar. All rights reserved.
//

import Foundation

class World {
    // Config Properties
    let gridWidth: Int, gridHeight: Int
    
    // Cell Store
    var cells: [Cell]
    
    init(width gridWidth: Int, height gridHeight: Int) {
        
        self.gridWidth  = gridWidth
        self.gridHeight = gridHeight
        
        self.cells = [Cell]()
    }
}

// MARK: - Initialize
extension World {
    
    /// Initialization with an iterative approach
    func initialize() {
        
        // local function to pre-fetch the neighbours Iteratively
        // We already know that the cell can have max of 8 neighbours
        // This gives us a (cellCount * 8) = O(8n) = O(n) time complexity
        func neighboursForCell(cell: Cell) -> [Cell] {
            var neighbouringCells = [Cell]()
            // Neighbours
            // All the neighbours of the cell lie in the range of 1 cell befor and after itself (-1...1)
            for dy in -1...1 {
                for dx in -1...1 {
                    if let neighbour = self[cell.x + dx, cell.y + dy] {
                        // While iterating we should ignore counting the cell itself
                        if (neighbour != cell) {
                            neighbouringCells.append(neighbour)
                        }
                    }
                }
            }
            
            return neighbouringCells
        }
        
        // Populate the Cells
        for y in 0..<self.gridHeight {
            for x in 0..<self.gridWidth {
                
                let cell = Cell(x: x, y: y)
                self.cells.append(cell)
            }
        }
        
        // Pre-Fetch the neighbours so that we can later apply filters directly
        for cell in self.cells {
            cell.neighbours = neighboursForCell(cell: cell)
        }
        
    }
}

// MARK: - Public APIs
extension World {
    
    /// Fetch Cell at position (x, y)
    subscript (x:Int, y:Int) -> Cell? {
        if (0..<self.gridWidth ~= x) && (0..<self.gridHeight ~= y) {
            let cellIndex = (gridWidth * y) + x
            if 0..<self.cells.count ~= cellIndex {
                return self.cells[cellIndex]
            }
        }
        
        return nil
    }
    
    /// Make the World React to the current state
    func react () {
        
        func aliveNeighbourCountForCell(cell: Cell) -> Int {
            return cell.neighbours.filter { $0.state == .Alive }.count
        }
        
        let aliveCells  = self.cells.filter { $0.state == .Alive }
        let deadCells   = self.cells.filter { $0.state != .Alive }
        
        // Filter the diying cells
        // Rules ---
        // aliveCell.aliveNeighbours < 2 || > 3
        let dyingCells = aliveCells.filter {
            let aliveNeighbourCount = aliveNeighbourCountForCell(cell: $0)
            return (aliveNeighbourCount < 2) || (aliveNeighbourCount > 3)
        }
        
        // Filter the incarnating cells
        // Rules ---
        // deadCell.aliveNeighbours == 3
        let incarnatingCells = deadCells.filter { aliveNeighbourCountForCell(cell: $0) == 3 }
        
        
        // All other cells remain unchanged
        // Rules ---
        // Cells Alive || Dead with neighbours == 2, dont change state
        // =======
        
        // Apply the new State
        for cell in incarnatingCells {
            cell.state = .Alive
        }
        
        for cell in dyingCells {
            cell.state = .Dead
        }
    }
    
}

// MARK: - PreConfigurations
extension World {
    /// Make 10% of the cells Alive
    func preConfigureRandomTenPercent() {
        for _ in 0...(self.cells.count / 10) {
            let x = Int(arc4random_uniform(UInt32(gridWidth)))
            let y = Int(arc4random_uniform(UInt32(gridHeight)))
            
            self[x, y]?.state = .Alive
        }
    }
    
    /// Setup for Glider Gun Configuration
    func preConfigureForGliderGun() {
        self[1, 5]?.state = .Alive
        self[2, 5]?.state = .Alive
        self[1, 6]?.state = .Alive
        self[2, 6]?.state = .Alive
        
        self[13, 3]?.state = .Alive
        self[14, 3]?.state = .Alive
        self[12, 4]?.state = .Alive
        self[16, 4]?.state = .Alive
        self[11, 5]?.state = .Alive
        self[17, 5]?.state = .Alive
        self[11, 6]?.state = .Alive
        self[15, 6]?.state = .Alive
        self[17, 6]?.state = .Alive
        self[18, 6]?.state = .Alive
        self[11, 7]?.state = .Alive
        self[17, 7]?.state = .Alive
        self[12, 8]?.state = .Alive
        self[16, 8]?.state = .Alive
        self[13, 9]?.state = .Alive
        self[14, 9]?.state = .Alive
        
        self[25, 1]?.state = .Alive
        self[23, 2]?.state = .Alive
        self[25, 2]?.state = .Alive
        self[21, 3]?.state = .Alive
        self[22, 3]?.state = .Alive
        self[21, 4]?.state = .Alive
        self[22, 4]?.state = .Alive
        self[21, 5]?.state = .Alive
        self[22, 5]?.state = .Alive
        self[23, 6]?.state = .Alive
        self[25, 6]?.state = .Alive
        self[25, 7]?.state = .Alive
        
        self[35, 3]?.state = .Alive
        self[36, 3]?.state = .Alive
        self[35, 4]?.state = .Alive
        self[36, 4]?.state = .Alive
    }
    
    
}
