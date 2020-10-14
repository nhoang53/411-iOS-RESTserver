import SQLite3

// Textbook uses JSONSerialization API (in Foundation module)
// JSONEncoding/ JSONDecoding
// Person : Codable -> define Codable interface. we can use encoder/decoder when fetching data
struct Claim : Codable{
    var id : String
    var title : String
    var date : String
    var isSolved : String
    
    init(newID : String, newTitle: String, newDate:String, newIsSolved:String) {
        id = newID
        title = newTitle
        date = newDate
        isSolved = newIsSolved
    }
}

class claimDAO {
    func addClaim(cObj : Claim) {
        let sqlStmt = "insert into claim (id, title, date, isSolved)"
                + " values ('\(cObj.id)', '\(cObj.title)', '\(cObj.date)', '\(cObj.isSolved)')"
        let conn = Database.getInstance().getDBConnection()
        if sqlite3_exec(conn, sqlStmt, nil, nil, nil) != SQLITE_OK {
            let errcode = sqlite3_errcode(conn)
            print("Failed to insert new claim due to error: \(errcode)")
        }
        sqlite3_close(conn)     // close connection
    }
    
    func getAll() -> [Claim] {
        var cList = [Claim]()
        var sqlStr = "select id, title, date, isSolved from claim"
        var resultSet : OpaquePointer?   // result set of variable return back from sqlite3
        let conn = Database.getInstance().getDBConnection()
        if sqlite3_prepare_v2(conn, sqlStr, -1, &resultSet, nil) == SQLITE_OK {
            while(sqlite3_step(resultSet) == SQLITE_ROW){
                // Unsafe_Pointer<cCharacter> sqlite3
                var id_val = sqlite3_column_text(resultSet, 0)
                let id = String(cString: id_val!)    // convert unsafe pointer into String
                
                var title_val = sqlite3_column_text(resultSet, 1)
                let title = String(cString: title_val!)
                
                var date_val = sqlite3_column_text(resultSet, 2)
                let date = String(cString: date_val!)
                
                var isSolved_val = sqlite3_column_text(resultSet, 3)
                let isSolved = String(cString: isSolved_val!)
                
                cList.append(Claim(newID: id, newTitle: title, newDate: date, newIsSolved: isSolved))
            }
        } else {
            let errcode = sqlite3_errcode(conn)
            print("Cannot get data due to: \(errcode)")
        }
        
        sqlite3_close(conn)     // close connection
        return cList
    }
}
