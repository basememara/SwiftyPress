//
//  TermsDataViewAdapter.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-25.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

#if os(iOS)
import UIKit
import ZamzamCore
import ZamzamUI

open class TermsDataViewAdapter: NSObject {
    private weak var delegate: TermsDataViewDelegate?
    
    private let dataView: DataViewable
    private var groupedViewModels = [Taxonomy: [TermsDataViewModel]]()
    private var groupedSections = [Taxonomy]()
    
    public private(set) var viewModels: [TermsDataViewModel]? {
        didSet {
            guard let viewModels = viewModels else {
                groupedViewModels = [Taxonomy: [TermsDataViewModel]]()
                groupedSections = [Taxonomy]()
                return
            }
            
            groupedViewModels = Dictionary(grouping: viewModels, by: { $0.taxonomy })
            groupedSections = Array(groupedViewModels.keys.sorted { $0.localized < $1.localized })
        }
    }
    
    public init(for dataView: DataViewable, delegate: TermsDataViewDelegate? = nil) {
        self.dataView = dataView
        self.delegate = delegate
        
        super.init()
        
        // Set data view delegates
        if let tableView = dataView as? UITableView {
            tableView.delegate = self
            tableView.dataSource = self
        } else if let collectionView = dataView as? UICollectionView {
            collectionView.delegate = self
            collectionView.dataSource = self
        }
    }
}

extension TermsDataViewAdapter {
    
    open func reloadData(with viewModels: [TermsDataViewModel]) {
        self.viewModels = viewModels
        
        dataView.reloadData()
        delegate?.termsDataViewDidReloadData()
    }
}

// MARK: - UITableView delegates

extension TermsDataViewAdapter: UITableViewDelegate {
    
    open func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true) //Handle cell highlight
        
        delegate?.termsDataView(
            didSelect: element(in: indexPath),
            at: indexPath,
            from: tableView
        )
    }
    
    open func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        groupedSections.count > 1 ? groupedSections[section].localized : nil
    }
}

extension TermsDataViewAdapter: UITableViewDataSource {
    
    open func numberOfSections(in tableView: UITableView) -> Int {
        groupedSections.count
    }
    
    open func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        numberOfElements(in: section)
    }
    
    open func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView[indexPath]
        (cell as? TermsDataViewCell)?.load(element(in: indexPath))
        return cell
    }
}

// MARK: - UICollectionView delegates

extension TermsDataViewAdapter: UICollectionViewDelegate {
    
    open func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true) //Handle cell highlight
        
        delegate?.termsDataView(
            didSelect: element(in: indexPath),
            at: indexPath,
            from: collectionView
        )
    }
}

extension TermsDataViewAdapter: UICollectionViewDataSource {
    
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        groupedSections.count
    }
    
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        numberOfElements(in: section)
    }
    
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView[indexPath]
        (cell as? TermsDataViewCell)?.load(element(in: indexPath))
        return cell
    }
}

// MARK: - Helpers

private extension TermsDataViewAdapter {
    
    func elements(in section: Int) -> [TermsDataViewModel] {
        groupedViewModels[groupedSections[section]] ?? []
    }
    
    func element(in indexPath: IndexPath) -> TermsDataViewModel {
        elements(in: indexPath.section)[indexPath.row]
    }
    
    func numberOfElements(in section: Int) -> Int {
        elements(in: section).count
    }
}
#endif
