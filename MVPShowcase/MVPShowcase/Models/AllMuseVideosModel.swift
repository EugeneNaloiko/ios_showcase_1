//
//  AllMuseVideosModel.swift
//
//  Created by Eugene Naloiko
//

/*https://cdn.muse.ai/w/a87b053188f7bb24346baa36f2a274a0fca4dcb79ad2e0a82644008961129a1b/videos/video-240p.mp4
You can get these files by accessing:
https://cdn.muse.ai/w/<fid>/videos/video-XXXp.mp4
XXXp -> 240p, 360p, 720p, 1080p, 2160p
*/

import Foundation

struct AllMuseVideosModel: Decodable {
    var description: String?
    var duration: Double?
    var durationInHoursMinutesSeconds: (hours: Int, minutes: Int, seconds: Int) {
        let duration = Int(self.duration ?? 0)
          return (duration / 3600, (duration % 3600) / 60, (duration % 3600) % 60)
    }
    var durationInHoursMinutesSecondsString: String {
        let duration = durationInHoursMinutesSeconds
        
        var hoursText = ""
        var minutesText = ""
        var secondsText = ""
        
        if duration.hours > 0 {
            hoursText = "\(duration.hours) h "
        }
        
        if duration.minutes > 0 {
            minutesText = "\(duration.minutes) min "
        }
        
        if duration.seconds > 0 {
            secondsText = "\(duration.seconds) sec"
        }
        
        let text = "\(hoursText)\(minutesText)\(secondsText)"
        
        return text
    }
    var fid: String?
    var filename: String?
    var height: Int?
    var ingestVideo: Int?
    var ingesting: Bool?
    var mature: Bool?
    var size: Int
    var svid: String?
    var tcreated: TimeInterval?
    var title: String?
    var twatched: TimeInterval?
    var url: String?
    var views: Int?
    var visibility: String?
    var width: Int
    
    enum CodingKeys: String, CodingKey {
        case description
        case duration
        case fid
        case filename
        case height
        case ingestVideo = "ingest_video"
        case ingesting
        case mature
        case size
        case svid
        case tcreated
        case title
        case twatched
        case url
        case views
        case visibility
        case width
    }
    
    func getVideoUrl(videoQuality: VideoQuality) -> String? {
        let baseUrl = "https://cdn.muse.ai/w/"
        guard let fid = self.fid else { return nil }
        let fullUrl = "\(baseUrl)\(fid)/videos/video-\(videoQuality.rawValue).mp4"
        return fullUrl
    }
}
