//
//  WorldView.swift
//  GameOfLife
//
//  Created by Sumit Anantwar on 05/08/2018.
//  Copyright © 2018 Sumit Anantwar. All rights reserved.
//

import UIKit

class WorldView: UIView {

    // Outlets
    @IBOutlet var container: UIView!
    
    // Public
    /// Defines the Horizontal Cell Count
    /// Vertical Cell are calculated automatically
    var density: Int = 0 {
        didSet {
            updateView(forGliderGun: false)
        }
    }
    
    // Private
    private var world: World = World(width: 0, height: 0)
    private var cellFrameSize: CGFloat = 0.0
    
    // Designated Initializer
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.backgroundColor = .orange
    }
}

// MARK: - Public APIs
extension WorldView {
    
    /// Takes a next Step towards Evolution...
    func nextStep() {
        self.world.react()
        
        setNeedsDisplay()
    }
    
    /// Resets the World
    func reset() {
        updateView(forGliderGun: false)
    }
    
    func resetForGliderGun() {
        updateView(forGliderGun: true)
    }
}


// MARK: - Drawing
extension WorldView {
    // Update on set Density
    fileprivate func updateView(forGliderGun gliderGun:Bool) {
        
        self.cellFrameSize = self.bounds.size.width / CGFloat(density)
        
        // Column Ccount == Density
        let colCount = density
        // Row Count == ScreenHieght / Cell Size
        let rowCount = Int(self.bounds.height / cellFrameSize)
        
        self.world = World(width: colCount, height: rowCount)
        self.world.initialize()
        
        if gliderGun {
            // Preconfigure for Glider Gun
            self.world.preConfigureForGliderGun()
        }
        else {
            // Preconfigure random 10%
            self.world.preConfigureRandomTenPercent()
        }
        
        setNeedsDisplay()
    }
    
    // Draw
    override func draw(_ rect: CGRect) {
        let context = UIGraphicsGetCurrentContext()
        
        func fillColorForCell (state: State) -> UIColor {
            switch state {
                case .Alive             : return .blue
                case .Dead              : return .lightGray
                case .Unborn            : return .white
            }
        }
        
        func frameForCell (cell: Cell) -> CGRect {
            
            let cellSize    = CGSize(width: self.cellFrameSize, height: self.cellFrameSize)
            let cellX       = CGFloat(cell.x) * cellSize.width
            let cellY       = CGFloat(cell.y) * cellSize.height
            
            return CGRect(x: cellX, y: cellY, width: cellSize.width, height: cellSize.height)
        }
        
        // Draw all the cells
        for cell in world.cells {
            context!.setFillColor(fillColorForCell(state: cell.state).cgColor)
            context!.setStrokeColor(UIColor.gray.withAlphaComponent(0.5).cgColor)
            context!.setLineWidth(0.5)
            context!.addRect(frameForCell(cell: cell))
            context!.drawPath(using: .fillStroke)
        }
    }
}


