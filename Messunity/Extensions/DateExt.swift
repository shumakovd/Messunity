//
//  DateExt.swift
//  Messunity
//
//  Created by Shumakov Dmytro on 13.11.2022.
//

import Foundation

extension Date {
    func toMillis() -> Int64! {
        return Int64(self.timeIntervalSince1970 * 1000)
    }

    init(millis: Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(millis / 1000))
        self.addTimeInterval(TimeInterval(Double(millis % 1000) / 1000))
    }
    
    func dateNowToString() -> String {
        let formatter = DateFormatter()
            formatter.dateFormat = "dd.MM.yyyy"
        return formatter.string(from: self)
    }
}

