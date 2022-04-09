//
//  ViewController.swift
//  CircularProgressView
//
//  Created by Sudan Tuladhar on 09/04/2022.
//

import UIKit

class ViewController: UIViewController {
    
    private var trackColor = UIColor.orange.withAlphaComponent(0.5)
    private var progressColor = UIColor.orange
    
    private var circularProgressView: UIView = {
        let view = UIView()
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        return view;
    }()
    
    private var progressLabel: UILabel = {
        let label = UILabel()
        label.textColor = .orange
        label.font = UIFont.boldSystemFont(ofSize: 44)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var trackLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 20.0
        layer.strokeEnd = 1.0
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()
    
    private var progressLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.lineWidth = 20.0
        layer.strokeEnd = 0.0
        layer.lineCap = .round
        layer.fillColor = UIColor.clear.cgColor
        return layer
    }()
    
    private let MAX_DURATION: Double = 1 * 60 // seconds
    private let TICKER: Double = 1.0
    
    private var progress: Double = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCircularProgressView()
    }
    
    private func configureCircularProgressView() {
        self.view.backgroundColor = .white
        
        self.view.addSubview(circularProgressView)
        self.view.addSubview(progressLabel)
        
        NSLayoutConstraint.activate([
            circularProgressView.widthAnchor.constraint(equalToConstant: 200.0),
            circularProgressView.heightAnchor.constraint(equalToConstant: 200.0),
            circularProgressView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            circularProgressView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            progressLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            progressLabel.centerYAnchor.constraint(equalTo: self.view.centerYAnchor)
        ])
        
        view.layoutIfNeeded()
        
        circularProgressView.layer.cornerRadius = circularProgressView.frame.width/2
        
        let circularPath = UIBezierPath(
            arcCenter: CGPoint(x: circularProgressView.frame.width/2,
                               y: circularProgressView.frame.height/2),
            radius: (circularProgressView.frame.width)/2,
            startAngle: CGFloat(-0.5 * .pi),
            endAngle: CGFloat(1.5 * .pi),
            clockwise: true)
        
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.path = circularPath.cgPath
        circularProgressView.layer.addSublayer(trackLayer)
        
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.path = circularPath.cgPath
        circularProgressView.layer.addSublayer(progressLayer)
        
        var counter: Double = 0.0
        let timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _timer in
            
            counter += self.TICKER
            
            let _progress = counter / (self.MAX_DURATION * self.TICKER)
            self.progressLayer.strokeEnd = CGFloat(_progress)
            self.progressLabel.text = String(format: "%d", (Int(self.MAX_DURATION - _progress * self.MAX_DURATION)))
            
            self.progress = _progress
            if self.progress >= 1.0 {
                _timer.invalidate()
            }
        }
        
        timer.fire()
    }
}

