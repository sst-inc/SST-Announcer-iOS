//
//  Announcements.swift
//  Announcements
//
//  Created by JiaChen(: on 9/8/20.
//  Copyright © 2020 SST Inc. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: TimelineProvider {
    
    // swiftlint:disable all
    func placeholder(in context: Context) -> AnnouncementEntry {
        AnnouncementEntry(date: Date(),
                          announcements: [Announcement(title: "Never Gonna Give You Up\nNever Gonna Let You Down",
                                                       publishDate: Date(),
                                                       imageIdentifiers: []), Announcement(title: "Never Gonna Run Around Down and Desert You",
                                                                                           publishDate: Date(),
                                                                                           imageIdentifiers: ["megaphone", "building.columns"]), Announcement(title: "Never Gonna Make You Cry\nNever Gonna Say Goodbye",
                                                                                                                                                              publishDate: Date(),
                                                                                                                                                              imageIdentifiers: ["megaphone", "building.columns"]), Announcement(title: "Never Gonna Tell a Lie and Hurt You",
                                                                                                                                                                                                                                 publishDate: Date(),
                                                                                                                                                                                                                                 imageIdentifiers: [ "building.columns"])],
                          family: context.family)
    }
    
    // swiftlint:enable all
    
    func getSnapshot(in context: Context, completion: @escaping (AnnouncementEntry) -> Void) {
        let entry = AnnouncementEntry(date: Date(),
                                      announcements: fetchPosts(),
                                      family: context.family)
        
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<AnnouncementEntry>) -> Void) {
        var entries: [AnnouncementEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = AnnouncementEntry(date: entryDate,
                                          announcements: fetchPosts(),
                                          family: context.family)
            
            entries.append(entry)
        }

        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
    
    func fetchPosts() -> [Announcement] {
        return Announcement.get() ?? []
    }
}

struct AnnouncementEntry: TimelineEntry {
    let date: Date
    let announcements: [Announcement]
    let family: WidgetFamily
}

struct AnnouncementsEntryView: View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family: WidgetFamily
    @Environment(\.locale) var locale: Locale
    
    @ViewBuilder
    var body: some View {
        if entry.announcements.count == 0 {
            NoPosts()
        } else {
            switch entry.family {
            case .systemSmall:
                let firstPost = entry.announcements.first!

                ViewSmall(post: firstPost)
                
            case .systemMedium:
                let posts = Array(entry.announcements.prefix(2))

                ViewMedium(posts: posts)
            case .systemLarge:
                let posts = Array(entry.announcements.prefix(4))
                
                ViewLarge(posts: posts)
            @unknown default:
                NoPosts()
            }
        }
    }
}

struct NoPosts: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            Image(systemName: "xmark.octagon.fill")
                .imageScale(.large)
                .foregroundColor(.red)
            
            Text("ERROR_NO_POST_TITLE")
                .foregroundColor(Color("Blue"))
                .font(Font.system(size: 17,
                                  weight: .bold))
            
            Text("ERROR_NO_POST_DESCRIPTION")
                .foregroundColor(Color(UIColor.label.withAlphaComponent(0.6)))
                .font(Font.system(size: 10,
                                  weight: .medium))
        }
        .padding([.leading, .trailing], 16)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
    }
}

struct ViewLarge: View {
    
    var posts: [Announcement]
    
    @ViewBuilder
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("LATEST_POSTS")
                .foregroundColor(Color(UIColor.label))
                .font(Font.system(size: 18,
                                  weight: .heavy))
            
            ForEach(0...posts.count - 1, id: \.self) { index in
                let post = posts[index]

                Link(destination: URL(string: "sstannouncer://post/\(index)")!) {
                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 7) {
                            Text(post.formattedDate!)
                                .foregroundColor(Color(UIColor.label.withAlphaComponent(0.6)))
                                .font(Font.system(size: 11,
                                                  weight: .bold))
                            
                            if post.imageIdentifiers.count > 0 {
                                Text("•")
                                    .foregroundColor(Color(UIColor.label.withAlphaComponent(0.6)))
                                    .font(Font.system(size: 11,
                                                      weight: .bold))
                                
                                ForEach(post.imageIdentifiers,
                                        id: \.description) { imageID in
                                    Image(systemName: imageID)
                                        .foregroundColor(Color(UIColor.label.withAlphaComponent(0.6)))
                                        .font(Font.system(size: 10,
                                                          weight: .medium))
                                }
                            }
                        }
                        
                        Text(post.title)
                            .foregroundColor(Color("Blue"))
                            .font(Font.system(size: 17,
                                              weight: .bold)).lineLimit(2)
                    }
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .padding(.all, 16)
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .leading)
    }
}

struct ViewMedium: View {
    
    var posts: [Announcement]
    
    @ViewBuilder
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            ForEach(0...posts.count - 1, id: \.self) { index in
                let post = posts[index]
                Link(destination: URL(string: "sstannouncer://post/\(index)")!) {
                    VStack(alignment: .leading, spacing: 3) {
                        HStack(spacing: 7) {
                            Text(post.formattedDate!)
                                .foregroundColor(Color(UIColor.label.withAlphaComponent(0.6)))
                                .font(Font.system(size: 11,
                                                  weight: .bold))
                            
                            if post.imageIdentifiers.count > 0 {
                                Text("•")
                                    .foregroundColor(Color(UIColor.label.withAlphaComponent(0.6)))
                                    .font(Font.system(size: 11,
                                                      weight: .bold))
                                
                                ForEach(post.imageIdentifiers,
                                        id: \.description) { imageID in
                                    Image(systemName: imageID)
                                        .foregroundColor(Color(UIColor.label.withAlphaComponent(0.6)))
                                        .font(Font.system(size: 10,
                                                          weight: .medium))
                                }
                            }
                        }
                        
                        Text(post.title)
                            .foregroundColor(Color("Blue"))
                            .font(Font.system(size: 17,
                                              weight: .bold)).lineLimit(2)
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .padding(.all, 16)
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .leading)
    }
}

struct ViewSmall: View {
    
    var post: Announcement
    
    @ViewBuilder
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            if post.imageIdentifiers.count > 0 {
                HStack(spacing: 7) {
                    ForEach(post.imageIdentifiers,
                            id: \.description) { imageID in
                        Image(systemName: imageID)
                            .foregroundColor(Color(UIColor.label.withAlphaComponent(0.6)))
                            .font(Font.system(size: 10,
                                              weight: .medium))
                    }
                }
            }
            
            Text(post.formattedDate!)
                .foregroundColor(Color(UIColor.label.withAlphaComponent(0.6)))
                .font(Font.system(size: 11,
                                  weight: .bold))
            
            Text(post.title)
                .foregroundColor(Color("Blue"))
                .font(Font.system(size: 17,
                                  weight: .bold))
        }
        .padding(.all, 16)
        .frame(maxWidth: .infinity,
               maxHeight: .infinity,
               alignment: .bottomLeading)
        .widgetURL(URL(string: "sstannouncer://post/0"))
    }
}

@main
struct Announcements: Widget {
    let kind: String = "Announcements"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider(), content: { entry in
            AnnouncementsEntryView(entry: entry)
        })
        .configurationDisplayName(LocalizedStringKey("WIDGET_TITLE"))
        .description(LocalizedStringKey("WIDGET_DESCRIPTION"))
    }
}

// swiftlint:disable all

struct Announcements_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            AnnouncementsEntryView(entry: AnnouncementEntry(date: Date(),
                                                            announcements: [Announcement(title: "Never Gonna Give You Up\nNever Gonna Let You Down",
                                                                                         publishDate: Date(),
                                                                                         imageIdentifiers: ["megaphone", "building.columns"])],
                                                            family: .systemSmall))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            AnnouncementsEntryView(entry: AnnouncementEntry(date: Date(),
                                                            announcements: [Announcement(title: "Never Gonna Give You Up\nNever Gonna Let You Down",
                                                                                         publishDate: Date(),
                                                                                         imageIdentifiers: ["megaphone", "building.columns"]), Announcement(title: "Never Gonna Run Around Down and Desert You",
                                                                                                                                     publishDate: Date(),
                                                                                                                                     imageIdentifiers: [ "building.columns"])],
                                                            family: .systemMedium))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            AnnouncementsEntryView(entry: AnnouncementEntry(date: Date(),
                                                            announcements: [Announcement(title: "Never Gonna Give You Up\nNever Gonna Let You Down",
                                                                                         publishDate: Date(),
                                                                                         imageIdentifiers: []), Announcement(title: "Never Gonna Run Around Down and Desert You",
                                                                                                                                     publishDate: Date(),
                                                                                                                                     imageIdentifiers: ["megaphone", "building.columns"]), Announcement(title: "Never Gonna Make You Cry\nNever Gonna Say Goodbye",
                                                                                                                                                                                 publishDate: Date(),
                                                                                                                                                                                 imageIdentifiers: ["megaphone", "building.columns"]), Announcement(title: "Never Gonna Tell a Lie and Hurt You",
                                                                                                                                                                                                                             publishDate: Date(),
                                                                                                                                                                                                                             imageIdentifiers: [ "building.columns"])],
                                                            family: .systemLarge))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
            
            NoPosts().previewContext(WidgetPreviewContext(family: .systemSmall))
            NoPosts().previewContext(WidgetPreviewContext(family: .systemMedium))
            NoPosts().previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
