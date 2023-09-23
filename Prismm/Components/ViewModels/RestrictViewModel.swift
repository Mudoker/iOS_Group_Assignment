//
//  BlockViewModel.swift
//  Prismm
//
//  Created by Nguyen The Bao Ngoc on 23/09/2023.
//

import Foundation
import SwiftUI

class RestrictViewModel: ObservableObject{
    
    @Published var userRestricList: [User] = []
    

    @MainActor
    func fetchCurrentUserRestrictList() async {
        do{
            let userRestrictListObj = try await APIService.fetchCurrentUserRestrictedList()
            for userID in userRestrictListObj!.restrictIds{
                let user = try await APIService.fetchUser(withUserID: userID)
                
                self.userRestricList.append(user)
            }
        }catch{
            return
        }

    }


}
