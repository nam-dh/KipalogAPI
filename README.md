# kipalog-api-swift
Swift wrapper for Kipalog API (http://kipalog.com)

Original documentation see at: [https://github.com/Kipalog/Kipalog-API-Doc](https://github.com/Kipalog/Kipalog-API-Doc)

[![Build Status](https://travis-ci.com/nam-dh/kipalog-api-swift.svg?branch=master)](https://travis-ci.com/nam-dh/kipalog-api-swift)  
### Usage
#### IMPORTANT: Configure your API access token
```
KipalogAPI.shared.accessToken = 'token-obtained-from-kipalog'
```

#### Get post list (hot, newest, by tag)
```
KipalogAPI.shared.getPostList(type: .hot) { (result) in
}
```

There are 3 list types:
```
public enum PostListType {
  case hot
  case newest
  case tag(String)
}
```

#### Publish a new post
```
let newPost = KLLocalPost(title: "Hello World", action: .publish, content: "markdown text", tags: ["TIL","Markdown"])
KipalogAPI.shared.post(newPost) { (error) in
}
```

#### Draft a new post
```
let newPost = KLLocalPost(title: "Hello World", action: .draft, content: "markdown text", tags: ["TIL","Markdown"])
KipalogAPI.shared.post(newPost) { (error) in
}
```

#### Preview a post
```
let newPost = KLLocalPost(title: "Hello World", content: "plain", tags: ["TIL","Markdown"])
KipalogAPI.shared.preview(newPost) { (post) in
}
```
