//
//  CocoaExecution.swift
//  ActorClient
//
//  Created by Stepan Korshakov on 22.03.15.
//  Copyright (c) 2015 Actor LLC. All rights reserved.
//

import Foundation

extension UIViewController {
    func execute(command: AMCommand) {
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        command.startWithAMCommandCallback(CocoaCallback(result: { (val:Any?) -> () in
            MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
            }, error: { (val) -> () in
                MBProgressHUD.hideAllHUDsForView(self.view, animated: true)
        }))
    }
}