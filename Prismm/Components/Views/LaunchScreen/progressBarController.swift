//
//  progressBarController.swift
//  Prismm
//
//  Created by Tran Vu Quang Anh  on 08/09/2023.
//

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
