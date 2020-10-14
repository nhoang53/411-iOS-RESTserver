import SQLite3  // allow us to call SQLite3 API

class Database{
    // Member varialble
    static var dbObj : Database!
    let dbname = "/Users/nganhoang/Desktop/iOS development/RestServer/database/ClaimDB.sqlite"
    var conn : OpaquePointer?
    
    // create constructor
    init(){
        if sqlite3_open(dbname, &conn) == SQLITE_OK {
            initializeDB()
            sqlite3_close(conn)
        } else {
            let errcode = sqlite3_errcode(conn)
            print("Open database failed due to error: \(errcode)")
        }
    }
    
    private func initializeDB(){
        let sqlStmt = "create table if not exists"
                + " claim (id text, title text, date text, isSolved boolean)"
        // (conn, statement,?,?,?)
        if sqlite3_exec(conn, sqlStmt, nil, nil, nil) != SQLITE_OK {
            let errcode = sqlite3_errcode(conn)
            print("Create table failed due to error: \(errcode)")
        }
    }
    
    // -> return value is a connection
    func getDBConnection() -> OpaquePointer? {
        var conn : OpaquePointer?
        if sqlite3_open(dbname, &conn) == SQLITE_OK {
            return conn
        } else {
            let errcode = sqlite3_errcode(conn)
            print("Open database failed due to error: \(errcode)")
        }
        return conn
    }
    
    // static method return value is Database
    static func getInstance() -> Database {
        if dbObj == nil{
            dbObj = Database()
        }
        return dbObj
    }
}
