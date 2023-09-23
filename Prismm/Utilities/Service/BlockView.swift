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
    
    @StateObject var blockVM = BlockViewModel()
    
    var body: some View {
        VStack{
            HStack {
                Button {
                    settingVM.isBlockListSheetPresentedOniPhone = false
                } label: {
                    Text("Back")
                        .foregroundColor(.black)
                }
               
                Text("Blocked Accounts")
                    .bold()
                    .font(.body)
                    .padding(.horizontal)
                    .offset(x: 55)
                Spacer()
            }
            .frame(height: 60)
            .padding(.horizontal, 10)

            
            ScrollView{
                ForEach(blockVM.userBlockList) { user in
                    VStack{
                        BlockListRow(user: user, blockVM: blockVM)
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 5)
                }
            }
            
            Spacer()

        }
        .onAppear{
            Task {
                await blockVM.fetchCurrentUserBlockList() 
                print("View")
                print(blockVM.userBlockList)
            }
        }
        .refreshable {
            blockVM.userBlockList.removeAll()
            await blockVM.fetchCurrentUserBlockList()
            print("View")
            print(blockVM.userBlockList)
        
        }
    }
}

struct BlockView_Previews: PreviewProvider {
    static var previews: some View {
        BlockView(profileVM: ProfileViewModel(), settingVM: SettingViewModel())
    }
}
