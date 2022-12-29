//
//  + Gif.swift
//  toDo-Ro
//
//  Created by Дмитрий Собин on 29.12.22.
//

import UIKit
import SwiftyGif

class LogoAnimationView: UIView {

    let logoGifImageView: UIImageView = {
        var iv = UIImageView()

        if let gif = try? UIImage(gifName: "first.gif") {
            iv = UIImageView(gifImage: gif, loopCount: 1)
            iv.translatesAutoresizingMaskIntoConstraints = false
        }
        return iv
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        addSubview(logoGifImageView)
        logoGifImageView.centerXAnchor.constraint(
            equalTo: self.centerXAnchor).isActive = true
        logoGifImageView.centerYAnchor.constraint(
            equalTo: centerYAnchor).isActive = true
//        logoGifImageView.widthAnchor.constraint(equalToConstant: 200).isActive = true
//        logoGifImageView.heightAnchor.constraint(equalToConstant: 200).isActive = true
    }
}
