//
//  ResetAction.swift
//  SwiftList
//
//  Created by Zsombor Milán Rajki on 2020. 06. 12..
//  Copyright © 2020. Zsombor Milán Rajki. All rights reserved.
//

import Foundation

final class ResetAction: NSObject {
    private let _action: () -> ()
    
    init(action: @escaping () -> ()) {
        _action = action
        super.init()
    }
    
    @objc func action() {
        _action()
    }
}
