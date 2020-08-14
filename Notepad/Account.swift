//
//  Account.swift
//  Notepad
//
//  Created by snow on 2020/6/9.
//  Copyright © 2020 snow. All rights reserved.
//

import Foundation
struct Account: Codable {
    //该笔账目的用户名
    var accountUser: String = ""
    //该账目的消费原因
    var accountName: String = ""
    //该账目的金额
    var accountMoney: Double = 0.0
    //该账目发生的时间，到天
    var accountDay: Int = 0
    //该账目发生的时间，到月
    var accountMonth: String = ""
    //备注
    var accountNote: String = ""
    //类型
    var type: String = ""
    var objectId: String = ""
    //排序归类用
    var sortIndex: Int = 0
}
struct AccountAdd: Codable {
    //该笔账目的用户名
    var accountUser: String = ""
    //该账目的消费原因
    var accountName: String = ""
    //该账目的金额
    var accountMoney: Double = 0.0
    //该账目发生的时间，到天
    var accountDay: Int = 0
    //该账目发生的时间，到月
    var accountMonth: String = ""
    //备注
    var accountNote: String = ""
    //类型
    var type: String = ""
}
