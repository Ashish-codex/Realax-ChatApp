//
//  ChatViewModel.swift
//  Realax
//
//  Created by Ashish Prajapati on 17/02/24.
//

import Foundation

class ChatViewModel{
    
    
    func chatReciveMessages(reqUrl: ApiRoute, roomID:String, reqHttpMethod: ApiHttpMethod, complition: @escaping (Result<ModelGetAllMessages, DataError>)->Void){
        
        let reqBody = EmptyCodableForGetReq()
        let url = reqUrl.rawValue+"\(roomID)"
        
        _ = ApiService.shared.callAPI(reqURL: url, reqObj: reqBody, reqHttpMethod: reqHttpMethod) { response in
            
            switch response{
            case .success(let data) :
                
                do {
                    let getAllMessages = try JSONDecoder().decode(ModelGetAllMessages.self, from: data)
                    
                    if getAllMessages.success{
                        complition(.success(getAllMessages))
                    }else{
                        complition(.failure(.message(getAllMessages.message)))
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
    
    
    func chatSendMessages(reqUrl: ApiRoute, reqBody: ModelSendMessageREQ, roomID:String, reqHttpMethod: ApiHttpMethod, complition: @escaping (Result<ModelSendMessageRES, DataError>)->Void){
        
        let url = reqUrl.rawValue+"\(roomID)"
        
        _ = ApiService.shared.callAPI(reqURL: url, reqObj: reqBody, reqHttpMethod: reqHttpMethod) { response in
            
            switch response{
            case .success(let data) :
                
                do {
                    let sendMessageRes = try JSONDecoder().decode(ModelSendMessageRES.self, from: data)
                    
                    if sendMessageRes.success{
                        complition(.success(sendMessageRes))
                    }else{
                        complition(.failure(.message(sendMessageRes.message)))
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
