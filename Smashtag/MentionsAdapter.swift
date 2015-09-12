//
//  MentionsAdapter.swift
//  Smashtag
//
//  Created by Jose Luis Lucini Reviriego on 12/9/15.
//  Copyright (c) 2015 JLLucini. All rights reserved.
//

import Foundation

public enum TweetSection {
    case HashTags,URLs, Media, Users
}

public struct MentionsAdapter {
    
    private var sectionsToSequence = [TweetSection]()
    
    private var _tweet: Tweet?
    
    public var tweet: Tweet? {
        get {
            return _tweet
        }
    }
    
    public init(aTweet: Tweet?) {
        _tweet = aTweet
        if tweet?.media.count > 0 {
            sectionsToSequence.append(TweetSection.Media)
        }
        
        if tweet?.hashtags.count > 0 {
            sectionsToSequence.append(TweetSection.HashTags)
        }
        
        if tweet?.urls.count > 0 {
            sectionsToSequence.append(TweetSection.URLs)
        }
        
        if tweet?.user != nil {
            sectionsToSequence.append(TweetSection.Users)
        }
    }
    
    
    public var numSections: Int{
        return sectionsToSequence.count;
    }
    
    public func sectionAt(indexPath: NSIndexPath) -> TweetSection{
        return sectionsToSequence[indexPath.section]
    }
    
    public func rowsAt(section: Int) -> Int {
        var result = 0
        if section >= 0 {
            let tweetSection = sectionsToSequence[section]
            switch tweetSection {
            case .Media: result = tweet!.media.count
            case .HashTags: result = tweet!.hashtags.count
            case .URLs: result = tweet!.urls.count
            case .Users:
                if let t = tweet?.user {
                    result = 1
                }
            }
        }
        return result
    }
    
    public func labelAt(indexPath: NSIndexPath) -> String? {
        var result: String?
        
        if indexPath.section >= 0 && indexPath.row >= 0 {
            let tweetSection = sectionsToSequence[indexPath.section]
            switch tweetSection {
            case .Media:    result  = "\(tweet!.media[indexPath.row].url.absoluteString)"
            case .HashTags: result  = "\(tweet!.hashtags[indexPath.row].keyword)"
            case .URLs:     result  = "\(tweet!.urls[indexPath.row].keyword)"
            case .Users:    result  = "\(tweet!.user.screenName)"
            default: result = nil
            }
        }
        return result
    }
    
    public func headerAt(section: Int) -> String? {
        var result: String?
        let tweetSection = sectionsToSequence[section]
        switch tweetSection{
        case .Media: result = "Images"
        case .HashTags: result = "Hashtags"
        case .URLs: result = "URLs"
        case .Users: result = "Users"
        default: result = nil
        }
        return result
    }
    
}
