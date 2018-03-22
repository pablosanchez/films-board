//
//  SCLAlertViewBuilder.swift
//  FilmsBoard
//
//  Created by Pablo on 22/03/2018.
//  Copyright © 2018 Pablo. All rights reserved.
//

import UIKit
import SCLAlertView

class SCLAlertViewBuilder {

    var title = ""
    var subtitle = ""
    var closeButtonTitle = ""
    var circleIconImage: UIImage?

    func setTitle(_ title: String) -> SCLAlertViewBuilder {
        self.title = title
        return self
    }

    func setSubtitle(_ subtitle: String) -> SCLAlertViewBuilder {
        self.subtitle = subtitle
        return self
    }

    func setCloseButtonTitle(_ title: String) -> SCLAlertViewBuilder {
        self.closeButtonTitle = title
        return self
    }

    func setCircleIconImage(_ image: UIImage?) -> SCLAlertViewBuilder {
        self.circleIconImage = image
        return self
    }

    func show() {
        SCLAlertView().showWarning(self.title, subTitle: self.subtitle,
            closeButtonTitle: self.closeButtonTitle, circleIconImage: self.circleIconImage,
            animationStyle: .topToBottom)
    }
}
