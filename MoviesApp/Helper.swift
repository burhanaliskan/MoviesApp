//
//  Helper.swift
//  MoviesApp
//
//  Created by Burhan Alışkan on 30.07.2021.
//

import UIKit
import Kingfisher

struct Helper {
    
    //MARK: - Set ImageView
    static func setImage(with imageLink: String, with imageView: UIImageView) {
        let url = URL(string: Api.imdbImageLink + imageLink)
        let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
                     
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
    
    //MARK: - Set ImageView with Corner Radius
    static func setImage(with imageLink: String, with imageView: UIImageView, with cornerRadius: CGFloat) {
        let url = URL(string: Api.imdbImageLink + imageLink)
        let processor = DownsamplingImageProcessor(size: imageView.bounds.size)
            |> RoundCornerImageProcessor(cornerRadius: cornerRadius)
        imageView.kf.indicatorType = .activity
        imageView.kf.setImage(
            with: url,
            options: [
                .processor(processor),
                .scaleFactor(UIScreen.main.scale),
                .transition(.fade(1)),
                .cacheOriginalImage
            ])
    }
}
