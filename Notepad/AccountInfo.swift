//
//  AccountInfo.swift
//  Notepad
//
//  Created by snow on 2020/6/9.
//  Copyright © 2020 snow. All rights reserved.
//

import Foundation
class AccountInfo: ObservableObject, Decodable {
    enum CodingKeys: CodingKey {
        case results
    }
    enum resultsKey: CodingKey {
        case objectId, accountUser, accountName, accountMoney, accountDay, accountMonth, accountNote, type
    }
    
    @Published var account = [Account]()
    init() {
        
    }
    
    required init(from decoder: Decoder) throws {
        let topContainer = try decoder.container(keyedBy: CodingKeys.self)
        var container = try topContainer.nestedUnkeyedContainer(forKey: .results)
        var AccountArray = [Account]()
        while !container.isAtEnd {
            let accountContainer = try container.nestedContainer(keyedBy: resultsKey.self)
            let AccountUser = try accountContainer.decode(String.self, forKey: .accountUser)
            let AccountName = try accountContainer.decode(String.self, forKey: .accountName)
            let AccountMoney = try accountContainer.decode(Double.self, forKey: .accountMoney)
            let AccountDay = try accountContainer.decode(Int.self, forKey: .accountDay)
            let AccountMonth = try accountContainer.decode(String.self, forKey: .accountMonth)
            let AccountNote = try accountContainer.decode(String.self, forKey: .accountNote)
            let Type = try accountContainer.decode(String.self, forKey: .type)
            let ObjectId = try accountContainer.decode(String.self, forKey: .objectId)
            AccountArray.append(Account(accountUser: AccountUser, accountName: AccountName, accountMoney: AccountMoney, accountDay: AccountDay, accountMonth: AccountMonth, accountNote: AccountNote, type: Type, objectId: ObjectId))
        }
        account = AccountArray
    }
}
