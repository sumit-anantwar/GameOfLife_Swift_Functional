//
//  ViewController.swift
//  GameOfLife
//
//  Created by Sumit Anantwar on 04/08/2018.
//  Copyright © 2018 Sumit Anantwar. All rights reserved.
//

import UIKit

class GameOfLifeViewController: UIViewController {

    // Outlets
    @IBOutlet weak var worldView: WorldView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var gliderGunButton: UIButton!
    
    
    // Timer for animating the World
    private var worldTimer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ======= Initialize the Views =======
        // Play / Pause Button
        self.playPauseButton.backgroundColor = .white
        self.playPauseButton.setBorder(rounded: true, borderWidth: 2.0, borderColor: .orange)
        
        // Reset Button
        self.resetButton.backgroundColor = .white
        self.resetButton.setBorder(rounded: true, borderWidth: 2.0, borderColor: .orange)
        
        // Glider Gun Button
        self.gliderGunButton.backgroundColor = .white
        self.gliderGunButton.setBorder(rounded: true, borderWidth: 2.0, borderColor: .orange)
        
        // ======= Initialize the World =======
        // Set the Horizontal Cell Density for the World
        self.worldView.density = 50;
        
        // Update the Button States
        updateButtonStates()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Button Tap Listeners
    @IBAction func didPressPlayButton(_ sender: UIButton) {
        playPause()
    }
    
    @IBAction func didPressResetButton(_ sender: UIButton) {
        self.worldView.reset()
    }
    
    @IBAction func didPressGliderGunButton(_ sender: UIButton) {
        self.worldView.resetForGliderGun()
    }
    
    
}

// MARK: - Button State Management
extension GameOfLifeViewController {
    
    fileprivate func playPause() {
        
        if self.worldTimer.isValid {
            self.worldTimer.invalidate()
        }
        else {
            self.worldTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { (_) in
                self.worldView.nextStep()
            })
        }
        
        // Update the Button States
        updateButtonStates()
    }
    
    /// Updates the Buttons based on the current state
    fileprivate func updateButtonStates() {
        self.resetButton.setTitle("🔄", for: .normal)
        self.gliderGunButton.setTitle("✈️", for: .normal)
        
        if self.worldTimer.isValid {
            self.playPauseButton.setTitle("⏸", for: .normal)
            self.resetButton.disable()
            self.gliderGunButton.disable()
        }
        else {
            self.playPauseButton.setTitle("▶️", for: .normal)
            self.resetButton.enable()
            self.gliderGunButton.enable()
        }
    }
}

