//
//  Network.swift
//  Realax
//
//  Created by Ashish Prajapati on 18/01/24.
//

import Foundation


enum DataError:Error {
    case error(_ error: Error)
    case message(_ msg: String)
}


struct EmptyCodableForGetReq:Codable{}


typealias Handler = (Result<Data, DataError>) -> Void



class ApiService{
    
    public static let shared = ApiService()
//    private var baseUrl = "https://chatsapp-nw05.onrender.com/"
    private var baseUrl = "http://ec2-52-206-76-43.compute-1.amazonaws.com:8000/"
    
    private init(){}
    

    func callAPI<T:Codable>(reqURL:String, reqHeaders:[String: String] = [:], reqObj:T, reqHttpMethod: ApiHttpMethod, completion: @escaping Handler) -> URLSessionDataTask?{
        
        
        var reqData: Data?
        
        guard let url = URL(string: baseUrl + reqURL) else{
            AppHelper.printf(statement:"Unable to process URL : \(reqURL)")
            completion(.failure(.message("Unable to process URL : \(reqURL)")))
            return nil
        }
        
        var headers = reqHeaders
        if (reqURL != ApiRoute.login.rawValue && reqURL != ApiRoute.register.rawValue){
            headers["Authorization"] = UserInfo.accessToken
        }
        
        do {
            if (reqHttpMethod != ApiHttpMethod.GET){
                reqData = try JSONEncoder().encode(reqObj)
            }
//            reqData = try JSONSerialization.data(withJSONObject: reqObj, options: [])
            
        } catch let err {
            AppHelper.printf(statement:"\nError : \(err.localizedDescription)")
            completion(.failure(.error(err)))
            return nil
        }
        
        
        var request = URLRequest(url: url)
        var multipart = MultipartRequest()
        request.httpMethod = reqHttpMethod.rawValue
        
        if (reqURL.contains(ApiRoute.sendMessage.rawValue)){
            
            if let sendMessageReq = reqObj as? ModelSendMessageREQ{
                
                if sendMessageReq.content != nil{
                    multipart.add(key: "content", value: sendMessageReq.content ?? "")
                }
                
                if sendMessageReq.attachments != nil{
                    multipart.add(key: "attachments", fileData: sendMessageReq.attachments ?? Data())
                }
                
                request.setValue(multipart.httpContentTypeHeadeValue, forHTTPHeaderField: "Content-Type")
                reqData = multipart.httpBody
            }

        }else{
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            
        }
        
        request.allHTTPHeaderFields = headers
        request.cachePolicy = .reloadIgnoringCacheData
        request.httpBody = reqData
        
        AppHelper.printf(statement: "---------Api Request Start--------")
        AppHelper.printf(statement: "Point URL :: ---> \(url.description)")
        AppHelper.printf(statement: "Request Headers :: ---> \(request.allHTTPHeaderFields?.toJson() ?? "{ }" )")
        AppHelper.printf(statement: "Request Body :: ---> \(reqData?.toJson() ?? "{}")")
        AppHelper.printf(statement: "---------Api Request End--------")
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard error == nil else{
                AppHelper.printf(statement:"\nApi Service Error : \(error!.localizedDescription)")
                completion(.failure(.error(error!)))
                return
            }
            
            guard let res = response as? HTTPURLResponse else{
                AppHelper.printf(statement:"\n Api Service Error : unable to cast HTTPURLResponse")
                completion(.failure(.message("\nError : unable to cast response into HTTPURLResponse")))
                return
            }
            
        
            guard let resHeaders = res.allHeaderFields as? [String:String] else{
                AppHelper.printf(statement:"\nApi Service Error : unable to cast allHeaderFields into [String:String]")
                completion(.failure(.message("\nError : unable to cast allHeaderFields into [String:String]")))
                return
            }
            
            guard let data else {
                AppHelper.printf(statement:"\nApi Service Error : response data not found")
                completion(.failure(.message("Error : response data not found")))
                return
            }
            
            
            AppHelper.printf(statement: "---------Api Response Start--------")
            AppHelper.printf(statement: "Point URL :: ---> \(String(describing: res.url?.description))")
            AppHelper.printf(statement: "Response Headers :: ---> \(resHeaders.toJson())")
            AppHelper.printf(statement: "Response Body :: ---> \(data.toJson())")
            AppHelper.printf(statement: "---------Api Response End--------")
            
            
            switch res.statusCode {
                
            case 200:
                completion(.success(data))
                break
                
            case 500:
                completion(.failure(.message("Api Error: Internal Server Error")))
                break
                
            case 404:
                completion(.failure(.message("Api Error: Not Found")))
                break
                
            default:
                completion(.success(data))
                break
            }

            
        }
        
        task.resume()
        return task
        
    }
    
    
}
