Kipalog API
=================
Swift wrapper for Kipalog API (http://kipalog.com)

Original documentation see at: [https://github.com/Kipalog/Kipalog-API-Doc](https://github.com/Kipalog/Kipalog-API-Doc)

[![Build Status](https://travis-ci.com/nam-dh/kipalog-api-swift.svg?branch=master)](https://travis-ci.com/nam-dh/kipalog-api-swift) 

Installation:
=================

##### Swift Package Manager
Adding it to your `Package.swift`:

```swift
import PackageDescription

let package = Package(
    name: "YourProject",
    dependencies: [
        .package(url: "https://github.com/nam-dh/KipalogAPI.git",
                 from: "1.0.1")
    ],
    targets: [
        .target(name: "YourProject",
                dependencies: ["KipalogAPI"],
                path: "Sources")    
)
```

```bash
$ swift build
```

Usage:
=================
#### IMPORTANT: Configure your API access token
```
KipalogAPI.shared.accessToken = 'token-obtained-from-kipalog'
```

#### Get post list (hot posts, latest posts, posts by tag)
```
KipalogAPI.shared.getPostList(type: .hot) { (result) in
}
```

There are 3 list types:
```
public enum PostListType {
  case hot
  case latest
  case tag(String)
}
```

#### Publish a new post
```
let newPost = KLLocalPost(title: "Hello World", action: .publish, content: "markdown text", tags: ["TIL","Markdown"], type: .markdown)
KipalogAPI.shared.post(newPost) { (error) in
}
```

#### Draft a new post
```
let newPost = KLLocalPost(title: "Hello World", action: .draft, content: "markdown text", tags: ["TIL","Markdown"], type: .markdown)
KipalogAPI.shared.post(newPost) { (error) in
}
```

#### Preview a post
```
let newPost = KLLocalPost(title: "Hello World", content: "plain", tags: ["TIL","Markdown"], type: .markdown)
KipalogAPI.shared.preview(newPost) { (post) in
}
```
