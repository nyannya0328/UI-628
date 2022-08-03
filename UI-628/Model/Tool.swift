//
//  Tool.swift
//  UI-628
//
//  Created by nyannyan0328 on 2022/08/03.
//

import SwiftUI


struct Tool: Identifiable {
    var id = UUID().uuidString
    var icon : String
    var name : String
    var color : Color
    var toolPostion : CGRect = .zero
}
