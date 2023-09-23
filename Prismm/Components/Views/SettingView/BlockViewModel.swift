//
//  BlockViewModel.swift
//  Prismm
//
//  Created by Nguyen The Bao Ngoc on 23/09/2023.
//

import Foundation
import SwiftUI

class BlockViewModel: ObservableObject{
    
    @Published var userBlockList: [User] = []
    
    
 
    
//    init() {
//        fetchCurrentUserBlockList() { list, error in
//            self.userBlockList = list ?? []
//        }
//    }
//
    @MainActor
    func fetchCurrentUserBlockList() async {
        
        do{
            let userBlockListObj = try await APIService.fetchCurrentUserBlockList()
            for userID in userBlockListObj!.blockedIds{
                let user = try await APIService.fetchUser(withUserID: userID)
                
                self.userBlockList.append(user)
            }
        }catch{
            return
        }

    }


}
