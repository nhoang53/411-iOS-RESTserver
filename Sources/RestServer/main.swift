// Joseph Hoang
// Homework 1: Create REST server for claim service

import Kitura
import Cocoa // to use JSON Encode/Decode

let dbObj = Database.getInstance()
let router = Router()

// this code will get data in the body of POST method
router.all("/ClaimService/add", middleware: BodyParser())

router.get("/"){
    request, response, next in
    
    response.send("Hello to my first iOS development project")
    next()
}

router.get("ClaimService/getAll"){
    request, respone, next in
    
    let cList = claimDAO().getAll()
    let jsonData : Data = try JSONEncoder().encode(cList)  // "try" will catch exception
    let jsonStr = String(data: jsonData, encoding: .utf8)   // convert Data into String
//    respone.send("Get all claim services success.\n")
    print("Get all claims success.\n")
    respone.send(jsonStr)
    next()
}

router.post("ClaimService/add") {
    request, response, next in
    
    let body = request.body     // get String of input file of POST method
    let jObj = body?.asJSON     // JSON object
    var addID = UUID().uuidString // generate String UUID
    let addIsSolved = "0"    // 0:false, 1:true
    
    if let jDict = jObj as? [String:String] {
        if let addTitle = jDict["title"],
           let addDate = jDict["date"] {
            let cObj = Claim(newID: addID, newTitle: addTitle, newDate: addDate, newIsSolved: addIsSolved)
            claimDAO().addClaim(cObj: cObj)
            response.send("New claim was successfully inserted via POST method.")
        }
    } else {
        response.send("Something wrong when insert new claim via POST method.")
    }
    next()
}

Kitura.addHTTPServer(onPort: 8020, with: router)
Kitura.run()

