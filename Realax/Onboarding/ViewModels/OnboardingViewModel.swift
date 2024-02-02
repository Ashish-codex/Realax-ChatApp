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
        
        _ = ApiService.shared.callAPI(reqURL: reqUrl, reqObj: reqBody, reqHttpMethod: reqHttpMethod) { response in
            
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
        
        _ = ApiService.shared.callAPI(reqURL: reqUrl, reqObj: reqBody, reqHttpMethod: reqHttpMethod) { response in
            
            switch response{
            case .success(var data) :
                
                do {
                    let loginResponse = try JSONDecoder().decode(ModelLoginRES.self, from: data)
                    
                    complition(.success(loginResponse))
                    
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
