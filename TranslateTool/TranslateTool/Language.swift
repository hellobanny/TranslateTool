//
//  Language.swift
//  TranslateTool
//
//  Created by 张忠 on 16/10/17.
//  Copyright © 2016年 Banny. All rights reserved.
//

import Foundation

enum Language : String {
    case en = "en"
    case fr = "fr"
    case de = "de"
    case zh_Hans = "zh-Hans"
    case zh_Hant = "zh-Hant"
    case ja = "ja"
    case es = "es"
    case es_MX = "es-MX"
    case it = "it"
    case nl = "nl"
    case ko = "ko"
    case pt_BR = "pt-BR"
    case pt_PT = "pt-PT"
    case da = "da"
    case fi = "fi"
    case nb = "nb"
    case sv = "sv"
    case ru = "ru"
    case pi = "pi"
    case tr = "tr"
    case ar = "ar"
    case th = "th"
    case cs = "cs"
    case hu = "hu"
    case ca = "ca"
    case hr = "hr"
    case el = "el"
    case he = "he"
    case ro = "ro"
    case sk = "sk"
    case uk = "uk"
    case id = "id"
    case ms = "ms"
    case vi = "vi"

    func getFullName() -> String{
        switch self {
        case .en:
            return "English"
        case .fr:
            return "French"
        case .de:
            return "German"
        case .zh_Hans:
            return "Chinese (Simplified)"
        case .zh_Hant:
            return "Chinese (Traditional)"
        case .ja:
            return "Japanese"
        case .es:
            return "Spanish"
        case .es_MX:
            return "Spanish (Mexico)"
        case .it:
            return "Italian"
        case .nl:
            return "Dutch"
        case .ko:
            return "Korean"
        case .pt_BR:
            return "Portuguese (Brazil)"
        case .pt_PT:
            return "Portuguese (Portugal)"
        case .da:
            return "Danish"
        case .fi:
            return "Finnish"
        case .nb:
            return "Norwegian Bokmal"
        case .sv:
            return "Swedish"
        case .ru:
            return "Russian"
        case .pi:
            return "Polish"
        case .tr:
            return "Turkish"
        case .ar:
            return "Arabic"
        case .th:
            return "Thai"
        case .cs:
            return "Czech"
        case .hu:
            return "Hungarian"
        case .ca:
            return "Catalan"
        case .hr:
            return "Croatian"
        case .el:
            return "Greek"
        case .he:
            return "Hebrew"
        case .ro:
            return "Romanian"
        case .sk:
            return "Slovak"
        case .uk:
            return "Ukrainian"
        case .id:
            return "Indonesian"
        case .ms:
            return "Malay"
        case .vi:
            return "Vietnamese"
        }
    }
    
    static func getAllLanguages() -> [Language] {
        return [.en,.fr,.de,.zh_Hans,.zh_Hant,.ja,.es,.es_MX,.it,.nl,.ko,.pt_BR,.pt_PT,.da,.fi,.nb,.sv,.ru,.pi,.ar,.th,.cs,.hu,.ca,.hr,.el,.he,.ro,.sk,.uk,.id,.ms,.vi]
    }
    
    func getShortName() -> String{
        return self.rawValue
    }
    
    func getGoogleName() -> String{
        //TODO 需要核查
        return self.rawValue
    }
    
    func getFolderName() -> String {
        return self.rawValue + ".lproj"
    }
}
