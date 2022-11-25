// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct HomeDesignDetails: Codable {
    let status: Bool?
    var lsthouses: Lsthouses?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case lsthouses = "lsthouses"
    }
}

//floorPlanImageURLMobile
//if let imageurl = designDetails.lsthouses?.facadeLargeImageUrls {


// MARK: - Lsthouses
struct Lsthouses: Codable {
    
//    let homePlanAllSizes: [HomePlan]?
  let validFacades : String?
    let homePlan: HomePlan?
    let facadeLargeImageUrls: [String]?//using
//    let displayList: [String]?
//    let galleryImages: [String]?
//    let packagesCount: Int?
//    let minPrice: Int?
//    let maxPrice: Int?
//    let suburbs: [String]?
//    let estates: [String]?
//    let houseNames: [String]?
//    let situFloorplanOptions: [String]?
//    let situGalleryImages: [String]?
//    let selectedOptions: String?
//    let selectedColor: String?
//
//    let houseIDLandBank: Int?//using
//    let nodeGUID: String?
    let stateID: Int?//using
    let houseName: String? //using
    let houseSize: Int? //using
    let facade: String? //using
//    let standardFacades: String?
//    let facadeImage: String?
//    let facadeImageGUID: String?
//    let facadeImageName: String?
//    let brand: String?
//    let lsthousesDescription: String?
//    let storey: Int?
    let carSpace: Int? //using
    let price: Int?//using
//    let study: Bool?
//    let ensuite: Bool?
    let bedRooms: Int? //using
    let minLotWidth: Double? //using
//    let houseLength: Double?
//    let houseWidth: Double?
//    let minLotLength: Double?
    let bathRooms: Int? //using
//    let livingAreasq: Double?
//    let livingAreasqm: Double?
//    let totalSizesq: Double?
//    let totalSizesqm: Double?
//    let alfrescosq: Double?
//    let alfrescosqm: Double?
//    let firstFloorsq: Double?
//    let firstFloorsqm: Double?
//    let garagesq: Double?
//    let garagesqm: Double?
//    let groundFloorsq: Double?
//    let groundFloorsqm: Double?
//    let porchsq: Double?
//    let porchsqm: Double?
//    let isShowOnWeb: Bool?
//    let dateAvailable: String?
//    let collectionURL: String?
    let facadePermanentURL: String? //using
//    let houseDimensionsHouseName: [String]?
//    let facadeMediumImageUrls: [String]?
//    let edgeImages: [String]?
//    let sliderImages: [String]?
//    let displaysList: [String]?
//    let rooms: String?
//    let videoURL: String?
    let visualisation: Bool?//using
//    let isCompare: Bool?
    var isFav: Bool? //using
//    let livingsqm: Double?
//    let mealssqm: Double?
//    let familysqm: Double?
//    let bed1Sqm: Double?
//    let bed2Sqm: Double?
//    let bed3Sqm: Double?
//    let bed4Sqm: Double?
//    let inclusionFileName: String?
//    let validFacades: String?
//    let visualiseFacade: String?
//    let palettes: String?
//    let defaultPalette: String?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case validFacades = "ValidFacades"
//        case homePlanAllSizes = "HomePlan_AllSizes"
        case facadeLargeImageUrls = "FacadeLargeImageUrls"
//        case displayList = "DisplayList"
//        case galleryImages = "GalleryImages"
//        case packagesCount = "PackagesCount"
//        case minPrice = "MinPrice"
//        case maxPrice = "MaxPrice"
//        case suburbs = "Suburbs"
//        case estates = "Estates"
//        case houseNames = "HouseNames"
//        case situFloorplanOptions = "situFloorplanOptions"
//        case situGalleryImages = "SituGalleryImages"
//        case selectedOptions = "SelectedOptions"
//        case selectedColor = "SelectedColor"
//        case houseIDLandBank = "HouseId_LandBank"
//        case nodeGUID = "NodeGuid"
        case stateID = "StateId"
        case houseName = "HouseName"
        case houseSize = "HouseSize"
        case facade = "Facade"
//        case standardFacades = "StandardFacades"
//        case facadeImage = "FacadeImage"
//        case facadeImageGUID = "FacadeImageGuid"
//        case facadeImageName = "FacadeImageName"
//        case brand = "Brand"
//        case lsthousesDescription = "Description"
//        case storey = "Storey"
        case carSpace = "CarSpace"
        case price = "Price"
//        case study = "Study"
//        case ensuite = "Ensuite"
        case bedRooms = "BedRooms"
        case minLotWidth = "MinLotWidth"
//        case houseLength = "HouseLength"
//        case houseWidth = "HouseWidth"
//        case minLotLength = "MinLotLength"
        case bathRooms = "BathRooms"
//        case livingAreasq = "LivingAreasq"
//        case livingAreasqm = "LivingAreasqm"
//        case totalSizesq = "TotalSizesq"
//        case totalSizesqm = "TotalSizesqm"
//        case alfrescosq = "Alfrescosq"
//        case alfrescosqm = "Alfrescosqm"
//        case firstFloorsq = "FirstFloorsq"
//        case firstFloorsqm = "FirstFloorsqm"
//        case garagesq = "Garagesq"
//        case garagesqm = "Garagesqm"
//        case groundFloorsq = "GroundFloorsq"
//        case groundFloorsqm = "GroundFloorsqm"
//        case porchsq = "Porchsq"
//        case porchsqm = "Porchsqm"
//        case isShowOnWeb = "IsShowOnWeb"
//        case dateAvailable = "DateAvailable"
//        case collectionURL = "CollectionUrl"
        case facadePermanentURL = "FacadePermanentUrl"
//        case houseDimensionsHouseName = "HouseDimensions_HouseName"
        case homePlan = "HomePlan"
//        case facadeMediumImageUrls = "FacadeMediumImageUrls"
//        case edgeImages = "EdgeImages"
//        case sliderImages = "SliderImages"
//        case displaysList = "DisplaysList"
//        case rooms = "Rooms"
//        case videoURL = "VideoURL"
        case visualisation = "Visualisation"
//        case isCompare = "IsCompare"
        case isFav = "IsFav"
//        case livingsqm = "Livingsqm"
//        case mealssqm = "Mealssqm"
//        case familysqm = "Familysqm"
//        case bed1Sqm = "Bed1sqm"
//        case bed2Sqm = "Bed2sqm"
//        case bed3Sqm = "Bed3sqm"
//        case bed4Sqm = "Bed4sqm"
//        case inclusionFileName = "InclusionFileName"
//        case validFacades = "ValidFacades"
//        case visualiseFacade = "VisualiseFacade"
//        case palettes = "Palettes"
//        case defaultPalette = "DefaultPalette"
        case id = "Id"
    }
}

// MARK: - HomePlan
struct HomePlan: Codable {
//    let houseID: Int?//using
//    let storey: Int?
//    let houseName: String?
//    let houseSize: Int?
//    let bedRooms: Int?
//    let bathRooms: Int?
//    let carSpaces: Int?
//    let minLotLength: Double?
//    let minLotWidth: Double?
//    let standardFacade: String?
//    let price: Double?
//    let brand: String?
//    let inclusionURL: String?
//    let brochureURL: String?
//    let floorPlanImageURL: String?
    let floorPlanImageURLMobile: String?//using
//    let residencesq: Double?
//    let residencesqm: Double?
//    let groundFloorsq: Double?
//    let groundFloorsqm: Double?
//    let firstFloorsq: Double?
//    let firstFloorsqm: Double?
//    let alfrescosq: Double?
//    let alfrescosqm: Double?
//    let porchsq: Double?
//    let porchsqm: Double?
//    let garagesq: Double?
//    let garagesqm: Double?
//    let totalsizesqm: Double?
//    let totalsizesq: Double?
//    let inclusionFileName: String?
//    let floorPlanOptions: [FloorPlanOption]?
//    let visualisation: Bool?

    enum CodingKeys: String, CodingKey {
//        case houseID = "HouseId"
//        case storey = "Storey"
//        case houseName = "HouseName"
//        case houseSize = "HouseSize"
//        case bedRooms = "BedRooms"
//        case bathRooms = "BathRooms"
//        case carSpaces = "CarSpaces"
//        case minLotLength = "MinLotLength"
//        case minLotWidth = "MinLotWidth"
//        case standardFacade = "StandardFacade"
//        case price = "Price"
//        case brand = "Brand"
//        case inclusionURL = "InclusionURL"
//        case brochureURL = "BrochureURL"
//        case floorPlanImageURL = "FloorPlanImageURL"
        case floorPlanImageURLMobile = "FloorPlanImageURL_Mobile"
//        case residencesq = "Residencesq"
//        case residencesqm = "Residencesqm"
//        case groundFloorsq = "GroundFloorsq"
//        case groundFloorsqm = "GroundFloorsqm"
//        case firstFloorsq = "FirstFloorsq"
//        case firstFloorsqm = "FirstFloorsqm"
//        case alfrescosq = "Alfrescosq"
//        case alfrescosqm = "Alfrescosqm"
//        case porchsq = "Porchsq"
//        case porchsqm = "Porchsqm"
//        case garagesq = "Garagesq"
//        case garagesqm = "Garagesqm"
//        case totalsizesqm = "Totalsizesqm"
//        case totalsizesq = "Totalsizesq"
//        case inclusionFileName = "InclusionFileName"
//        case floorPlanOptions = "FloorPlanOptions"
//        case visualisation = "Visualisation"
    }
}

// MARK: - FloorPlanOption
struct FloorPlanOption: Codable {
    let fpoIDLandbank: Int?
    let floorPlanCode: String?
    let option: String?
    let roomCode: String?
    let group: String?
    let heading: String?
    let floorPlanOptionDescription: String?
    let imageCode: String?
    let unSupported: String?
    let addRooms: String?
    let removeRooms: String?

    enum CodingKeys: String, CodingKey {
        case fpoIDLandbank = "FPOId_Landbank"
        case floorPlanCode = "FloorPlanCode"
        case option = "Option"
        case roomCode = "RoomCode"
        case group = "Group"
        case heading = "Heading"
        case floorPlanOptionDescription = "Description"
        case imageCode = "ImageCode"
        case unSupported = "UnSupported"
        case addRooms = "AddRooms"
        case removeRooms = "RemoveRooms"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public func hash(into hasher: inout Hasher) {
        // No-op
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    var intValue: Int? {
        return nil
    }

    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {

    let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}



//let facadeLargeImageUrls: [String]?//using
//let houseIDLandBank: Int?//using
//let stateID: Int?//using
//let houseName: String? //using
//let houseSize: Int? //using
//let facade: String? //using
//let carSpace: Int? //using
//let price: Int?//using
//let bedRooms: Int? //using
//let minLotWidth: Double? //using
//let bathRooms: Int? //using
//let facadePermanentURL: String? //using
//let visualisation: Bool?//using
//let isFav: Bool? //using
//
//let houseID: Int?//using
//let floorPlanImageURLMobile: String?//using
