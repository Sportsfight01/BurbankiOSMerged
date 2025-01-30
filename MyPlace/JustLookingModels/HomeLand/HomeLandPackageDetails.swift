// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct HomeLandPackageDetails: Codable {
    
    let status: Bool?
    let packageDetails: PackageDetails?

    enum CodingKeys: String, CodingKey {
        case status = "status"
        case packageDetails = "getpackagebyId"
    }
}

// MARK: - GetpackagebyID
struct PackageDetails: Codable {
    
    let brandColor: String?
    let textColor: String?
    let inclusionURL: String?
    let floorPlanImageURL: String?
    let floorPlanImageURLMobile: String? //using
    let residencesq: Double?
    let residencesqm: Double?
//    let displayList: [String]?
    let inclusionList: [String]?
    let galleryImages: [String]?
    let houseNames: [String]?
    let packageID: Int? //using
    let packageIDLandBank: Int? //using
    let consultantFirstName: String?
    let consultantSurName: String?
    let contactNo: String? //using
    let housePrice: Int? //using
    let retailPriceLessFHOG: Int?
    let inclusionPrice: Int?
    let landPrice: Int?
    let fhog: Double?
    let landSize: Double?
    let landSizeSqm: Double?//using
    let address: String?//using
    let lotNo: String?
    let street: String?
    let suburb: String?
    let state: String?
    let stateAbbrev: String?
    let postCode: String?
    let estateName: String?//using
    let region: String?
    let landTitleDate: String?
    let isDisplay: Bool?
    let inclusions: String?
    let commaDelimitedInclusions: String?
    let promoName: String?
    let emailAddress: String?
    let homeLength: Double?
    let homeWidth: Double?
    let blockType: Double?
    let landDepth: Double?
    let landWidth: Double?
    let getpackagebyIDIsFav: Bool?
    let formattedPrice: String?
    let latitude: String?//using
    let longitude: String?//using
    let houseIDLandBank: Int?
    let nodeGUID: String?
    let stateID: Int?
    let houseName: String?//using
    let houseSize: Int?//using
    let facade: String?//using
    let standardFacades: String?
    let facadeImage: String?
    let facadeImageGUID: String?
    let facadeImageName: String?
    let brand: String?
    let getpackagebyIDDescription: String?
    let storey: Int?
    let carSpace: Int?//using
    let price: Int?//using
    let study: Bool?
    let ensuite: Bool?
    let bedRooms: Int?//using
    let minLotWidth: Double?
    let houseLength: Double?
    let houseWidth: Double?
    let minLotLength: Double?
    let bathRooms: Int?//using
    let livingAreasq: Double?
    let livingAreasqm: Double?
    let totalSizesq: Double?
    let totalSizesqm: Double?
    let alfrescosq: Double?
    let alfrescosqm: Double?
    let firstFloorsq: Double?
    let firstFloorsqm: Double?
    let garagesq: Double?
    let garagesqm: Double?
    let groundFloorsq: Double?
    let groundFloorsqm: Double?
    let porchsq: Double?
    let porchsqm: Double?
    let isShowOnWeb: Bool?
    let dateAvailable: String?
    let collectionURL: String?
    let facadePermanentURL: String?//using
    let houseDimensionsHouseName: [String]?
    let homePlan: String?
    let facadeMediumImageUrls: [String]?
    let facadeLargeImageUrls: [String]?
    let edgeImages: [String]?
    let sliderImages: [String]?
    let displaysList: [String]?
    let rooms: String?
    let videoURL: String?
    let visualisation: Bool?
    let isCompare: Bool?
    let isFav: Bool?//using
    let livingsqm: Double?
    let mealssqm: Double?
    let familysqm: Double?
    let bed1Sqm: Double?
    let bed2Sqm: Double?
    let bed3Sqm: Double?
    let bed4Sqm: Double?
    let inclusionFileName: String?
    let validFacades: [String]?
    let visualiseFacade: [String]?
    let palettes: [String]?
    let defaultPalette: [String]?
    let salesCount: Int?
    let id: Int?

    enum CodingKeys: String, CodingKey {
        case brandColor = "BrandColor"
        case textColor = "TextColor"
        case inclusionURL = "InclusionURL"
        case floorPlanImageURL = "FloorPlanImageURL"
        case floorPlanImageURLMobile = "FloorPlanImageURL_Mobile"
        case residencesq = "Residencesq"
        case residencesqm = "Residencesqm"
//        case displayList = "DisplayList"
        case inclusionList = "InclusionList"
        case galleryImages = "GalleryImages"
        case houseNames = "HouseNames"
        case packageID = "PackageId"
        case packageIDLandBank = "PackageId_LandBank"
        case consultantFirstName = "ConsultantFirstName"
        case consultantSurName = "ConsultantSurName"
        case contactNo = "ContactNo"
        case housePrice = "HousePrice"
        case retailPriceLessFHOG = "RetailPriceLessFHOG"
        case inclusionPrice = "InclusionPrice"
        case landPrice = "LandPrice"
        case fhog = "FHOG"
        case landSize = "LandSize"
        case landSizeSqm = "LandSizeSqm"
        case address = "Address"
        case lotNo = "LotNo"
        case street = "Street"
        case suburb = "Suburb"
        case state = "State"
        case stateAbbrev = "StateAbbrev"
        case postCode = "PostCode"
        case estateName = "EstateName"
        case region = "Region"
        case landTitleDate = "LandTitleDate"
        case isDisplay = "IsDisplay"
        case inclusions = "Inclusions"
        case commaDelimitedInclusions = "CommaDelimitedInclusions"
        case promoName = "PromoName"
        case emailAddress = "EmailAddress"
        case homeLength = "HomeLength"
        case homeWidth = "HomeWidth"
        case blockType = "BlockType"
        case landDepth = "LandDepth"
        case landWidth = "LandWidth"
        case getpackagebyIDIsFav = "isFav"
        case formattedPrice = "FormattedPrice"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case houseIDLandBank = "HouseId_LandBank"
        case nodeGUID = "NodeGuid"
        case stateID = "StateId"
        case houseName = "HouseName"
        case houseSize = "HouseSize"
        case facade = "Facade"
        case standardFacades = "StandardFacades"
        case facadeImage = "FacadeImage"
        case facadeImageGUID = "FacadeImageGuid"
        case facadeImageName = "FacadeImageName"
        case brand = "Brand"
        case getpackagebyIDDescription = "Description"
        case storey = "Storey"
        case carSpace = "CarSpace"
        case price = "Price"
        case study = "Study"
        case ensuite = "Ensuite"
        case bedRooms = "BedRooms"
        case minLotWidth = "MinLotWidth"
        case houseLength = "HouseLength"
        case houseWidth = "HouseWidth"
        case minLotLength = "MinLotLength"
        case bathRooms = "BathRooms"
        case livingAreasq = "LivingAreasq"
        case livingAreasqm = "LivingAreasqm"
        case totalSizesq = "TotalSizesq"
        case totalSizesqm = "TotalSizesqm"
        case alfrescosq = "Alfrescosq"
        case alfrescosqm = "Alfrescosqm"
        case firstFloorsq = "FirstFloorsq"
        case firstFloorsqm = "FirstFloorsqm"
        case garagesq = "Garagesq"
        case garagesqm = "Garagesqm"
        case groundFloorsq = "GroundFloorsq"
        case groundFloorsqm = "GroundFloorsqm"
        case porchsq = "Porchsq"
        case porchsqm = "Porchsqm"
        case isShowOnWeb = "IsShowOnWeb"
        case dateAvailable = "DateAvailable"
        case collectionURL = "CollectionUrl"
        case facadePermanentURL = "FacadePermanentUrl"
        case houseDimensionsHouseName = "HouseDimensions_HouseName"
        case homePlan = "HomePlan"
        case facadeMediumImageUrls = "FacadeMediumImageUrls"
        case facadeLargeImageUrls = "FacadeLargeImageUrls"
        case edgeImages = "EdgeImages"
        case sliderImages = "SliderImages"
        case displaysList = "DisplaysList"
        case rooms = "Rooms"
        case videoURL = "VideoURL"
        case visualisation = "Visualisation"
        case isCompare = "IsCompare"
        case isFav = "IsFav"
        case livingsqm = "Livingsqm"
        case mealssqm = "Mealssqm"
        case familysqm = "Familysqm"
        case bed1Sqm = "Bed1sqm"
        case bed2Sqm = "Bed2sqm"
        case bed3Sqm = "Bed3sqm"
        case bed4Sqm = "Bed4sqm"
        case inclusionFileName = "InclusionFileName"
        case validFacades = "ValidFacades"
        case visualiseFacade = "VisualiseFacade"
        case palettes = "Palettes"
        case defaultPalette = "DefaultPalette"
        case salesCount = "SalesCount"
        case id = "Id"
    }
}

//let floorPlanImageURLMobile: String? //using
//let packageID: Int? //using
//let packageIDLandBank: Int? //using
//let housePrice: Int? //using
//let landSizeSqm: Double?//using
//let address: String?//using
//let estateName: String?//using
//let latitude: String?//using
//let longitude: String?//using
//let houseName: String?//using
//let houseSize: Int?//using
//let facade: String?//using
//let carSpace: Int?//using
//let price: Int?//using
//let bedRooms: Int?//using
//let bathRooms: Int?//using
//let facadePermanentURL: String?//using
//let isFav: Bool?//using
