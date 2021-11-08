//
//  CountriesListViewController.swift
//  TapCountriesKit-UI
//
//  Created by Dennis Pashkov on 11/22/17.
//  Copyright © 2017 Tap Payments. All rights reserved.
//

import CoreGraphics
import TapAdditionsKitV2
import TapApplicationV2
import TapBrandBookIOSV2
import TapCountriesKitV2
import TapGLKitV2
import TapSwiftFixesV2
import TapViewControllerV2
import TapVisualEffectViewV2
import UIKit

/// Countries List View Controller class.
public class CountriesListViewController: TapViewControllerWithSearch {

    // MARK: - Public -

    /// Country Filter closure.
    public typealias CountryFilterClosure = (Country) -> Bool

    /// Countries Sorting Closure.
    public typealias CountriesSortingClosure = ([Country]) -> [Country]

    /// Country display mode.
    ///
    /// - isdNumber: ISD number
    /// - twoLettersISOCode: Two Letters ISO code
    /// - threeLettersISOCode: Three Letters ISO code
    public enum CountryDisplayMode {

        case isdNumber
        case twoLettersISOCode
        case threeLettersISOCode
    }

    // MARK: Properties

    /// Specify a filter if not all countries should be shown. Default is nil.
    public var countriesFilterClosure: CountryFilterClosure?

    /// Specify this closure to order countries. Default is nil.
    public var countriesSortingClosure: CountriesSortingClosure?

    /// Countries display mode.
    public var countriesDisplayMode: CountryDisplayMode = .isdNumber

    /// Localization data source.
    public weak var localizationDataSource: CountriesKitLocalizationDataSource?

    /// Application interface
    public weak var applicationInterface: TapApplication?

    /// Delegate.
    public weak var delegate: CountriesListViewControllerDelegate?

    /// Selected country.
    public var selectedCountry: Country? {

        didSet {

            self.updateDoneButtonState()
        }
    }

    // MARK: Methods

    public static func instantiate() -> Self {

        guard let navController = UIStoryboard.countries.instantiateInitialViewController() as? TapNavigationController else {

            fatalError("Failed to load countries list navigation controller from storyboard.")
        }

        guard let result = navController.tap_rootViewController as? CountriesListViewController else {

            fatalError("Root view controller is incorrect.")
        }

        return result.tap_asSelf()
    }

    public override func viewDidLoad() {

        super.viewDidLoad()
        self.addCountriesDataSourceObservers()

        self.navigationController?.navigationBar.shadowImage = UIImage()
    }

    public override func viewWillAppear(_ animated: Bool) {

        super.viewWillAppear(animated)
        self.applicationInterface?.setStatusBarStyle(.default, animated: animated)
        self.updateDataAndUIBasedOnDataSourceStatus(animated)
        self.selectSelectedCountry()
        self.updateDoneButtonState()
    }

    public override func updateLocalization() {

        super.updateLocalization()

        if let navigationBar = self.navigationController?.navigationBar {

            UINavigationBarBrander.brand(navigationBar, with: .default)
        }

        if let nonnullCancelButton = self.cancelButton {

            UIBarButtonItemBrander.brand(nonnullCancelButton, with: .navigationBar)
            nonnullCancelButton.title = self.localizationDataSource?.localizedString(for: .navigataionBarCancelTitle)
        }

        if let nonnullDoneButton = self.doneButton {

            UIBarButtonItemBrander.brand(nonnullDoneButton, with: .navigationBar)
            nonnullDoneButton.title = self.localizationDataSource?.localizedString(for: .navigationBarDoneTitle)
        }

        self.title = self.localizationDataSource?.localizedString(for: .navigationBarTitle)

        if let application = self.applicationInterface, application.layoutDirection == .rightToLeft {

            self.tableView?.separatorInset = Constants.tableViewSeparatorInsets.tap_mirrored
        }
        else {

            self.tableView?.separatorInset = Constants.tableViewSeparatorInsets
        }
    }

    public override func searchViewTextChanged(_ text: String) {

        self.updateTableViewContent(with: text)
    }

    public override func bottomOffset(for openedKeyboard: Bool, height keyboardHeight: CGFloat) -> CGFloat {

        return openedKeyboard ? keyboardHeight : 0.0
    }

    deinit {

        self.removeCountriesDataSourceObservers()
    }

    // MARK: - Private -

    private struct Constants {

        fileprivate static let contentAppearanceDuration: TimeInterval = 0.3

        fileprivate static let tableViewSeparatorInsets = UIEdgeInsets(top: 0.0, left: 15.0, bottom: 0.0, right: 0.0)

        @available(*, unavailable) private init() {}
    }

    // MARK: Properties

    @IBOutlet private weak var cancelButton: UIBarButtonItem?
    @IBOutlet private weak var doneButton: UIBarButtonItem?

    @IBOutlet private weak var loadingBlurView: TapVisualEffectView? {

        didSet {

            self.loadingBlurView?.style = .light
        }
    }

    @IBOutlet private weak var loaderActivityIndicator: TapActivityIndicatorView?

    private lazy var unfilteredCountries: [Country] = []
    private lazy var filteredCountries: [Country] = []

    // MARK: Methods

    private func addCountriesDataSourceObservers() {

        NotificationCenter.default.addObserver(self, selector: #selector(countriesLoadingStatusChanged(_:)), name: .countriesDidStartLoading, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(countriesLoadingStatusChanged(_:)), name: .countriesDidFinishLoading, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(countriesLoadingStatusChanged(_:)), name: .countriesDidFailLoading, object: nil)
    }

    private func removeCountriesDataSourceObservers() {

        NotificationCenter.default.removeObserver(self, name: .countriesDidStartLoading, object: nil)
        NotificationCenter.default.removeObserver(self, name: .countriesDidFinishLoading, object: nil)
        NotificationCenter.default.removeObserver(self, name: .countriesDidFailLoading, object: nil)
    }

    private func selectSelectedCountry() {

        guard let country = self.selectedCountry else {

            if let selectedRow = self.tableView?.indexPathForSelectedRow {

                self.tableView?.deselectRow(at: selectedRow, animated: true)
            }

            return
        }

        if let index = self.filteredCountries.index(of: country) {

            let indexPath = IndexPath(row: index, section: 0)
            self.tableView?.selectRow(at: indexPath, animated: true, scrollPosition: .top)
        }
    }

    private func updateDoneButtonState() {

        self.doneButton?.isEnabled = self.selectedCountry != nil
    }

    private func updateTableViewContent(with searchText: String = .tap_empty) {

        if searchText.isEmpty {

            self.filteredCountries = self.unfilteredCountries.filter { _ in true }
        }
        else {

            self.filteredCountries = self.unfilteredCountries.filter {

                if $0.internationalName.tap_containsIgnoringCase(searchText) { return true }
                if $0.localizedName.tap_containsIgnoringCase(searchText) { return true }
                if $0.displayedISDNumber.tap_containsIgnoringCase(searchText) { return true }
                if $0.isoCode.twoLetters.tap_containsIgnoringCase(searchText) { return true }
                if $0.isoCode.threeLetters.tap_containsIgnoringCase(searchText) { return true }

                return false
            }
        }

        self.tableView?.reloadData()
    }

    private func displayedISDNumberOrISOCode(for country: Country) -> String {

        switch self.countriesDisplayMode {

        case .isdNumber:

            return country.displayedISDNumber

        case .threeLettersISOCode:

            return country.isoCode.threeLetters

        case .twoLettersISOCode:

            return country.isoCode.twoLetters
        }
    }

    @objc private func countriesLoadingStatusChanged(_ notification: Notification) {

        self.updateDataAndUIBasedOnDataSourceStatus()
    }

    private func updateDataAndUIBasedOnDataSourceStatus(_ animated: Bool = true) {

        DispatchQueue.main.async { [weak self] in

            self?.updateUnfilteredCountriesList()
            self?.updateTableViewContent()
            self?.setContentVisible(CountriesDataSource.shared.status != .loading, animated: animated)
            self?.selectSelectedCountry()
        }
    }

    private func updateUnfilteredCountriesList() {

        let filterClosure = self.countriesFilterClosure ?? { _ in return true }

        synchronized(self.unfilteredCountries) {

            let unsortedCountries = CountriesDataSource.shared.countries.filter(filterClosure)
            if let sortingClosure = self.countriesSortingClosure {

                self.unfilteredCountries = sortingClosure(unsortedCountries)
            }
            else {

                self.unfilteredCountries = unsortedCountries.sorted { $0.internationalName < $1.internationalName }
            }
        }
    }

    private func setContentVisible(_ visible: Bool, animated: Bool = true) {

        let animationDuration = animated ? Constants.contentAppearanceDuration : 0.0
        let options: UIViewAnimationOptions = [.beginFromCurrentState, .curveEaseInOut]

        if !visible {

            self.loaderActivityIndicator?.startAnimating()
        }

        let animations: TypeAlias.ArgumentlessClosure = { [weak self] in

            self?.loadingBlurView?.alpha = visible ? 0.0 : 1.0
        }

        let completion: TypeAlias.BooleanClosure = { [weak self] _ in

            if visible {

                self?.loaderActivityIndicator?.stopAnimating()
            }
        }

        UIView.animate(withDuration: animationDuration, delay: 0.0, options: options, animations: animations, completion: completion)
    }

    @IBAction private func cancelButtonTouchUpInside(_ sender: Any) {

        self.hide()
    }

    @IBAction private func doneButtonTouchUpInside(_ sender: Any) {

        if let country = self.selectedCountry {

            self.delegate?.countriesListViewController(self, didFinishWith: country)
        }

        self.hide()
    }

    private func hide() {

        DispatchQueue.main.async {

            self.navigationController?.dismiss(animated: true)
        }
    }
}

// MARK: - UITableViewDataSource
extension CountriesListViewController: UITableViewDataSource {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return self.filteredCountries.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: CountryTableViewCell.tap_className) as? CountryTableViewCell else {

            fatalError("Failed to load \(CountryTableViewCell.tap_className) from storyboard.")
        }

        return cell
    }
}

// MARK: - UITableViewDelegate
extension CountriesListViewController: UITableViewDelegate {

    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {

        guard let countryCell = cell as? CountryTableViewCell else {

            fatalError("Wrong cell type.")
        }

        let country = self.filteredCountries[indexPath.row]

        let code = self.displayedISDNumberOrISOCode(for: country)
        let name = country.localizedName
        let flagImage = country.flagImage

        countryCell.fill(with: code, countryName: name, flagImage: flagImage)
        countryCell.isSelected = self.selectedCountry == country
    }

    public func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {

        let view = UIView()
        view.backgroundColor = .clear

        return view
    }

    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        self.selectedCountry = self.filteredCountries[indexPath.row]
        self.updateDoneButtonState()
    }
}
