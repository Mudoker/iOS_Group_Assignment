/*
  RMIT University Vietnam
  Course: COSC2659 iOS Development
  Semester: 2023B
  Assessment: Assignment 3
  Author: Apple Men
  Doan Huu Quoc (s3927776)
  Tran Vu Quang Anh (s3916566)
  Nguyen Dinh Viet (s3927291)
  Nguyen The Bao Ngoc (s3924436)

  Created  date: 08/09/2023
  Last modified: 08/09/2023
  Acknowledgement: None
*/

import Foundation
import UIKit

class progressBarController : UIViewController {
    // Timer to control the animation
    var timer = Timer()
    
    // Outlet for the progress bar in the storyboard
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Start the progress animation when the view loads
        moveProgressBar(to: 0.6, time: 2.0)
    }
    
    // Function to animate the progress bar
    func moveProgressBar(to : Float, time: Float) {
        // Get the current position of the progress bar
        let currentPosition = progressBar.progress
        print(currentPosition)
        
        // Calculate the difference between the current position and the target
        var difference  = (to - currentPosition) * 100
        
        // Ensure difference is positive
        if (difference < 0){
            difference *= -1
        }
       
        // Calculate the time interval for each step of the animation
        let timeRepeat = time /  difference
        
        // Initialize a counter
        var i : Float = 0.0
        
        // Schedule a timer to update the progress bar in small increments
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timeRepeat), repeats: true, block: { timer in
            
            // Update the progress bar based on the direction of movement
            if (currentPosition > to){
                self.progressBar.progress -= 0.0001
            }
            else{
                self.progressBar.progress += 0.0001
            }
            
            // Increment the counter
            i += 1
            
            // Invalidate the timer when the animation is complete
            if (i >= difference){
                timer.invalidate()
            }
        })
    }
}
