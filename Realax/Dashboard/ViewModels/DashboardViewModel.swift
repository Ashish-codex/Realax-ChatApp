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
        
        _ = ApiService.shared.callAPI(reqURL: reqUrl.rawValue, reqObj: reqBody, reqHttpMethod: reqHttpMethod) { response in
            
            switch response{
            case .success(let data) :
                
                do {
                    let logoutResponse = try JSONDecoder().decode(ModelLogoutRES.self, from: data)
                    
                    if logoutResponse.success{
                        SocketHelper.shared.disconnectSocket()
                        UserInfo.accessToken = ""
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
    
    
    
    func apiGetAllChated(reqUrl: ApiRoute, reqHttpMethod: ApiHttpMethod, complition: @escaping (Result<ModelGetAllChated, DataError>)->Void){

        let reqBody = EmptyCodableForGetReq()

        _ = ApiService.shared.callAPI(reqURL: reqUrl.rawValue, reqObj: reqBody, reqHttpMethod: reqHttpMethod) { response in

            switch response{
            case .success(let data) :

                do {
                    let getChatedResponse = try JSONDecoder().decode(ModelGetAllChated.self, from: data)

                    if getChatedResponse.success{
                        complition(.success(getChatedResponse))
                    }else{
                        complition(.failure(.message(getChatedResponse.message)))
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

    
    
    
    func apiGetAllNewChats(reqUrl: ApiRoute, reqHttpMethod: ApiHttpMethod, complition: @escaping (Result<ModelGetAllNewChat, DataError>)->Void){

        let reqBody = EmptyCodableForGetReq()

        _ = ApiService.shared.callAPI(reqURL: reqUrl.rawValue, reqObj: reqBody, reqHttpMethod: reqHttpMethod) { response in

            switch response{
            case .success(let data) :

                do {
                    let getNewChatedResponse = try JSONDecoder().decode(ModelGetAllNewChat.self, from: data)

                    if getNewChatedResponse.success{
                        complition(.success(getNewChatedResponse))
                    }else{
                        complition(.failure(.message(getNewChatedResponse.message)))
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

    
    
    func apiCreateOneToOneChat(reqUrl: ApiRoute, reqHttpMethod: ApiHttpMethod, reciverID:String, complition: @escaping (Result<ModelOneToOneChatRES, DataError>)->Void){

        let reqBody = EmptyCodableForGetReq()
        let url = reqUrl.rawValue+"\(reciverID)"

        _ = ApiService.shared.callAPI(reqURL: url, reqObj: reqBody, reqHttpMethod: reqHttpMethod) { response in

            switch response{
            case .success(let data) :

                do {
                    let getOneToOneChatResponse = try JSONDecoder().decode(ModelOneToOneChatRES.self, from: data)

                    if getOneToOneChatResponse.success{
                        complition(.success(getOneToOneChatResponse))
                    }else{
                        complition(.failure(.message(getOneToOneChatResponse.message)))
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

    
    
    
    func apiCreateGroupChat(reqUrl: ApiRoute, reqBody:ModelCreateGroupREQ, reqHttpMethod: ApiHttpMethod, complition: @escaping (Result<ModelCreateGroupRES, DataError>)->Void){

        _ = ApiService.shared.callAPI(reqURL: reqUrl.rawValue, reqObj: reqBody, reqHttpMethod: reqHttpMethod) { response in

            switch response{
            case .success(let data) :

                do {
                    let getGroupChatResponse = try JSONDecoder().decode(ModelCreateGroupRES.self, from: data)

                    if getGroupChatResponse.success{
                        complition(.success(getGroupChatResponse))
                    }else{
                        complition(.failure(.message(getGroupChatResponse.message)))
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
