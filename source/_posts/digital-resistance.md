---
title: Digital Resistance
date: 2022-10-23 05:18:27 AM
categories: Security
tags:
  - Security
  - Anonymous
---

科技是把双刃剑，在便利人们沟通交流的同时，也给政府部门和一些商业机构提供了监控他人的便利。远一点
的是 2013 年爆出的美国的棱镜计划，近一点的就是我所处的环境了，这点相信大家都深有体会。

因为最近身边一些群被炸了，有群友被永久封号，有群友被关了 14 天的小黑屋，还有的是群主直接没了，
所以我决定开始逐步退网，并探索匿名上网的方式，本文将记录一下自己搜集到的一些文档的总结，如果感兴
趣的话，建议直接去看本文中的原文，毕竟我只是从中摘录一些我自认为比较重要的东西，可能会有疏漏。
引用一下在 crypto 里经常看到的一句话：

**Don't trust, verify yourself**

尽管本文中的很多工具和场景我们无法获取到和使用，但是，我只能说我们尽可能地在互联网中保护好自己，
保护好自己的隐私和数据，这点是我们唯一能做的。

## Checklist

1. Grab ‘n’ go stash
   1. Manual of digital resistance: [Manual of Digital Resistance v1.1.pdf](/files/manual_of_digital_resistance_v1-1.pdf)
   2. A USB stick with Tails, an anonymous operating system
   3. Credentials for an anonymous email account
2. Money in various currencies
   1. Cash
   2. Prepaid credit cards
   3. Phone plan refill cards
   4. Starbucks gift cards
   5. Bitcoin in a paper wallet
3. Main device
   1. 7-inch anonymous tablet
4. Alternate devices
   1. Anonymous smartphone
   2. Emergency flip phone
   3. SIM cards

Other resources:

- https://oig.justice.gov/sites/default/files/reports/21-014.pdf
- [Defend Dissent](/files/Defend-Dissent.pdf)

## 匿名支付

### Why Cash?

使用现金支付不会留下可追溯的记录，但是还是可以通过监控或手机等将账单序列号和你关联起来。为了尽
可能的减少这种关联：

1. 去一些不常去的店里用现金消费
2. 不要带自己的手机
3. 不要使用公共交通或者打车亦或是共享型的交通工具，尽量走路或骑自行车
4. 穿的稍微严实一点，最好是能遮住你的脸，如大号的衣服和裤子，帽子以及太阳眼镜
5. 穿着不要太显眼，不能因为第四条就将自己的穿的和周围格格不入

### Prepaid credit cards

当无法使用现金支付时，可以使用一些小额的礼品卡，记住，尽可能的是小额，最好不要超过 50$，同时
购买礼品卡时使用现金支付。

### Cryptocurrencies

如果现金和礼品卡支付都不支持，可以考虑使用加密货币，接受度最广的是 Bitcoin，而 Bitcoin 的
钱包需要助记词，为了不让人通过字体追踪到你，最好是将助记词打印出来，最好的做法是每次交易时都生成
一个新的钱包地址，然后从硬件钱包转入小额的 BTC，直接将钱包给店家，进行确认。若是有多，可以及时
生成一个新的地址，将多余的 BTC 转到新地址，留作下次使用。

## 匿名设备

7-inch 的平板是因为这样看起来比较像大屏手机，如果需要拍照，则需要个像手机的拍照设备以便更好的
隐藏起来，同时大部分平板都没有 GPS 和 基带（用来和基站建立通信）芯片，这样就无法记录下你的位置，
尽管平板没有手机那么好用。同时**不要在你常去的地方使用这个平板**，最开始设置的时候去一个有公共
免费网络的地方配置（不常去的咖啡店、图书馆、网吧）。

P.S. 最好不要买国内厂商的平板，如果实在买不多国外的，也尽量避开华为以及和华为有合作关系的厂商，
也不要买苹果的 ipad。

### 配置平板

注：以下的只是一个通用的设置，具体设置的位置需要根据不同的设备进行对应的调整，找不到时可是试试
设置中的搜索或者直接使用搜索引擎。

1. 在 `Settings > Privacy > Location` 中将定位关掉
2. 在 `Settings > Security > Lock Screen` 中，将屏幕解锁方式设置为密码，如果设备支持的话，
   精良选择至少 12 位的密码，且要随机。可以提前使用密码生成器如 bitwarden，1password 等软件
   生成随机密码，然后打印出来。同时确保各种生物识别技术如 Face ID（脸部识别）、Touch ID （指
   纹识别）是关闭的。因为这不是你常用的设备，所以这个设备不需要太贵。
3. 在 `Settings > Security > Lock Screen` 中，将 `Lock screen preferences` 设置为
   `Don't show notifications at all（不显示通知）`
4. 在早期的 Android 中，在 `Settings > Lock screen` 和 `security > Other security
settings > Encrypt device` 可以设置将设备加密，在最新的系统中，需要自己利用搜索引擎，
   通常这个设置被放到 `Developer options` 的选项中。**加密很重要，记得多查一些资料。**
5. 将键盘的输入法中的 `predictive typing（联想输入）`给关掉，否则输入法会将你的输入信息上传
   到对应的厂商，这样会记录你的匿名信息，从而留下痕迹。这个设置一般是在 `Settings > Languages
& input` 中可以找到。同时有关输入法的一些 `smart typing（智能输入）`、`predictive
text（预测文本）`之类凡事需要记录你的输入的选项全部关掉。也建议在自己常用的设备上将这些设置
   关掉。
6. 尽可能的将 Google Assistant 也禁用掉，如果是在需要，只开启需要的功能
7. 如果可以的话，将后台执行关掉，同时 `Now Playing（正在播放）` 这些也禁掉。

### 设置密码

将上述配置完成后，接入网络后下载一个密码管理器，毕竟推荐使用随机的密码，你不可能记住所有的密码，
所以推荐使用 bitwarden，但是 Android 下载需要登陆 Google 账号，有两种方法：一种是注册一个
新的 google 账号，这个账号的语言选项最好是选择其他的语言，第二种方法是自己去下载 apk 包，但是
这种方法可能会下到恶意软件。不过 bitwarden 有网页版的，可以不用下载，所以这一步可以略过。具体
的密码管理器的选择在下一节介绍，记住，所推荐的密码管理器都需要你自己去试用一遍，Be an adult,
and make your own choice。

### 密码管理器：

目前比较流行的密码管理器有：

1. BitWarden: [https://bitwarden.com/](https://bitwarden.com/)
2. Keepass: [https://keepass.info/](https://keepass.info/)
3. LastPass: [https://www.lastpass.com/](https://www.lastpass.com/)
4. 1Password: [https://1password.com/](https://1password.com/)

上述四种我只体验过两种，BitWarden 和 1Password。就体验来讲，BitWarden 的体验更优于
1Password，因为 BitWarden 不止开源，而且还有不同的 Plan，支持 Free Plan，对于白嫖党这当然
是不能错过的咯。而 1Password 一不开源，二收费贵的死，果断 pass，不知道为啥国内的网站经常看到
一些吹 1Password 的帖子。

## 匿名上网

为了防止 ISP 监控你的数据，需要使用 VPN 或是 Tor 来保护你的上网数据。

### Tor

如果说到匿名上网，没有人能绕开 Tor。但是使用 Tor 并不是意味着你就能过完全匿名，你就安全了。
Tor 的工作原理是将所以的连接都走 Tor Network，然后随机选择一个出口，但是其他人是知道你是使用
Tor 进行连接的，所以使用 Tor 时不要登陆你常用的账号，那样同样会将你标记出来。

同时，如果没有足够的经费和资深技术的话，不要去搞一些花里胡哨的操作，如 Tor Over Tor（从一个
Tor 连到另一个 Tor 进行中转）、Tor Over VPN（将 Tor 的流量走 VPN）、VPN Over Tor （先连
VPN 然后再去连 Tor）。虽然说是越复杂越难追踪，但是同时也要记住，一旦这些链路中的一条被人攻破，
你就会被人追踪到，遵循 KISS（Keep It Simple and Stupid）准则吧。因为你没有办法保证 VPN 的
安全性，同时链路越多，意味着留下的记录也就会越多，个人是没有那么多的时间和精力以及技术手段去维护
的，只要有一个环节疏忽了，那么这条链路就废掉了。直接使用 Tor 进行连接就好了，因为 Tor Browser
每次建立新的连接都会换一条新的路由。具体详细的分析见：
https://gitlab.torproject.org/legacy/trac/-/wikis/doc/TorPlusVPN

Tor 的具体的使用方法可以在下面的链接中根据自己的设备和操作系统选择对应的教程：
https://ssd.eff.org/en#index

同时有人担心 Tor 可能被 FBI 监管了，根据
https://oig.justice.gov/sites/default/files/reports/21-014.pdf 报告中给出的统计
数据来说，Tor，或者是 Onion Network 暂时还是能够比较好的保持匿名的。

![fbi-tor-ops](/images/fbi-tor-ops.png)

在移动设备端，可以通过 OrBot App 将所设备的流量都通过 Tor 网络，然后用 Tor Browser 浏览网页。

OrBot 的官网链接为：https://orbot.app/

Tor Browser 的官网链接为：https://www.torproject.org/download/

Tor 官网的一些培训资料：https://community.torproject.org/training/resources/

下载前切记尽兴检查验证，就住，Tor 目前是由 Tor project 项目组进行维护，是 Tor 而不是 TOR。
还有一点需要记住的就是 ISP（运营商）是可以通过流量数据看到你在使用 Tor 的，这点也是可以进行
标记的，在一些审查比较严格的国家，这个是会被标记，如果你不想被标记，那么就只能选择 VPN 了。

### VPN

VPN，Virtual Private Network，最开始的是为了让员工能够远程安全的接入公司的网络进行一些操作。
因为其工作机制是在网络层建立一个加密的信道，ISP 是无法监听到该信道的数据，同时通过 VPN 访问网
络时，会被认为是在 VPN 的另一端访问的，这样就无法追踪到你的地址位置了，但是 VPN 服务是有日志的，
通过日志也能追踪到你，一个较好的资源是
https://torrentfreak.com/best-vpn-anonymous-no-logging/，这些 VPN 都不需要登陆，
也就以为着日志记录是无法追踪到你的。

一个较受好评的是 Private Internet Access (PIA)：https://www.privateinternetaccess.com/，
这个可以使用星巴克的礼品卡进行匿名支付。

有一点需要值得注意的是，VPN 和 代理是有本质区别的，VPN 是属于网络模型 OSI 七层模型中的网络层，
而代理是属于应用层，通过 VPN 的数据是经过了加密的，而代理是将访问数据封装了一层数据，ISP 是能够
监控到代理中的数据的。要是用代理的话一种是用 proxify
(https://trac.torproject.org/projects/tor/wiki/doc/TorifyHOWTO)
和 socksify(https://trac.torproject.org/projects/tor/wiki/doc/SupportPrograms)
软件配置透明代理(Transparent Proxy:
https://trac.torproject.org/projects/tor/wiki/doc/TransparentProxy) ，另一种是用
proxy chain。这两种都要一定的技术和 money，自己量力而行。

如果想要挑选一个适合的 VPN，可以参考以下的表格：
https://docs.google.com/spreadsheets/d/1ijfqfLrJWLUVBfJZ_YalVpstWsjw-JGzkvMd6u2jqEk/edit#gid=231869418

P.S. 上面这两个 VPN 的网站地址我在国内通过代理无法正常访问，通过 Tor Browser 可以正常访问，
所以这两个网站确认被墙无疑。

## 伪匿名聊天

即时通讯，是 Cyber 世界中不可缺少的一种应用，也可以说 Cyber 世界大部分人的第二人生，这里所谓
的匿名，加了个伪字，是因为在 Cyber Space 中，要想 Social 就必须要有一个 ID，这样才能进行
区分，这是一个 Cyber ID，匿名的含义是说不能通过这个 ID 而定位到现实中的你，但这个 ID 还是
代表部分你，起码是 Cyber Space 中的你。所以是伪匿名的。正如现在很多人都知道 Satoshi 是
Bitcoin 的发明者、创始人，但是没人知道 Satoshi 现实生活中到底是谁，是哪个国家的人。废话不
多少，开始介绍如何不让自己的聊天被监管到。

### Email

虽然我喜欢追新技术，但是对于一些工具的使用，我还是比较 old school 的，我最喜欢的就是邮箱了，
这个简单，而且也经过了半个世纪的验证。目前按照网上查询的到的资料来说，最安全的是自建邮箱系统，
但是因为经济成本和时间精力原因，我没有去搞，所以就退而求其次，选择了个业内知名的匿名邮箱供应商：
protonmail，protonmail 也有付费版的，但是我暂时没那个需求，适合自己的才是最好的。

一般通讯工具的选择，有以下两个准则：

1. 开源。不是说开源的就是好的，而是说开源就意味着会有更多的人去审查。
2. 多个业内知名机构的审查报告。这点也不用说，毕竟每个人的水平都是有限，所有有一些信誉度高的机构
   对源代码进行审查也是必要的。

注：开源不代表免费，不要将这两者混淆。

Proton Mail 刚好符合这两点需求，Proton Mail 默认是使用 GPG 加密的，不需要自己额外进行加密，
而且我想没有人会愿意将自己的 GPG 私钥上传网上的。所以轻度使用也还好，如果真的退网成功，成为重度
用户的话，那么肯定是需要自己搭建一个邮箱服务器的。如果平时需要注册一些不常用的账号的话，建议使用
一些 share 的邮箱，用完即扔，但要注意不要使用自己的常用密码和泄漏个人隐私。以下是两个我找到的还
可以的 share 的邮箱：https://10minutemail.com/ 和 https://maildrop.cc/。

当然，如果一些日用的邮箱，如 Gmail 和 Outlook 之类的，一些重要的敏感的数据可以使用 GPG 进行
加密，根据自己的设备和 OS 类型选择对应的软件：https://gnupg.org/download/index.html

Proton Mail 的官方地址为：https://proton.me/

GitHub 地址为：https://github.com/ProtonMail

审查报告：
https://proton-me.cdn.prismic.io/proton-me/abe5f14e-b728-4d34-9477-278394b5071d_securitum-protonmail-security-audit.pdf

### Instant Message (IM)

IM, Instant Message, 这个也是目前 Cyber Space 中不可或缺的一种工具了，Email 的交流是异步
的，而 IM 是可以进行同步的。而目前市面上大部分 IM 不管是为了符合监管还是谋利，都会对用户的数据
进行一定程度的收集。所以选工具的时候除了遵循邮箱的那两条，还需要补充两条：支持端对端加密通信和去
除聊天媒体的 metadata(拍摄的地理、设备等信息)。端对端加密通信技术就能够保证 IM 无法收集你的
聊天记录，毕竟没有人会将自己的所有聊天记录都给其他人看。去处聊天媒体的 metadata 是为了防止有人
对你发出的图片、视频进行分析，从而对你进行定位。对匿名支持最友好的是 Wire 和 XMPP 协议，次一点
的是 Singal，在次一点的就是 Telegram 和 What's App 了。我当前的 IM 选择是 XMPP + Tor +
Jabber 外加 Telegram。之后可能会去使用一些 Wire。Singal 和 What's App 我目前的手机号不支
持，外加现在环境问题，好的 VoIP 也比较难搞到。

### XMPP

XMPP，the Extensible Messaging and Presence Protocol。最开始是由 Jabber 实现，后来
Jabber 被 Cisco 收购后又有其他的客户端实现。同样也是根据自己的设备和 OS 选则不同的 客户端
进行下载：https://xmpp.org/software/clients/，个人推荐 Adium，然后配置为 OTR (Off The
Record)。目前被公认为最安全的是 XMPP + OTR + TOR + Jabber 或 Matrix。具体的分析报告见：
https://officercia.mirror.xyz/G4782jMUpA_kkIpwakphbd6djX85cxRGS-pjBipc8Yk。OTR
的配置教程见：https://ssd.eff.org/en/module/how-use-otr-macos

XMPP 可以直接匿名注册，能够注册的服务器列表为：http://xmpp-servers.404.city/。

最受欢迎的是 404.city: https://404.city/，如果 404.city 访问不了，可以考虑 xmpp.jp:
https://www.xmpp.jp/。

### Wire

支持直接使用邮箱注册，在当今需要绑定手机号的 Social Media 中的一股清流，同时也符合端对端加密
通讯、去处聊天媒体上的 metadata。但是要记得，在登陆 Wire 前先连上 VPN 或 Tor Network。

Wire 官网链接为：https://wire.com/en/

### Signal

和 Wire 的功能一直，只不过其注册方式要麻烦一点，需要手机号才能注册。如果要使用 Singal 同时保持
匿名的话，那么需要两个部匿名的手机，一部不插 SIM 卡，用来登陆账号，一部插匿名的 SIM 卡，只用来
接受短信，除了用来收短信和维持这个号码外，其他情况都不使用，a bit of costly。同时不适合我所处
的国家，匿名的 SIM 卡很难搞到。

Signal 官网链接：https://signal.org/en/

### Telegram

加密大佬 Nikolai 和 Pavel Durov 开发，比较符合标准，这个 IM 的端对端加密通讯不是默认的，
需要自己手动发起，同时只开源了 Client 端，Server 端的代码没有开源。其比较流行的原因是因为其支
持 Bot，可以用来推送一些消息。

Telegram 官网链接：[https://telegram.org/](https://telegram.org/)

### WhatsApp

Meta (Facebook) 的产品，虽然也提供 E2E(End to End) 的加密通讯，但是 Meta 的作风大家都懂，
其唯一的优点就是用户基数大，但是这和我无关。

WhatsApp 官网链接：[https://www.whatsapp.com/](https://www.whatsapp.com/)

## Conclusion

总的来说，Tor 还是 VPN 看自己的选择，IM：XMPP > Wire > Signal > Telegram > WhatsApp。
虽然上述很多工具以我目前的环境还获取不到，但是还是那句话，尽可能的保持匿名，保护好自己的隐私。
目前我在使用的工具有：

- XMPP + OTR client: Adium + 404.city
- Email: Proton Mail
- IM: Telegram
- Password Manager: BitWarden
- Browser: Tor Browser

Last but not least, keep your OS and software up to date.

Anyway, the choice is always yours. I can not make up your mind. Just keep
anonymous and stay safe.

P.S. 因为这片文章是写在国内的平台上，为了防止被删，会备份到 Notion 和 Github 上。

Notion Link： https://www.notion.so/oneforalone/Digital-Resistance-9d0c3dc9c5574d2bbac1f061deb194bd

Flowus Link: https://flowus.cn/oneforalone/share/acf46eec-66a7-4085-aa1a-5d3f3c5e1335

Github：https://oneforalone.github.io/security/digital-resistance.html
