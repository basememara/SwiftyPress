//
//  TagsDataViewDelegate.swift
//  Basem Emara
//
//  Created by Basem Emara on 2018-06-25.
//  Copyright © 2018 Zamzam Inc. All rights reserved.
//

#if os(iOS)
import UIKit
import ZamzamUI

public protocol TermsDataViewDelegate: class {
    func termsDataView(didSelect model: TermsDataViewModel, at indexPath: IndexPath, from dataView: DataViewable)
    func termsDataViewDidReloadData()
}

// Optional conformance
public extension TermsDataViewDelegate {
    func termsDataViewDidReloadData() {}
}
#endif
