//
//  UIImageViewExt.swift
//  Messunity
//
//  Created by Shumakov Dmytro on 13.11.2022.
//

import UIKit
import Kingfisher
import Foundation

extension UIImageView {
    
    func setImage(url: String?) {
        let imageUrl = URL(string: url ?? "")
        let processor = ResizingImageProcessor(referenceSize: self.frame.size) |> RoundCornerImageProcessor(cornerRadius: 0)
        
        self.kf.indicatorType = .activity
        self.kf.setImage(
        with: imageUrl,
        placeholder: UIImage(named: "placeholderImage"),
        options: [
            .processor(processor),
            .scaleFactor(UIScreen.main.scale),
            .transition(.fade(1)),
            .cacheOriginalImage
        ], completionHandler: {
            result in
            switch result {
            case .success(let value):
                print("Task done for: \(value.source.url?.absoluteString ?? "")")
            case .failure(let error):
                print("Job failed: \(error.localizedDescription)")
            }
        })
    }
}

