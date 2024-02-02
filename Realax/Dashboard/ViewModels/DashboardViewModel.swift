//
//  DashboardViewModel.swift
//  Realax
//
//  Created by Ashish Prajapati on 30/01/24.
//

import Foundation

class DashboardViewModel{
    
//    typealias Handler = (Result<[String:Any], Error>)->Void
    
    func apiLogout(reqUrl: ApiRoute, reqBody: ModelLogoutREQ, reqHttpMethod: ApiHttpMethod, complition: @escaping (Result<ModelLogoutRES, DataError>)->Void){
        
        _ = ApiService.shared.callAPI(reqURL: reqUrl, reqObj: reqBody, reqHttpMethod: reqHttpMethod) { response in
            
            switch response{
            case .success(let data) :
                
                do {
                    let logoutResponse = try JSONDecoder().decode(ModelLogoutRES.self, from: data)
                    
                    if logoutResponse.success{
                        complition(.success(logoutResponse))
                    }else{
                        complition(.failure(.message(logoutResponse.message)))
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
