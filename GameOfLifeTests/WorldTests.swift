//
//  WorldTests.swift
//  GameOfLifeTests
//
//  Created by Sumit Anantwar on 05/08/2018.
//  Copyright © 2018 Sumit Anantwar. All rights reserved.
//

import XCTest

@testable import GameOfLife

class WorldTests: XCTestCase {
    
    let world = World(width: 10, height: 10)
    
    override func setUp() {
        super.setUp()
        
        world.initialize()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    /// Test case for fetching cell at a given coordinate
    func testFetchCellAtXAndY() {
        
        // =====================
        // Test Cell @ (0, 0)
        var expectedX = 0, expectedY = 0
        // Cell should not be Nil
        guard let cell1 = world[expectedX, expectedY] else {
            // We cannot Assert the Cell here
            // but, execution reaches here only if cell is nil
            // so, we can make a pseudo AssertNotNil, and explain the issue
            XCTAssertNotNil(nil, "Cell at position (\(expectedX), \(expectedY)), should not be nil")
            return
        }
        
        // Assert Cell Position
        XCTAssertEqual(cell1.x, expectedX)
        XCTAssertEqual(cell1.y, expectedY)
        
        
        // =====================
        // Test Cell @ (x < gridWidth, y < gridHeight)
        expectedX = 5; expectedY = 7
        // Cell should not be Nil
        guard let cell2 = world[expectedX, expectedY] else {
            XCTAssertNotNil(nil, "Cell at position (\(expectedX), \(expectedY)), should not be nil")
            return
        }
        // Assert Cell Position
        XCTAssertEqual(cell2.x, expectedX)
        XCTAssertEqual(cell2.y, expectedY)
        
        
        // =====================
        // Test Cell @ (x >= gridWidth, y >= gridHeight)
        expectedX = 10; expectedY = 11
        // We are trying to fetch a Cell which is outside of the grid bounds
        let cell3 = world[expectedX, expectedY]
        // Assert that the Cell is Nil
        XCTAssertNil(cell3)
        
        
        // =====================
        // Test Cell @ (x < 0, y < 0)
        expectedX = -1; expectedY = -1
        // We are trying to fetch a Cell which is outside of the grid bounds
        let cell4 = world[expectedX, expectedY]
        // Assert that the Cell is Nil
        XCTAssertNil(cell4)
    }
    
    
    func testNeighbours() {
        
        // Cell at (0, 0) has 3 neighbours (1, 0) (1, 1) and (0, 1)
        let cell0 = world[0, 0]
        XCTAssertEqual(cell0!.neighbours.count, 3)
        
        // Cell at (0, 0) has 3 neighbours (1, 0) (1, 1) and (0, 1)
        let cell1 = world[1, 0]
        XCTAssertEqual(cell1!.neighbours.count, 5)
        
        let cell2 = world[7, 7]
        XCTAssertEqual(cell2!.neighbours.count, 8)
        
        let cell3 = world[9, 9]
        XCTAssertEqual(cell3!.neighbours.count, 3)
        
    }
    
    /// Performance Testing of World Initialization
    func testPerformanceIterativeWorldInitialization() {
        self.measure {
            let world = World(width: 100, height: 100)
            world.initialize()
            let cell = world[0, 0]
            print("Cell Position -- \(cell!.x), \(cell!.y)")
        }
    }
    
    func testReaction() {
        
        // Create a configuration for Testing
        // Here we have a 10 x 10 World
        
        // ======= Alive cell with less than 2 neighbours, should die
        // Make a cell at (5, 0) alive
        let aliveCellWithLessThanTwoNeighbours = world[5, 0]
        aliveCellWithLessThanTwoNeighbours?.state = .Alive
        // Give it a single Alive neighbour
        world[4, 0]?.state = .Alive
        
        // ======= Alive cell with exactly 2 neighbours lives on to the next generation
        // Make a cell at (2, 2) Alive
        let aliveCellWithExactlyTwoNeighbours = world[2, 2]
        aliveCellWithExactlyTwoNeighbours?.state = .Alive
        // Give it two Alive neighbours
        world[1, 2]?.state = .Alive
        world[2, 3]?.state = .Alive
        
        // ======= Dead cell with exactly 3 neighbours becomes Alive
        // Make a cell at (7, 3) Dead
        let deadCellWithThreeNeighbours = world[7, 3]
        deadCellWithThreeNeighbours?.state = .Dead
        // Give it three Alive neighbours
        world[6, 3]?.state = .Alive // Left
        world[7, 4]?.state = .Alive // Bottom
        world[8, 2]?.state = .Alive // Top-Right
        
        // ======= Alive cell with more than 3 neighbours dies
        // Make a cell at (4, 7) Alive
        let aliveCellWithMoreThanThreeNeighbours = world[4, 7]
        aliveCellWithMoreThanThreeNeighbours?.state = .Alive
        // Give it four Alive neighbours
        world[3, 7]?.state = .Alive // Left
        world[4, 6]?.state = .Alive // Top
        world[5, 6]?.state = .Alive // Top-Right
        world[4, 8]?.state = .Alive // Bottom
        
        // ======= Dead cell with more than 3 alive neighbours remain dead
        // Make a cell at (4, 7) Alive
        let deadCellWithMoreThanThreeNeighbours = world[8, 8]
        deadCellWithMoreThanThreeNeighbours?.state = .Dead
        // Give it four Alive neighbours
        world[7, 8]?.state = .Alive // Left
        world[7, 7]?.state = .Alive // Top-Left
        world[9, 7]?.state = .Alive // Top-Right
        world[7, 9]?.state = .Alive // Bottom-Left
        
        // Make the World React to the current state
        world.react()
        
        
        // ======= Assertions =======
        // Alive cell with less than 2 neighbours, should die
        XCTAssertEqual(aliveCellWithLessThanTwoNeighbours?.state, .Dead)
        
        // Alive cell with exactly 2 neighbours lives on to the next generation
        XCTAssertEqual(aliveCellWithExactlyTwoNeighbours?.state, .Alive)
        
        // Dead cell with exactly 3 neighbours becomes Alive
        XCTAssertEqual(deadCellWithThreeNeighbours?.state, .Alive)
        
        // Alive cell with more than 3 neighbours dies
        XCTAssertEqual(aliveCellWithMoreThanThreeNeighbours?.state, .Dead)
        
        // Dead cell with more than 3 neighbours remains Dead
        XCTAssertEqual(deadCellWithMoreThanThreeNeighbours?.state, .Dead)
    }
}
