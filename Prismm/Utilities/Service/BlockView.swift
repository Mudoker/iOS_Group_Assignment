//
//  BlockView.swift
//  Prismm
//
//  Created by Nguyen The Bao Ngoc on 22/09/2023.
//

import SwiftUI

struct BlockView: View {
    
    @ObservedObject var profileVM: ProfileViewModel
    @ObservedObject var settingVM: SettingViewModel
    
    var body: some View {
        VStack{
            Button {
                settingVM.isBlockListSheetPresentedOniPhone = false
            } label: {
                Text("Back")
                    .foregroundColor(.black)
            }

            List {
                ForEach(profileVM.blockList.indices) { index in
                    Text("\(index)")
                }
            }
        }
        .onAppear{
            Task{
                try await profileVM.fetchUserBlockList()
                print("\(profileVM.blockList.count)")
            }
        }
    }
}

struct BlockView_Previews: PreviewProvider {
    static var previews: some View {
        BlockView(profileVM: ProfileViewModel(), settingVM: SettingViewModel())
    }
}
