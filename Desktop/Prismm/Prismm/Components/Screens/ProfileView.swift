//
//  ProfileView.swift
//  Prismm
//
//  Created by Nguyen The Bao Ngoc on 08/09/2023.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        GeometryReader { reader in
            VStack(alignment: .center){
                
                HStack{
                    Text(LocalizedStringKey("UserName"))
                        .fontWeight(.bold)
                        .font(.system(size: 20))    //should be responsive
                    Spacer()
                    
                    
                    HStack{
                        Button {
                            
                        } label: {
                            Image(systemName: "plus.app")
                                .foregroundColor(.black)
                                .font(.system(size: 20))    //should be responsive
                        }
                        
                        Button {
                            
                        } label: {
                            Image(systemName: "line.3.horizontal")
                                .foregroundColor(.black)
                                .font(.system(size: 20))    //should be responsive
                        }
                    }
                    

                }
                    
                    
            }
            .frame(minWidth: 0,maxWidth: .infinity)
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}
