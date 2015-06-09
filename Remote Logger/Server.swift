import Foundation

protocol ServerDelegate {
    
    func serverDidComeMessage(message: String)
}

class Server {
    let port: UInt16
    var httpServer: HttpServer!
    var delegate: ServerDelegate?
    
    init(portServer port: UInt16) {
        self.port = port;
    }
    
    func startListener(delegate: ServerDelegate) {
        httpServer = HttpServer()
        self.delegate = delegate

        var error: NSError?
        httpServer.start(listenPort: port, error: &error)
        
        if error != nil {
            println("Error HttpServer: \(httpServer)")
            return
        }
        
        
        httpServer["/test"] = { request in
            var headersInfo = ""
            for (name, value) in request.headers {
                headersInfo += "\(name) : \(value)<br>"
            }
            var queryParamsInfo = ""
            for (name, value) in request.urlParams {
                queryParamsInfo += "\(name) : \(value)<br>"
            }
            return .OK(.HTML("<h3>Url:</h3> \(request.url)<h3>Method: \(request.method)</h3><h3>Headers:</h3>\(headersInfo)<h3>Query:</h3>\(queryParamsInfo)"))
        }
        
        httpServer["/addDevice"] = { request in
            var deviceId: String?
            for (name, value) in request.urlParams {
                if name == "device" {
                    deviceId = value
                }
            }
            
            if deviceId != nil {
                println("device_id: \(deviceId)")
                return HttpResponse.Accepted
            }
            return HttpResponse.NotFound
        }
        
        httpServer["/msg"] = { request in
            var id: String?
            for (name, value) in request.urlParams {
                if name == "id" {
                    id = value
                    
                    if let msg = request.body {
                        
                        delegate.serverDidComeMessage(msg)
                    }
                }
            }
            
            
            if id != nil {
                println("_id: \(id)")
                return HttpResponse.Accepted
            }
            return HttpResponse.NotFound
        }

    }
}