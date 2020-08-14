//
//  Home.swift
//  Notepad
//
//  Created by snow on 2020/6/18.
//  Copyright © 2020 snow. All rights reserved.
//

import Foundation
enum UserDefaultKey: String {
    case login = "LoginDefaultKey"
}

class Home: ObservableObject {
    
    @Published var loginFlag: Bool = false  //是否需要登录    false需要    true 不需要
    
    static let home = Home()
    
    func getLoginFlag() -> Bool{
        let b = UserDefaults.standard.bool(forKey: UserDefaultKey.login.rawValue)
       
        return b
    }
    
    func setLoginFlag(flag: Bool){
        UserDefaults.standard.set(flag, forKey: UserDefaultKey.login.rawValue)
        if(UserDefaults.standard.synchronize()){
            self.loginFlag = flag
        } else {
            self.loginFlag = !flag
        }
        
    }
}
