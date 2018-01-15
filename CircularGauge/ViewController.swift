//
//  ViewController.swift
//  CircularGauge
//
//  Created by Clement DEUST on 18/12/2017.
//  Copyright © 2017 Clement DEUST. All rights reserved.
//

import UIKit

class ViewController: UIViewController, CircularGaugeDelegate {
    
    @IBOutlet weak var value: UILabel!
    
    var informationButton: UIButton!
    
    func didUpdateProgressValue(to newValue: CGFloat) {
        self.value.text = "\(Int(newValue))"
    }
    
    func finishedUpdatingProgress(forRing ring: CircularGaugeView) {
        if ring == gauge {
            print("animation finished")
        }
        if ring == gauge2 {
            print("animation 2 finished")
        }
    }
    
    func clickedOnImageLayer(forRing ring: CircularGaugeView) {
        if ring == gauge {
            let alertViewController = UIAlertController(title: "Information", message: "clicked on information", preferredStyle: .alert)
            let actionOK = UIAlertAction(title: "OK", style: .default, handler: { (action) in
                alertViewController.dismiss(animated: true, completion: nil)
            })
            alertViewController.addAction(actionOK)
            self.present(alertViewController, animated: true, completion: nil)
        }
        if ring == gauge2 {
            print("tapped from ring 2")
        }
    }
    
    func clickedOnValueLabel(forRing ring: CircularGaugeView) {
        let alertViewController = UIAlertController(title: "Gauge Layer", message: "clicked on gauge layer", preferredStyle: .alert)
        let actionOK = UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alertViewController.dismiss(animated: true, completion: nil)
        })
        alertViewController.addAction(actionOK)
        self.present(alertViewController, animated: true, completion: nil)
    }
    

    @IBOutlet weak var gauge: CircularGaugeView!
    @IBOutlet weak var gauge2: CircularGaugeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.

        // Change any of the properties you'd like
        gauge.backGaugeWidth = 10
        gauge2.backGaugeWidth = 10
        gauge.topGaugeWidth = 10
        gauge2.topGaugeWidth = 10
        gauge.animationStyle = kCAMediaTimingFunctionLinear
        gauge2.animationStyle = kCAMediaTimingFunctionLinear
        gauge2.delegate = self
        gauge2.gaugeLayer.valueDelegate = gauge2
        gauge.delegate = self
        gauge.ringStyle = .gradient
        gauge2.ringStyle = .gradient
        gauge.gradientColors = [UIColor.red, UIColor.brown, UIColor.orange]
        gauge.gradientStartPosition = .top
        gauge.gradientEndPosition = .bottom
        gauge.clockwise = true
        gauge2.gradientColors = [UIColor.blue, UIColor.green, UIColor.cyan]
        gauge2.gradientStartPosition = .left
        gauge2.gradientEndPosition = .right
        gauge2.clockwise = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func animateButtonTapped(_ sender: UIButton) {
        self.gauge.value = 0
        self.gauge2.value = 0
        
        self.gauge2.backGaugeColor = UIColor.clear
        self.gauge.backGaugeColor = UIColor.clear
        let random: Double = Double(randomNumber(inRange: 0...50))
        let random2: Double = Double(random) + Double(randomNumber(inRange: 0...50))
        self.gauge2.setProgress(value: CGFloat(random2), animationDuration: 0.5)
        self.gauge.setProgress(value: CGFloat(random), animationDuration: 0.5, completion: nil)
        
        let informationProgress = random2 / 100
        gauge.configure(duration: 0.5, progress: Double(informationProgress))
        gauge.informationImageWidth = 20
        gauge.show(addons: .information(tint: UIColor.red))
        gauge.animate()
        
        //self.gauge2.animateButton()
    }
}

func randomNumber<T : SignedInteger>(inRange range: ClosedRange<T> = 1...100) -> T {
    let length = Int64(range.upperBound - range.lowerBound + 1)
    let value = Int64(arc4random()) % length + Int64(range.lowerBound)
    return T(value)
}

