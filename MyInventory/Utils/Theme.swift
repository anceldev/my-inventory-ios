//
//  Theme.swift
//  MyInventory
//
//  Created by Ancel Dev account on 9/12/24.
//

import SwiftUI

struct AppTheme {
    let primaryColor: Color
    let backgroundColor: Color
}

struct ThemeKey: EnvironmentKey {
    static let defaultValue = AppTheme(
        primaryColor: .white,
        backgroundColor: .red
    )
}

extension EnvironmentValues {
    var theme: AppTheme {
        get { self[ThemeKey.self] }
        set { self[ThemeKey.self] = newValue }
    }
}
