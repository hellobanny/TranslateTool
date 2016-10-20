#Translate Kit
iOS App开发者的辅助翻译工具，可以将一个strings文件使用Google翻译翻译成多种语言。比如将英语翻译成德语，法语，意大利语等。

##注意点：
1. 使用Google翻译的效果并不如人工翻译，有钱的还是用人工翻译的吧！适合个人开发者。
2. 对翻译中的%@，%d等输出符号，翻译后仍需要额外调整。
3. 尽量避免Swift中 "hello \\(var)"的使用。

##使用方法1
1. 下载代码
2. 使用自己的Google API Key 替换 TranslateManager.swift 中的 GoogleAPIKey。申请地址：[Google](https://cloud.google.com/translate/)。
3. 运行 pod update
4. 编译，运行。
5. 将要翻译的文件发送到手机邮箱上。
6. 把邮箱附件中的Strings文件用这个App打开即可。
7. 选择要翻译的语言翻译即可。
8. 翻译好后App会将翻译好的文件打包发给你。


##使用方法2
> 直接从App Store中下载 [下载](https://itunes.apple.com/app/id1167289129)

###为什么这是个iOS应用？

>如果你手里有一把锤子，所有东西看上去都像钉子。

联系邮箱：<hellobanny@gmail.com>

****
**Translate app .strings file from one language to many other language by Google Translate API.**

##How to use

1. Clone or download TranslateTool.
2. Replace **GoogleAPIKey** at TranslateManager.swift with your own Google Translate API key.
Get your API key from [Google](https://cloud.google.com/translate/). The price of translate API is $20 per 1 million characters of text.
3. Run pod update.
4. Build and run.
5. Send the file need translate as attachment to mobile email.
6. Open the attachment by this app and translate it.

> I also provide a app can download from App Store [Downlaod](https://itunes.apple.com/app/id1167289129)

###Why this is a iOS app, not a mac app?

1. More skilled at developing iOS app.
2. For security reason.

Mail to <hellobanny@gmail.com> for any feedback.