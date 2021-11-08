//
//  FeaturesViewController.swift
//  TapLogin
//
//  Created by Dennis Pashkov on 12/13/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import TapViewControllerV2
import UIKit

/// Features view controller.
public class FeaturesViewController: TapViewController {

    // MARK: - Public -
    // MARK: Properties

    /// Page index.
    public var pageIndex: Int = 0

    /// Defines if play video button is hidden.
    public var isPlayVideoButtonHidden: Bool = true {

        didSet {

            self.featuresCollectionView?.reloadData()
        }
    }

    // MARK: Methods

    public override func viewDidLoad() {

        super.viewDidLoad()
        self.featuresCollectionView?.contentOffset.x = 0
        self.pageIndex = 0
        self.setupFeaturesPageCotrol()

        if !(TapLogin.videoManager?.canPlayVideo ?? false) {

            self.addVideoLoadingObservers()
        }
    }

    public override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        TapLogin.applicationInterface?.setStatusBarHidden(false, with: .fade)

        self.updateVideoUI()
    }

    public override func updateLocalization() {

        super.updateLocalization()

        DispatchQueue.main.async {

            let visibleIndexPath = IndexPath(item: self.pageIndex, section: 0)

            if #available(iOS 9.0, *) {

                if let semanticContentAttribute = TapLogin.applicationInterface?.requiredSemanticContentAttribute {

                    self.view.semanticContentAttribute = semanticContentAttribute
                    self.featuresCollectionView?.semanticContentAttribute = semanticContentAttribute
                    self.featuresPageControl?.semanticContentAttribute = semanticContentAttribute
                }
            }

            self.featuresCollectionView?.reloadData()
            self.featuresCollectionView?.scrollToItem(at: visibleIndexPath, at: .centeredHorizontally, animated: false)

            self.updatePageControlCurrentPage()
        }
    }

    public func updatePageControlCurrentPage() {

        guard let width = self.featuresCollectionView?.bounds.width else { return }

        self.pageIndex = Int(( self.featuresCollectionView!.contentOffset.x + 0.5 * width ) / width)

        if TapLogin.applicationInterface?.layoutDirection == .rightToLeft {

            self.pageIndex = (featuresPageControl?.numberOfPages)! - self.pageIndex - 1
            self.featuresPageControl?.currentPage = self.pageIndex

        } else {

            self.featuresPageControl?.currentPage = self.pageIndex
        }
    }

    public func invalidateCollectionViewLayout() {

        if let collectionViewLayout = self.featuresCollectionView?.collectionViewLayout {

            collectionViewLayout.invalidateLayout()
        }
    }

    // MARK: - Private -
    // MARK: Properties

    @IBOutlet private weak var featuresCollectionView: UICollectionView? {

        didSet {

            self.featuresCollectionView?.allowsMultipleSelection = false
            self.automaticallyAdjustsScrollViewInsets = false

            self.featuresCollectionView?.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: false)

            if #available(iOS 9.0, *) {

                if let semanticContentAttribute = TapLogin.applicationInterface?.requiredSemanticContentAttribute {

                    self.featuresCollectionView?.semanticContentAttribute = semanticContentAttribute
                }
            }
        }
    }

    @IBOutlet private weak var featuresPageControl: UIPageControl? {

        didSet {

            if #available(iOS 9.0, *) {

                if let semanticContentAttribute = TapLogin.applicationInterface?.requiredSemanticContentAttribute {

                    self.featuresPageControl?.semanticContentAttribute = semanticContentAttribute
                }
            }
        }
    }

    // MARK: Methods

    private func setupFeaturesPageCotrol() {

        let numberOfPages = self.collectionView(self.featuresCollectionView!, numberOfItemsInSection: 0)
        self.featuresPageControl?.numberOfPages = numberOfPages

        if TapLogin.applicationInterface?.layoutDirection == .rightToLeft {

            self.featuresPageControl?.currentPage = numberOfPages - self.pageIndex - 1

        } else {

            self.featuresPageControl?.currentPage = 0
        }
    }

    private func addVideoLoadingObservers() {

        NotificationCenter.default.addObserver(self, selector: #selector(videoLoadingStateChanged(_:)), name: .didLoadWelcomeVideoURLs, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(videoLoadingStateChanged(_:)), name: .didFailToLoadWelcomeVideoURLs, object: nil)
    }

    private func removeVideoLoadingObservers() {

        NotificationCenter.default.removeObserver(self, name: .didLoadWelcomeVideoURLs, object: nil)
        NotificationCenter.default.removeObserver(self, name: .didFailToLoadWelcomeVideoURLs, object: nil)
    }

    @objc private func videoLoadingStateChanged(_ notification: Notification) {

        DispatchQueue.main.async { [weak self] in

            self?.updateVideoUI()
        }
    }

    private func updateVideoUI() {

        self.isPlayVideoButtonHidden = !(TapLogin.videoManager?.canPlayVideo ?? false)
    }

    @IBAction private func featuresPageControlValueChanged(_ sender: Any) {

        guard let currentPage = featuresPageControl?.currentPage else { return }

        let indexPath = IndexPath(item: currentPage, section: 0)

        self.featuresPageControl?.currentPage = indexPath.row
        self.featuresCollectionView?.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

// MARK: - InitialFeatureCellDelegate
extension FeaturesViewController: InitialFeatureCellDelegate {

    internal func initialFeatureCell(_ cell: InitialFeatureCell, playVideoButtonClicked button: UIButton) {

        TapLogin.videoManager?.playVideo()
    }
}
