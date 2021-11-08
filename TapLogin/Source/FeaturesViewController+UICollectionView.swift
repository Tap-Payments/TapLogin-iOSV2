//
//  FeaturesViewController+UICollectionView.swift
//  TapLogin
//
//  Created by Dennis Pashkov on 12/13/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import struct CoreGraphics.CGGeometry.CGSize
import class UIKit.UICollectionView.UICollectionView
import class UIKit.UICollectionViewCell.UICollectionViewCell
import protocol UIKit.UICollectionView.UICollectionViewDataSource
import protocol UIKit.UICollectionView.UICollectionViewDelegateFlowLayout
import class UIKit.UICollectionViewLayout.UICollectionViewLayout
import class UIKit.UIScrollView.UIScrollView

extension FeaturesViewController: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    // MARK: - Public -
    // MARK: Methods

    public override func viewWillLayoutSubviews() {

        self.invalidateCollectionViewLayout()
        super.viewWillLayoutSubviews()
    }

    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {

        return self.features.count + 1
    }

    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        if indexPath.item == 0 {

            let reuseIdentifier = InitialFeatureCell.tap_className
            return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        } else {

            let reuseIdentifier = FeatureCell.tap_className
            return collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        }
    }

    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {

        if let initialFeatureCell = cell as? InitialFeatureCell {

            initialFeatureCell.delegate = self
            initialFeatureCell.isPlayVideoButtonHidden = self.isPlayVideoButtonHidden
            initialFeatureCell.image = TapLogin.dataSource?.initialFeatureCellImage

        } else if let featureCell = cell as? FeatureCell {

            let index = indexPath.item - 1
            let feature = self.features[index]

            featureCell.setTitle(feature.title, detailedTitle: feature.description, image: feature.image)
        }
    }

    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

        return collectionView.bounds.size
    }

    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {

        if decelerate {
            return
        }

        self.updatePageControlCurrentPage()
        TapLogin.delegate?.featuresControllerFeatureScrolled()
    }

    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {

        self.updatePageControlCurrentPage()
        TapLogin.delegate?.featuresControllerFeatureScrolled()
    }

    // MARK: - Private -
    // MARK: Properties

    private var features: [Feature] {

        return TapLogin.dataSource?.features ?? []
    }
}
