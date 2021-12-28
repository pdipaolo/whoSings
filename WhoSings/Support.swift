//
//  Support.swift
//  WhoSings
//
//  Created by Pierluigi Di paolo on 27/12/21.
//

import Foundation

struct Params: Encodable {
    let apikey: String
}

// Insert api key

let params = Params(apikey: "eeac75835283f44d753ce8024214a0d5")
extension Collection {
    func choose(_ n: Int) -> ArraySlice<Element> { shuffled().prefix(n) }
}
