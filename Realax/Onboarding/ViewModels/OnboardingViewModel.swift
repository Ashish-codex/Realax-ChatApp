//
//  OnboardingViewModel.swift
//  Realax
//
//  Created by Ashish Prajapati on 28/01/24.
//

import Foundation

class OnboardingViewModel{

//    typealias Handler = (Result<[String:Any], Error>)->Void
    
    
    func apiRegisteration(reqUrl: ApiRoute, reqBody: ModelRegistrationREQ, reqHttpMethod: ApiHttpMethod, complition: @escaping (Result<ModelRegistrationRES, DataError>)->Void){
        
        _ = ApiService.shared.callAPI(reqURL: reqUrl.rawValue, reqObj: reqBody, reqHttpMethod: reqHttpMethod) { response in
            
            switch response{
            case .success(let data) :
                
                do {
                    let registrationResponse = try JSONDecoder().decode(ModelRegistrationRES.self, from: data)
                    
                    complition(.success(registrationResponse))
                    
                } catch let error {
                    complition(.failure(.error(error)))
                    return
                }
                
                
                break
            case .failure(let err) :
                complition(.failure(err))
                break
            }
        }
    }
    
    
    
    
    func apiLogin(reqUrl: ApiRoute, reqBody: ModelLoginREQ, reqHttpMethod: ApiHttpMethod, complition: @escaping (Result<ModelLoginRES, DataError>)->Void){
        
        _ = ApiService.shared.callAPI(reqURL: reqUrl.rawValue, reqObj: reqBody, reqHttpMethod: reqHttpMethod) { response in
            
            switch response{
            case .success(var data) :
                
                do {
                    let loginResponse = try JSONDecoder().decode(ModelLoginRES.self, from: data)
                    
                    if loginResponse.success{
                        
                        self.setUserInfo(
                            userData: loginResponse.data.user,
                            accesToken: loginResponse.data.accessToken ?? "",
                            refreshToken: loginResponse.data.refreshToken ?? "")
                        
                        complition(.success(loginResponse))
                    }else{
                        complition(.failure(.message(loginResponse.message)))
                    }
                    
                    
                } catch let error {
                    complition(.failure(.error(error)))
                    return
                }
                
                
                break
            case .failure(let err) :
                complition(.failure(err))
                break
            }
        }
    }
    
}



// MARK: - Private Utility Functions
extension OnboardingViewModel{
    
    private func setUserInfo(userData: LoginUser?, accesToken:String, refreshToken:String){
        UserInfo.accessToken = accesToken
        UserInfo.refreshToken = refreshToken
        UserInfo.avatarURL = userData?.avatar?.url ?? ""
        UserInfo.role = userData?.role ?? ""
        UserInfo.fullName = userData?.fullName ?? ""
        UserInfo.userName = userData?.username ?? ""
        UserInfo.email = userData?.email ?? ""
        UserInfo.isLoggedIn = true
    }
}
