//
//  LanguageSelectionViewController.swift
//  TapLocalization-UI
//
//  Created by Dennis Pashkov on 2/1/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import TapAdditionsKitV2
import TapApplicationV2
import TapBrandBookIOSV2
import TapLocalizationV2
import TapViewControllerV2
import UIKit
/// View controller to select application language.
public class LanguageSelectionViewController: TapViewController {

    // MARK: - Public -
    // MARK: Properties

    /// Application interface
    public weak var applicationInterface: TapApplication?

    /// Localization data source.
    public weak var localizationDataSource: LocalizationLocalizationDataSource?

    /// Delegate
    public weak var delegate: LanguageSelectionViewControllerDelegate?

    // MARK: Methods

    /// Instantiated LanguageSelectionViewController
    ///
    /// - Returns: LanguageSelectionViewController
    public static func instantiate() -> Self {

        guard let navController = UIStoryboard.countries.instantiateInitialViewController() as? TapNavigationController else {

            fatalError("Failed to load languages list navigation controller from storyboard.")
        }

        guard let result = navController.tap_rootViewController as? LanguageSelectionViewController else {

            fatalError("Root view controller is incorrect.")
        }

        return result.tap_asSelf()
    }

    public override func viewDidLoad() {

        super.viewDidLoad()
        self.selectCurrentLanguage()
        self.addSupportedLanguagesObserver()
    }

    public override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        self.applicationInterface?.setStatusBarStyle(.default, animated: animated)
    }

    public override func updateLocalization() {

        super.updateLocalization()

        self.reloadTableContent()

        if let navigationBar = self.navigationController?.navigationBar {

            UINavigationBarBrander.brand(navigationBar, with: .default)
        }

        if let nonnullCancelButton = self.cancelButton {

            UIBarButtonItemBrander.brand(nonnullCancelButton, with: .navigationBar)
            nonnullCancelButton.title = self.localizationDataSource?.localizedString(for: .navigationBarCancelTitle)
        }

        if let nonnullDoneButton = self.doneButton {

            UIBarButtonItemBrander.brand(nonnullDoneButton, with: .navigationBar)
            nonnullDoneButton.title = self.localizationDataSource?.localizedString(for: .navigationBarDoneTitle)
        }

        self.title = self.localizationDataSource?.localizedString(for: .navigationBarTitle)
    }

    deinit {

        self.removeSupportedLanguagesObserver()
    }

    // MARK: - Private -
    // MARK: Properties

    @IBOutlet private weak var languageTableView: UITableView?
    @IBOutlet private weak var cancelButton: UIBarButtonItem?
    @IBOutlet private weak var doneButton: UIBarButtonItem?

    fileprivate lazy var currentSelectedLanguage: String = LocalizationManager.shared.currentLanguage

    // MARK: Methods

    @IBAction private func cancelButtonTouchUpInside(_ sender: Any) {

        self.hide()
    }

    @IBAction private func doneButtonTouchUpInside(_ sender: Any) {

        self.delegate?.languageSelectionViewController(self, didSelect: self.currentSelectedLanguage)
        self.hide()
    }

    private func selectCurrentLanguage() {

        let languages = LocalizationManager.shared.supportedLanguages

        var selectedIndexPath: IndexPath?

        if let index = languages.index(of: self.currentSelectedLanguage) {

            selectedIndexPath = IndexPath(row: index, section: 0)
        }

        if let nonnullIndexPath = selectedIndexPath {

            self.languageTableView?.selectRow(at: nonnullIndexPath, animated: true, scrollPosition: .none)
        }
    }

    private func addSupportedLanguagesObserver() {

        NotificationCenter.default.addObserver(self, selector: #selector(supportedLanguagesChanged(_:)), name: tapSupportedLanguagesListChangedNotificationName, object: nil)
    }

    private func removeSupportedLanguagesObserver() {

        NotificationCenter.default.removeObserver(self, name: tapSupportedLanguagesListChangedNotificationName, object: nil)
    }

    @objc private func supportedLanguagesChanged(_ notification: Notification) {

        DispatchQueue.main.async { [weak self] in

            self?.reloadTableContent()
        }
    }

    private func reloadTableContent() {

        self.languageTableView?.reloadData()
        self.selectCurrentLanguage()
    }

    private func hide() {

        self.view.endEditing(true)

        DispatchQueue.main.async { [weak self] in

            self?.navigationController?.dismiss(animated: true, completion: nil)
        }
    }
}

// MARK: - UITableViewDataSource
extension LanguageSelectionViewController: UITableViewDataSource {

    public func numberOfSections(in tableView: UITableView) -> Int {

        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return  LocalizationManager.shared.supportedLanguages.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        let languageIdentifier = LocalizationManager.shared.supportedLanguages[indexPath.row]

        guard let cell = tableView.dequeueReusableCell(withIdentifier: LanguageTableViewCell.tap_className) as? LanguageTableViewCell else {

            fatalError("Failed to load \(LanguageTableViewCell.tap_className) from storyboard.")
        }

        let icon = LocalizationManager.shared.icon(for: languageIdentifier)
        let alignment: NSTextAlignment = self.applicationInterface?.layoutDirection == .rightToLeft ? .right : .left

        cell.titleTextAlignment = alignment
        cell.setIcon(icon)
        cell.setLanguageIdentifier(languageIdentifier)

        return cell
    }
}

// MARK: - UITableViewDelegate
extension LanguageSelectionViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let languageData = LocalizationManager.shared.supportedLanguages[indexPath.row]
        self.currentSelectedLanguage = languageData
    }
}
