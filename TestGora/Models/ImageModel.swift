//
//  ImageModel.swift
//  TestGora
//
//  Created by Александр Галкин on 31.08.2021.
//

import Foundation

enum ImageModel: ModelDataStates {
    typealias InputType = DataStates<ImageData  >
    
    struct ImageData: Decodable {
        var albumId: Int?
        var id: Int?
        var title: String?
        var url: String?
        var thumbnailUrl: String?
    }
}
