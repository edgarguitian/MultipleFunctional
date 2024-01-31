//
//  LoginModifier.swift
//  MultipleFunctional
//
//  Created by Edgar Guitian Rey on 18/1/24.
//

import SwiftUI

struct LoginModifier: ViewModifier {

    var borderColor: Color = Color.gray

    func body(content: Content) -> some View {
        content
            .disableAutocorrection(true)
            .autocapitalization(.none)
    }
}
