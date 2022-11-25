//
//  LoginModel.swift
//  BurbankApp
//
//  Created by naresh banavath on 02/12/21.
//  Copyright © 2021 DMSS. All rights reserved.
//

import Foundation
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let userStruct = try? newJSONDecoder().decode(UserStruct.self, from: jsonData)

import Foundation

// MARK: - UserStruct
struct UserStruct: Decodable {
  let status: Bool?
  let message: String?
  let result: Result?
  
  enum CodingKeys: String, CodingKey {
    case status = "Status"
    case message = "Message"
    case result = "Result"
  }
  // MARK: - Result
  struct Result: Decodable {
    let success: Bool?
    let passCode: String?
    let message: String?
    let isNewUser, passCodeAlreadySent, passCodeExpired, isMultipleEmails: Bool?
    let isMultipleJobs, isCentralLoginUser: Bool?
    let email: String?
    let jobNumber: String
    let myPlacePassword: String?
    let isEmailNotMapped: Bool?
    let centralLoginPassword: String?
    let userDetails: [UserDetail]?
    let invitedUser: Bool?
    
    enum CodingKeys: String, CodingKey {
      case success = "Success"
      case passCode = "PassCode"
      case message = "Message"
      case isNewUser = "IsNewUser"
      case passCodeAlreadySent = "PassCodeAlreadySent"
      case passCodeExpired = "PassCodeExpired"
      case isMultipleEmails = "IsMultipleEmails"
      case isMultipleJobs = "IsMultipleJobs"
      case isCentralLoginUser = "IsCentralLoginUser"
      case email = "Email"
      case jobNumber = "JobNumber"
      case myPlacePassword = "MyPlacePassword"
      case isEmailNotMapped = "IsEmailNotMapped"
      case centralLoginPassword = "CentralLoginPassword"
      case userDetails = "UserDetails"
      case invitedUser = "InvitedUser"
    }
    
    // MARK: - UserDetail
    struct UserDetail: Decodable {
      let id: Int?
      let firstName: String?
      let middleName: String?
      let lastName, fullName: String?
      let image: String?
      let email, mobile: String?
      let password: String?
      let region, userGUID: String?
      let isMyPlaceAccessible: Bool?
      let myPlaceDetails: [MyPlaceDetail]?
      let isActive: Bool?
      let createdOn, updatedOn: String?
      
      enum CodingKeys: String, CodingKey {
        case id = "Id"
        case firstName = "FirstName"
        case middleName = "MiddleName"
        case lastName = "LastName"
        case fullName = "FullName"
        case image = "Image"
        case email = "Email"
        case mobile = "Mobile"
        case password = "Password"
        case region = "Region"
        case userGUID = "UserGuid"
        case isMyPlaceAccessible
        case myPlaceDetails = "MyPlaceDetails"
        case isActive = "IsActive"
        case createdOn = "CreatedOn"
        case updatedOn = "UpdatedOn"
      }
      
      
      // MARK: - MyPlaceDetail
      struct MyPlaceDetail: Decodable {
        let id, userID: Int?
        let jobNo, userName, password: String?
        let jobType: String?
        let region: String?
        let createdOn, updatedOn: String?
        let myPlaceEmails: [MyPlaceEmail]?
        
        enum CodingKeys: String, CodingKey {
          case id = "Id"
          case userID = "UserId"
          case jobNo = "JobNo"
          case userName = "UserName"
          case password = "Password"
          case jobType = "JobType"
          case region = "Region"
          case createdOn = "CreatedOn"
          case updatedOn = "UpdatedOn"
          case myPlaceEmails = "MyPlaceEmails"
        }
        
        // MARK: - MyPlaceEmail
        struct MyPlaceEmail: Decodable {
          let contactID: String?
          let fullName, firstName, lastName, email: String?
          let userName, password: String?
          let isPrimaryUser: Bool?
          
          enum CodingKeys: String, CodingKey {
            case contactID = "ContactId"
            case fullName = "FullName"
            case firstName = "FirstName"
            case lastName = "LastName"
            case email = "Email"
            case userName = "UserName"
            case password = "Password"
            case isPrimaryUser = "IsPrimaryUser"
          }
        }
      }
    }
    
    
  }
}


