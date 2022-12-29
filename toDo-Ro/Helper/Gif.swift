//
//  Gif.swift
//  toDo-Ro
//
//  Created by Дмитрий Собин on 29.12.22.
//

import UIKit
import SwiftyGif

final class LogoAnimationView: UIView {

    let logoGifImageView: UIImageView = {
        var gifLogo = UIImageView()

        if let gif = try? UIImage(gifName: "first.gif") {
            gifLogo = UIImageView(gifImage: gif, loopCount: 1)
            gifLogo.translatesAutoresizingMaskIntoConstraints = false
        }
        return gifLogo
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
        logoGifImageView.centerXAnchor.constraint(equalTo: self.centerXAnchor).isActive = true
        logoGifImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
