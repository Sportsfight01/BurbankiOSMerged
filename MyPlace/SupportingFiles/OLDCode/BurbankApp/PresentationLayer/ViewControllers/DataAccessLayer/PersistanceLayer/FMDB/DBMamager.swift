////
////  DBMamager.swift
////  BurbankApp
////
////  Created by imac on 15/12/16.
////  Copyright © 2016 DMSS. All rights reserved.
////
//
//import UIKit
//import FMDB
//
//struct NewHomes {
//
//    var idHouse: Int
//    var HouseName: String!
//    var HouseSize:Int!
//    var Facade : String!
//    var Brand : String!
//    var HouseLandURL : String!
//    var sgDescription : String!
//    var Storey : String!
//    var CarSpace : String!
//    var Price : Decimal!
//    var Study : Bool!
//    var Ensuite : Bool!
//    var BedRooms : Int!
//    var MinLotWidth : Decimal!
//    var HouseLength : Decimal!
//    var MinLotLength : Decimal!
//    var Bathrooms : Int!
//    var LivingArea : Decimal!
//    var TotalSize : Decimal!
//    var bShowOnWeb : String!
//
//    var FacadePathList: String!
//    var FloorPlanPathList: String!
//}
//
//struct MovieInfo {
//    var movieID: Int!
//    var title: String!
//    var category: String!
//    var year: Int!
//    var movieURL: String!
//    var coverURL: String!
//    var watched: Bool!
//    var likes: Int!
//}
//class DBManager : NSObject
//{
//    let field_MovieID = "movieID"
//    let field_MovieTitle = "title"
//    let field_MovieCategory = "category"
//    let field_MovieYear = "year"
//    let field_MovieURL = "movieURL"
//    let field_MovieCoverURL = "coverURL"
//    let field_MovieWatched = "watched"
//    let field_MovieLikes = "likes"
//
//
//    let field_idHouse = "idHouse"
//    let field_HouseName = "HouseName"
//    let field_HouseSize  = "HouseSize"
//    let field_Facade = "Facade"
//    let field_Brand = "Brand"
//    var field_HouseLandURL = "HouseLandURL"
//    let field_sgDescription = "sgDescription"
//    let field_Storey = "Storey"
//    let field_CarSpace = "CarSpace"
//    let field_Price = "Price"
//    let field_Study = "Study"
//    let field_Ensuite = "Ensuite"
//    let field_BedRooms = "BedRooms"
//    let field_MinLotWidth = "MinLotWidth"
//    let field_HouseLength = "HouseLength"
//    let field_MinLotLength = "MinLotLength"
//    let field_Bathrooms = "Bathrooms"
//    let field_LivingArea = "LivingArea"
//    let field_TotalSize = "TotalSize"
//    let field_bShowOnWeb = "bShowOnWeb"
//
//    let field_FacadePathList = "FacadePathList"
//    let field_FloorPlanPathList = "FloorPlanPathList"
//    let field_MaxPrice = "MaxPrice"
//    let field_MinPrice = "MinPrice"
//    let field_MaxBlockWidth = "MaxBlockWidth"
//    let field_MinBlockWidth = "MinBlockWidth"
//
//
//
//
//    static let shared: DBManager = DBManager()
//
//    let databaseFileName = "database.sqlite"
//
//    var pathToDatabase: String!
//
//    var database: FMDatabase!
//
//
//    override init() {
//        super.init()
//
//        let documentsDirectory = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString) as String
//        pathToDatabase = documentsDirectory.appending("/\(databaseFileName)")
//
//        #if DEDEBUG
//        print("pathToDatabase ---> \(pathToDatabase)")
//        #endif
//    }
//
//
//    // MARK: New Homes
//
//
//    func createNewHomesDatabase() -> Bool {
//        var created = false
//        #if DEDEBUG
//        print(pathToDatabase)
//        #endif
//
//        if !FileManager.default.fileExists(atPath: pathToDatabase) {
//            database = FMDatabase(path: pathToDatabase!)
//
//            if database != nil {
//                // Open the database.
//                if database.open() {
//
//                    let dropTableQuery = " drop table NewHomes"
//                    let createMoviesTableQuery = "CREATE TABLE NewHomes (\"idHouse\"  NOT NULL , \"HouseName\"  NOT NULL , \"HouseSize\" INTEGER, \"Facade\" VARCHAR, \"Brand\" VARCHAR, \"HouseLandURL\" VARCHAR, \"sgDescription\" VARCHAR, \"Storey\" VARCHAR, \"CarSpace\" INTEGER, \"Price\" FLOAT, \"Study\" BOOL, \"Ensuite\" BOOL, \"BedRooms\" INTEGER, \"MinLotWidth\" FLOAT, \"HouseLength\" FLOAT, \"MinLotLength\" FLOAT, \"Bathrooms\" INTEGER, \"LivingArea\" FLOAT, \"TotalSize\" FLOAT, \"bShowOnWeb\" BOOL, \"FacadePathList\" VARCHAR, \"FloorPlanPathList\" VARCHAR, \"Selected\" BOOL Default false , \"Favorite\" BOOL default false )"
//
//                    do {
//                        try database.executeUpdate(dropTableQuery, values: nil)
//                        #if DEDEBUG
//                        print ("droped")
//                        #endif
//                    }
//                    catch {
//                        #if DEDEBUG
//                        print("Could not drop table.")
//                        print(error.localizedDescription)
//                        #endif
//                    }
//                    do {
//                        try database.executeUpdate(createMoviesTableQuery, values: nil)
//                        created = true
//                    }
//                    catch {
//                        #if DEDEBUG
//                        print("Could not create table.")
//                        print(error.localizedDescription)
//                        #endif
//                    }
//
//                    database.close()
//                }
//                else {
//                    #if DEDEBUG
//                    print("Could not open the database.")
//                    #endif
//                }
//            }
//        }
//        #if DEDEBUG
//        print("created-\(created)")
//        #endif
//        return created
//    }
//
//    func insertNewHomesData( NewHomesArray : NSArray) {
//
//
//        if openDatabase() {
//            //if let pathToFile = Bundle.main.path(forResource: "data", ofType: "json") {
//            do {
//
//                var query = ""
//                //                    let NewHomesFileContents = try String(contentsOfFile: pathToFile)
//
//                var newHoneJsonObj:NSDictionary
//                for newHome in NewHomesArray
//                {
//
//                    let mydata = try JSONSerialization.data(withJSONObject: newHome, options: .prettyPrinted)
//
//                    //   print(mydata)
//                    newHoneJsonObj = try JSONSerialization.jsonObject(with: mydata, options: .allowFragments) as! NSDictionary
//                    #if DEDEBUG
//                    print(newHoneJsonObj)
//                    #endif
//
//                    let houseId_value  = NSString.init(format: "%d",newHoneJsonObj["HouseId"] as! Int)
//                    let houseName_value = newHoneJsonObj["HouseName"] as! String
//                    let houseSize_value = NSString.init(format: "%d",newHoneJsonObj["HouseSize"] as! Int)
//                    let facade_value = newHoneJsonObj["Facade"] as! String
//                    let brand_value = newHoneJsonObj["Brand"] as! String
//                    var  houseLandURLVar = ""
//                    if let landUrl = newHoneJsonObj["HouseLandURL"]
//                    {
//                        if landUrl is String
//                        {
//                            #if DEDEBUG
//                            print("---------> landURL:\(landUrl)")
//                            #endif
//                            houseLandURLVar = String(format: "%@", landUrl as! String)
//                        }
//                    }
//
//                    let sgDescription_value1 = newHoneJsonObj["HouseDescription"] as! String
//                    let storey_value = newHoneJsonObj["Storey"] as! String
//                    let carSpace_value = newHoneJsonObj["CarSpace"] as! Int
//                    let price_value = NSString.init(format: "%.2f",newHoneJsonObj["Price"] as! Double)
//                    let study_value  = newHoneJsonObj["Study"] as! Bool
//                    let ensuite_value = newHoneJsonObj["Ensuite"] as! Bool
//                    let bedRooms_value = newHoneJsonObj["BedRooms"] as! Int
//                    let minLotWidth_value = newHoneJsonObj["MinLotWidth"] as? Double
//                    let houseLength_value = newHoneJsonObj["HouseLength"] as! Double
//                    let minLotLength_value = newHoneJsonObj["MinLotLength"] as? Double
//                    let bathrooms_value = newHoneJsonObj["Bathrooms"] as! Int
//                    let livingArea_value = newHoneJsonObj["LivingArea"] as! Double
//                    let totalSize_value = newHoneJsonObj["TotalSize"] as! Double
//                    let bShowOnWeb_value = newHoneJsonObj["bShowOnWeb"] as! Bool
//
//                    let sgDescription_value =  sgDescription_value1.replacingOccurrences(of: "'", with: "")
//
//                    let houseLandURL = houseLandURLVar
//
//                    let facadePathList_value = newHoneJsonObj["FacadePathList"] as! [String]
//                    let floorPlanPathList_value = newHoneJsonObj["FloorPlanPathList"] as! String
//
//
//
//
//                    query += "insert into NewHomes (\(field_idHouse),\(field_HouseName), \(field_HouseSize) , \(field_Facade) , \(field_Brand) , \(field_HouseLandURL) ,\(field_sgDescription), \(field_Storey) , \(field_CarSpace) ,\(field_Price) , \(field_Study) , \(field_Ensuite) , \(field_BedRooms) , \(field_MinLotWidth), \(field_HouseLength) , \(field_MinLotLength) , \(field_Bathrooms) , \(field_LivingArea) , \(field_TotalSize) , \(field_bShowOnWeb),\(field_FacadePathList),\(field_FloorPlanPathList) )values ('\(houseId_value)','\(houseName_value)','\(houseSize_value)','\(facade_value)','\(brand_value)','\(houseLandURL)','\(sgDescription_value)','\(storey_value)','\(carSpace_value)','\(price_value)','\(study_value)','\(ensuite_value)','\(bedRooms_value)','\(minLotWidth_value)','\(houseLength_value)','\(minLotLength_value)','\(bathrooms_value)','\(livingArea_value)','\(totalSize_value)','\(bShowOnWeb_value)','\(facadePathList_value)','\(floorPlanPathList_value)');"
//
//
//
//                }
//  	//	var query_x = try NSString(contentsOfFile: "/Users/SATYA/DigitalMinds/Jan/Source/BurbankApp/BurbankApp/Query.txt", encoding: String.Encoding.utf8.rawValue)
//              //  print(query_x)
//             //   if !database.executeStatements(query_x as String!) {
//
//                #if DEDEBUG
//                print(query)
//                #endif
//
//                if !database.executeStatements(query) {
//                    #if DEDEBUG
//                    print("Failed to insert initial data into the database.")
//                    print(database.lastError(), database.lastErrorMessage())
//                    #endif
//                }
//            }
//            catch {
//                #if DEDEBUG
//                print(error.localizedDescription)
//                #endif
//            }
//
//
//            database.close()
//        }
//    }
//    func get_SortByPrice_NewHomes (lowToHigh : Bool) -> [NewHomes]!
//    {
//        var newHomeArray: [NewHomes]!
//
//        if openDatabase() {
//            var inc : NSString = ""
//            if (lowToHigh == true)
//            {
//             inc = "asc"
//            }else
//            {
//                inc = "esc"
//            }
//            let query = "select * from NewHomes order by Price \(inc)"
//            do {
//                #if DEDEBUG
//                print(database)
//                #endif
//
//                let results = try database.executeQuery(query, values: nil)
//
//                while results.next() {
//
//                    //   let aaa = NewHomes(
//                    let newHomeItem = NewHomes(idHouse: Int(results.int(forColumn: field_idHouse)),
//                                               HouseName: results.string(forColumn: field_HouseName),
//                                               HouseSize: Int(results.int(forColumn: field_HouseSize)),
//                                               Facade: results.string(forColumn: field_Facade),
//                                               Brand: results.string(forColumn: field_Brand),
//                                               HouseLandURL: results.string(forColumn: field_HouseLandURL),
//                                               sgDescription: results.string(forColumn: field_sgDescription),
//                                               Storey: results.string(forColumn: field_Storey),
//                                               CarSpace: results.string(forColumn: field_CarSpace),
//                                               Price: Decimal(results.double(forColumn: field_Price)),
//                                               Study: results.bool(forColumn: field_Study),
//                                               Ensuite: results.bool(forColumn: field_Ensuite),
//                                               BedRooms: Int(results.int(forColumn: field_BedRooms)),
//                                               MinLotWidth: Decimal(results.double(forColumn: field_MinLotWidth)),
//                                               HouseLength: Decimal(results.double(forColumn:field_HouseLength)),
//                                               MinLotLength: Decimal(results.double(forColumn: field_MinLotLength)),
//                                               Bathrooms: Int(results.int(forColumn: field_Bathrooms)),
//                                               LivingArea: Decimal(results.double(forColumn:field_LivingArea)),
//                                               TotalSize: Decimal(results.double(forColumn: field_TotalSize)),
//                                               bShowOnWeb: results.string(forColumn: field_bShowOnWeb),
//                                               FacadePathList:results.string(forColumn: field_FacadePathList),
//                                               FloorPlanPathList:results.string(forColumn: field_FloorPlanPathList)
//
//                    )
//
//
//
//                    if newHomeArray == nil {
//                        newHomeArray = [NewHomes]()
//                    }
//
//                    newHomeArray.append(newHomeItem)
//                }
//            }
//            catch {
//                #if DEDEBUG
//                print(error.localizedDescription)
//                #endif
//            }
//
//            database.close()
//        }
//
//        return newHomeArray
//    }
//    func get_All_NewHomes() -> [NewHomes]! {
//        var newHomeArray: [NewHomes]!
//
//        if openDatabase() {
//            let query = "select * from NewHomes order by \(field_HouseName) asc"
//
//            do {
//                //print(database)
//                let results = try database.executeQuery(query, values: nil)
//
//                while results.next() {
//
//              //   let aaa = NewHomes(
//
//                    let newHomeItem = NewHomes(idHouse: Int(results.int(forColumn: field_idHouse)),
//                                               HouseName: results.string(forColumn: field_HouseName),
//                                               HouseSize: Int(results.int(forColumn: field_HouseSize)),
//                                               Facade: results.string(forColumn: field_Facade),
//                                               Brand: results.string(forColumn: field_Brand),
//                                               HouseLandURL: results.string(forColumn: field_HouseLandURL),
//                                               sgDescription: results.string(forColumn: field_sgDescription),
//                                               Storey: results.string(forColumn: field_Storey),
//                                               CarSpace: results.string(forColumn: field_CarSpace),
//                                               Price: Decimal(results.double(forColumn: field_Price)),
//                                               Study: results.bool(forColumn: field_Study),
//                                               Ensuite: results.bool(forColumn: field_Ensuite),
//                                               BedRooms: Int(results.int(forColumn: field_BedRooms)),
//                                               MinLotWidth: Decimal(results.double(forColumn: field_MinLotWidth)),
//                                               HouseLength: Decimal(results.double(forColumn:field_HouseLength)),
//                                               MinLotLength: Decimal(results.double(forColumn: field_MinLotLength)),
//                                               Bathrooms: Int(results.int(forColumn: field_Bathrooms)),
//                                               LivingArea: Decimal(results.double(forColumn:field_LivingArea)),
//                                               TotalSize: Decimal(results.double(forColumn: field_TotalSize)),
//                                               bShowOnWeb: results.string(forColumn: field_bShowOnWeb),
//                                               FacadePathList:results.string(forColumn: field_FacadePathList),
//                                               FloorPlanPathList:results.string(forColumn: field_FloorPlanPathList)
//
//                    )
//
//
//
//                    if newHomeArray == nil {
//                        newHomeArray = [NewHomes]()
//                    }
//
//                    newHomeArray.append(newHomeItem)
//                }
//            }
//            catch {
//                #if DEDEBUG
//                print(error.localizedDescription)
//                #endif
//            }
//
//            database.close()
//        }
//
//        return newHomeArray
//    }
//
//    func loadMovies() -> [MovieInfo]! {
//        var movies: [MovieInfo]!
//
//        if openDatabase() {
//            let query = "select * from movies order by \(field_MovieYear) asc"
//
//            do {
//                #if DEDEBUG
//                print(database)
//                #endif
//                let results = try database.executeQuery(query, values: nil)
//
//                while results.next() {
//                    let movie = MovieInfo(movieID: Int(results.int(forColumn: field_MovieID)),
//                                          title: results.string(forColumn: field_MovieTitle),
//                                          category: results.string(forColumn: field_MovieCategory),
//                                          year: Int(results.int(forColumn: field_MovieYear)),
//                                          movieURL: results.string(forColumn: field_MovieURL),
//                                          coverURL: results.string(forColumn: field_MovieCoverURL),
//                                          watched: results.bool(forColumn: field_MovieWatched),
//                                          likes: Int(results.int(forColumn: field_MovieLikes))
//                    )
//
//                    if movies == nil {
//                        movies = [MovieInfo]()
//                    }
//
//                    movies.append(movie)
//                }
//            }
//            catch {
//                #if DEDEBUG
//                print(error.localizedDescription)
//                #endif
//            }
//
//            database.close()
//        }
//
//        return movies
//    }
//
//    // MARK: Sample DB
//
//    func createDatabase() -> Bool {
//        var created = false
//
//        if !FileManager.default.fileExists(atPath: pathToDatabase) {
//            database = FMDatabase(path: pathToDatabase!)
//
//            if database != nil {
//                // Open the database.
//                if database.open() {
//                    let createMoviesTableQuery = "create table movies (\(field_MovieID) integer primary key autoincrement not null, \(field_MovieTitle) text not null, \(field_MovieCategory) text not null, \(field_MovieYear) integer not null, \(field_MovieURL) text, \(field_MovieCoverURL) text not null, \(field_MovieWatched) bool not null default 0, \(field_MovieLikes) integer not null)"
//
//                    do {
//                        try database.executeUpdate(createMoviesTableQuery, values: nil)
//                        created = true
//                    }
//                    catch {
//                        #if DEDEBUG
//                        print("Could not create table.")
//                        print(error.localizedDescription)
//                        #endif
//                    }
//
//                    database.close()
//                }
//                else {
//                    #if DEDEBUG
//                    print("Could not open the database.")
//                    #endif
//                }
//            }
//        }
//
//        return created
//    }
//
//
//    func openDatabase() -> Bool {
//        if database == nil {
//            if FileManager.default.fileExists(atPath: pathToDatabase) {
//                database = FMDatabase(path: pathToDatabase)
//            }
//        }
//
//        if database != nil {
//            if database.open() {
//                return true
//            }
//        }
//
//        return false
//    }
//
//
//    func insertMovieData() {
//        if openDatabase() {
//            if let pathToMoviesFile = Bundle.main.path(forResource: "movies", ofType: "tsv") {
//                do {
//                    let moviesFileContents = try String(contentsOfFile: pathToMoviesFile)
//
//                    let moviesData = moviesFileContents.components(separatedBy: "\r\n")
//
//                    var query = ""
//                    for movie in moviesData {
//                        let movieParts = movie.components(separatedBy: "\t")
//
//                        if movieParts.count == 5 {
//                            let movieTitle = movieParts[0]
//                            let movieCategory = movieParts[1]
//                            let movieYear = movieParts[2]
//                            let movieURL = movieParts[3]
//                            let movieCoverURL = movieParts[4]
//
//                            query += "insert into movies (\(field_MovieID), \(field_MovieTitle), \(field_MovieCategory), \(field_MovieYear), \(field_MovieURL), \(field_MovieCoverURL), \(field_MovieWatched), \(field_MovieLikes)) values (null, '\(movieTitle)', '\(movieCategory)', \(movieYear), '\(movieURL)', '\(movieCoverURL)', 0, 0);"
//                        }
//                    }
//
//                    if !database.executeStatements(query) {
//                        #if DEDEBUG
//                        print("Failed to insert initial data into the database.")
//                        print(database.lastError(), database.lastErrorMessage())
//                        #endif
//                    }
//                }
//                catch {
//                    #if DEDEBUG
//                    print(error.localizedDescription)
//                    #endif
//                }
//            }
//
//            database.close()
//        }
//    }
//
//
//
//
//    func loadMovie(withID ID: Int, completionHandler: (_ movieInfo: MovieInfo?) -> Void) {
//        var movieInfo: MovieInfo!
//
//        if openDatabase() {
//            let query = "select * from movies where \(field_MovieID)=?"
//
//            do {
//                let results = try database.executeQuery(query, values: [ID])
//
//                if results.next() {
//                    movieInfo = MovieInfo(movieID: Int(results.int(forColumn: field_MovieID)),
//                                          title: results.string(forColumn: field_MovieTitle),
//                                          category: results.string(forColumn: field_MovieCategory),
//                                          year: Int(results.int(forColumn: field_MovieYear)),
//                                          movieURL: results.string(forColumn: field_MovieURL),
//                                          coverURL: results.string(forColumn: field_MovieCoverURL),
//                                          watched: results.bool(forColumn: field_MovieWatched),
//                                          likes: Int(results.int(forColumn: field_MovieLikes))
//                    )
//
//                }
//                else {
//                    #if DEDEBUG
//                    print(database.lastError())
//                    #endif
//                }
//            }
//            catch {
//                #if DEDEBUG
//                print(error.localizedDescription)
//                #endif
//            }
//
//            database.close()
//        }
//
//        completionHandler(movieInfo)
//    }
//
//
//    func updateMovie(withID ID: Int, watched: Bool, likes: Int) {
//        if openDatabase() {
//            let query = "update movies set \(field_MovieWatched)=?, \(field_MovieLikes)=? where \(field_MovieID)=?"
//
//            do {
//                try database.executeUpdate(query, values: [watched, likes, ID])
//            }
//            catch {
//                #if DEDEBUG
//                print(error.localizedDescription)
//                #endif
//            }
//
//            database.close()
//        }
//    }
//
//
//    func deleteNewHomes(withID ID: Int) -> Bool {
//        var deleted = false
//
//        if openDatabase() {
//            let query = "delete from NewHomes" // where \(field_MovieID)=?"
//
//            do {
//                try database.executeUpdate(query, values: [ID])
//                deleted = true
//            }
//        catch {
//        #if DEDEBUG
//        print(error.localizedDescription)
//        #endif
//        }
//
//            database.close()
//        }
//
//        return deleted
//    }
//}
