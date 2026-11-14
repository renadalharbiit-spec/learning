//
//  Theme.swift
//  MyApp
//
//  Created by Renad Sameer Alharbi on 02/06/1448 AH.
//

import SwiftUI

extension View {
    func ringBackground<S: Shape>(_ fill: Color, in shape: S) -> some View {
        self
            .background(fill, in: shape)
            .overlay(shape.stroke(Color.white.opacity(0.15), lineWidth: 1))
    }
}
