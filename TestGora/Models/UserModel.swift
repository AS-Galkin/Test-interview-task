//
//  UserModel.swift
//  TestGora
//
//  Created by Александр Галкин on 31.08.2021.
//

import Foundation

enum UserModel: ModelDataStates {
    typealias InputType = DataStates<UserData>
    
    internal struct UserData: Decodable {
        var id: Int?
        var name: String?
        var username: String?
        var email: String?
        var address: Address?
        var phone: String?
        var website: String?
        var company: Company?

        internal struct Address: Decodable {
            var street: String?
            var suite: String?
            var city: String?
            var zipcode: String?
            var geo: [String: String]?
        }
        
        internal struct Company: Decodable {
            var name: String?
            var catchPhrase: String?
            var bs: String?
        }
    }
}
