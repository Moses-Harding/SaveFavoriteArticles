//
//  Singletons.swift
//  SaveFavoriteArticles
//
//  Created by Moses Harding on 2/8/21.
//

import Foundation

class NYTimesAPI {
    
    static let shared = NYTimesAPI()
    
    let appName = "Top Story Table"
    let appID = "191c1ca5-c158-44d2-88df-a25b419552eb"
    let appKey = "IxM45NTLAHPneQn38VxU8lHx5AnrOAzW"
    let appSecret = "JctrVY2gI56BmNPX"
}

class SharedFormatter {
    
    static let formatter = Formatter()
}
