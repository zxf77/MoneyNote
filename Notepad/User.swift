//
//  User.swift
//  Notepad
//
//  Created by snow on 2020/6/14.
//  Copyright © 2020 snow. All rights reserved.
//

import Foundation

struct User: Codable{
    let username: String
    let password: String
}
struct Password: Codable{
    let oldPassword: String
    let newPassword: String
}

struct RegistResult: Codable{
    let createdAt: String
    let objectId: String
    let sessionToken: String
}

struct LoginResult: Codable{
    let createdAt: String
    let objectId: String
    let sessionToken: String
    let updatedAt: String
    let username: String
}
struct PasswordResult: Codable {
    let msg: String
}
