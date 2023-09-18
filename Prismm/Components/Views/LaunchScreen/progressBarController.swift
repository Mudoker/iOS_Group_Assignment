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
    var timer = Timer()
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        moveProgressBar(to: 0.6, time: 2.0)
    }
    
    func moveProgressBar(to : Float, time: Float) {
        let currentPosition = progressBar.progress
        print(currentPosition)
        var difference  = (to - currentPosition) * 100
        if (difference < 0){
            difference *= -1
        }
       
        let timeRepeat = time /  difference
        
        var i : Float = 0.0
        timer = Timer.scheduledTimer(withTimeInterval: TimeInterval(timeRepeat), repeats: true, block: {(timer) in
            if (currentPosition > to){
                self.progressBar.progress -= 0.0001
            }
            else{
                self.progressBar.progress += 0.0001
            }
            i += 1
            if (i >= difference){
                timer.invalidate()
            }
        })
    }
}
