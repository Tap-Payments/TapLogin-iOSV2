//
//  InitialFeatureCell.swift
//  TapLogin
//
//  Created by Dennis Pashkov on 12/13/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import CoreGraphics
import TapViewControllerV2
import UIKit
/// Initial feature cell.
internal class InitialFeatureCell: TapCollectionViewCell {

    // MARK: - Internal -
    // MARK: Properties

    /// Delegate.
    internal weak var delegate: InitialFeatureCellDelegate?

    /// Defines if play video button is hidden.
    internal var isPlayVideoButtonHidden: Bool = true {

        didSet {

            self.playVideoButton?.isHidden = self.isPlayVideoButtonHidden
        }
    }

    /// Image.
    internal var image: UIImage? {

        didSet {

            self.imageView?.image = self.image
        }
    }

    // MARK: Methods

    internal required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
    }

    internal override init(frame: CGRect) {

        super.init(frame: frame)
    }

    // MARK: - Private -

    private struct Constants {

        fileprivate static let playVideoButtonImage: UIImage = {

            guard let result = UIImage(named: "btn_play_video_cell", in: .loginResourcesBundle, compatibleWith: nil) else {

                fatalError("Failed to load image named btn_play_video_cell from login resources bundle.")
            }

            return result
        }()

        fileprivate static let playVideoButtonHighlightedImage: UIImage = {

            guard let result = UIImage(named: "btn_play_video_cell_pressed", in: .loginResourcesBundle, compatibleWith: nil) else {

                fatalError("Failed to load image named btn_play_video_cell_pressed from login resources bundle.")
            }

            return result
        }()

        @available(*, unavailable) private init() {}
    }

    // MARK: Properties

    @IBOutlet private weak var imageView: UIImageView? {

        didSet {

            self.imageView?.image = self.image
        }
    }

    @IBOutlet private weak var playVideoButton: UIButton? {

        didSet {

            self.playVideoButton?.setImage(Constants.playVideoButtonImage, for: .normal)
            self.playVideoButton?.setImage(Constants.playVideoButtonHighlightedImage, for: .highlighted)
        }
    }

    // MARK: Methods

    @IBAction private func playVideoButtonTouchUpInside(_ sender: UIButton) {

        self.delegate?.initialFeatureCell(self, playVideoButtonClicked: sender)
    }
}
