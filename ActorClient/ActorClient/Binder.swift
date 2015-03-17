//
//  Binder.swift
//  ActorClient
//
//  Created by Stepan Korshakov on 12.03.15.
//  Copyright (c) 2015 Actor LLC. All rights reserved.
//

import Foundation

class Binder {
    
    var bindings : [BindHolder] = [];
    
    func bind<T>(value:AMValueModel, closure: (value: T?)->()) {
        var listener = BindListener { (value2) -> () in
            closure(value: value2 as? T);
        };
        var holder = BindHolder(valueModel: value, listener: listener);
        bindings.append(holder);
        value.subscribeWithAMValueChangedListener(listener);
    }
    
    func unbindAll() {
        for holder in bindings {
            holder.valueModel.unsubscribeWithAMValueChangedListener(holder.listener);
        }
        bindings.removeAll(keepCapacity: true);
    }
    
}

class BindListener: NSObject, JavaObject, AMValueChangedListener {
    
    var closure: (value: AnyObject?)->();
    
    init(closure: (value: AnyObject?)->()){
        self.closure = closure;
    }
    
    @objc func onChangedWithId(val: AnyObject!, withAMValueModel valueModel: AMValueModel!) {
        closure(value: val);
    }
}

class BindHolder {
    var listener: BindListener;
    var valueModel: AMValueModel;
    
    init(valueModel: AMValueModel, listener: BindListener) {
        self.valueModel = valueModel;
        self.listener = listener;
    }
}