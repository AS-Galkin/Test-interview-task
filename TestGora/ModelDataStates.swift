//
//  ModelStates.swift
//  TestGora
//
//  Created by Александр Галкин on 31.08.2021.
//

import Foundation

protocol ModelDataStates {
    associatedtype InputType
}

//
enum DataStates<T>: ModelDataStates {
    typealias InputType = DataStates<T>
    
    case initil(T)
    case loading(T)
    case success(T)
    case failure(T)
}
