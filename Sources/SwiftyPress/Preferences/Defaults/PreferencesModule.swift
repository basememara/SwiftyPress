//
//  File.swift
//  
//
//  Created by Basem Emara on 2019-09-11.
//

import Foundation
import ZamzamCore

public struct PreferencesModule: Module {
    
    public func resolve() {
        factory { Constants(store: self.resolve()) as ConstantsType }
        factory { Preferences(store: self.resolve()) as PreferencesType }
    }
}
