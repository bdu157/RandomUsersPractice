//
//  Cache.swift
//  Random Users
//
//  Created by Dongwoo Pae on 8/4/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation

class Cache<Key: Hashable, Value> {
    
    private var cachedDatas: [Key: Value] = [:]
    
    func cache(value: Value, for key: Key) {
        //thread safe - avoid race condition and deadlock
        queue.async {
            self.cachedDatas[key] = value
        }
    }
    
    func value(for key: Key) -> Value? {
        return queue.sync {
            self.cachedDatas[key]
        }
    }
    
    private let queue = DispatchQueue(label: "cache serial queue - no race condition / deadlock")
}
