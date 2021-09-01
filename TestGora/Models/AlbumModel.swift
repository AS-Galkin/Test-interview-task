//
//  AlbumModel.swift
//  TestGora
//
//  Created by Александр Галкин on 31.08.2021.
//

import Foundation

enum AlbumModel: ModelDataStates {
    typealias InputType = DataStates<AlbumData>
    
    struct AlbumData: Decodable {
        var userId: Int?
        var id: Int?
        var title: String?
    }
}

