//
//  Ractagle.swift
//  toDo-Ro
//
//  Created by Дмитрий Собин on 12.01.23.
//

import Foundation
import UIKit

final class RatingView: UIView {
    
    private var labelPercentageNumber: UILabel!
    private var roundView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        initSubviews()
    }
    
    func updateCirclePercentage(percent: Double, count: Int) {
        if percent != 100  {
            createRound(percent: percent)
            
            labelPercentageNumber.text = percent >= 10
            ? "🔥"
            : "\(count)"
        }
    }
}

private extension RatingView {
    private func initSubviews() {
        self.backgroundColor = .clear
        initPercentageLabelNumber()
    }
    
    private func createRound(percent: Double) {
        roundView = UIView(frame: CGRect(x: 0,
                                         y: 0,
                                         width: 50,
                                         height: 50))
        roundView.backgroundColor = .clear
        roundView.layer.cornerRadius = roundView.frame.size.width / 2
        
        let circlePath = UIBezierPath(arcCenter: CGPoint (x: roundView.frame.size.width / 2,
                                                          y: roundView.frame.size.height / 2),
                                      radius: roundView.frame.size.width / 2,
                                      startAngle: CGFloat(-0.5 * .pi),
                                      endAngle: CGFloat(1.5 * .pi),
                                      clockwise: true)
        self.addSubview(roundView)
        
        let circleShapeBackground = createShape(circlePath)
        roundView.layer.addSublayer(circleShapeBackground)
        circleShapeBackground.strokeColor = (percent < 0.5)
        ? UIColor.systemMint.cgColor
        : UIColor.systemPink.cgColor
        circleShapeBackground.strokeEnd = CGFloat(1)
        
        let circleShape = createShape(circlePath)
        roundView.layer.addSublayer(circleShape)
        circleShape.strokeColor = (percent < 0.5)
        ? UIColor.systemPink.cgColor
        : UIColor.systemMint.cgColor
        circleShape.strokeEnd = CGFloat(percent/10)
        
    }
    
    private func initPercentageLabelNumber() {
        labelPercentageNumber = UILabel()
        labelPercentageNumber.font = UIFont.systemFont(ofSize: 15)
        labelPercentageNumber.textColor = .label
        labelPercentageNumber.backgroundColor = .clear
        labelPercentageNumber.textAlignment = .center
        labelPercentageNumber.frame = CGRect(x: 0,
                                             y: 0,
                                             width: 10,
                                             height: 10)
        self.addSubview(labelPercentageNumber)
        
        labelPercentageNumber.translatesAutoresizingMaskIntoConstraints = false
        let constraints = [
            labelPercentageNumber.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0),
            labelPercentageNumber.centerYAnchor.constraint(equalTo: self.centerYAnchor, constant: 0),
            labelPercentageNumber.heightAnchor.constraint(equalToConstant: 20),
            labelPercentageNumber.widthAnchor.constraint(equalToConstant: 20)
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
    
    private func createShape(_ circlePath: UIBezierPath) -> CAShapeLayer {
        let circleShape = CAShapeLayer()
        circleShape.path = circlePath.cgPath
        circleShape.fillColor = UIColor.clear.cgColor
        circleShape.lineWidth = 2.5
        circleShape.strokeStart = 0.0
        return circleShape
    }
}
