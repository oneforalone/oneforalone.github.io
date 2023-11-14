---
title: 初探 Kubernetes
date: 2021-03-19
categories: Kubernetes
tags:
  - Docker
  - Kubernetes
---

## 序

近几年来，云计算很火，而在此期间，Docker 和 Kubernetes 应运而生。本文将介绍 Kubernetes 的
一些相关概念。

## Docker

Docker，一个轻量级的虚拟化引擎。经常会用来和 VM （Virtual Machine）进行对比。两者的话各有
优缺点，需要根据自己的需求来进行选择。

如果资源比较充足，同时需要一个完整独立的系统环境，那么 VM 会是个很好的选择。如果只是需要部署
某个服务，那么 Docker 会是个不错的选择。

对于 Docker 来说，最需要记住的一句话就是： `one container for one service`。什么是
container，container 之于 Docker，就相当于 vm 之于 VirtualBox/VMware Workstation/
QEUM。如果你了解面向对象的话，那么他们的关系和 对象与类的关系类似。

如果想要在一个 container 里面集成多个服务，要了解 [`entrypoint`][entrypoint]。对于批量
操作 container，需要用到 [`docker compose`][docker-compose]。还有就是对于多个
container 之间的通信，你需要了解下 [`docker0`][docker0] 这个虚拟网卡。个人感觉这个网卡和
VM 中的虚拟网卡没差，功能上和路由一样，都有 [`NAT`][nat]、[`Bridge`][bridge]、
[`HostOnly`][hostonly]、[`InternalNetwork`][internal-network] 这些模式，说白了虚拟
网卡差不多就是虚拟的路由器，或者说 container 通过 `docker0` 构建了个
[`intranet`][intranet]。

我目前索了解的大致是这些内容，详细的解释和用法自己可以去官网查看。至于你说 Docker 是怎么通过
[`Namespace`][namespace] 来共享系统内核和实现，或者说怎么从零开始构建一个自己的 Docker
image，那就不是初探了，那就是深入剖析了。之后有时间再去查查相关的文档资料吧。反正目前来说使用
[`Dockerfile`][dockerfile] 与 [`DockerHub`][dockerhub] 就可以打造一个自己的 image
了。

## Kubernetes(k8s)

Kubernetes 是一个对容器进行自动化部署、扩展、管理的引擎。又因为中间 ubernete 是 8 个字母，
所有缩写为 k8s。以下都将以 k8s 表示 kubernetes。

那么 k8s 是个怎样的应用场景呢？

有这么一个观点就是——没有一个系统是稳定可靠的。试想一下，如果某个时间点线上部署的容器突然挂
了，你要怎么处理？自己手动再重新部署一遍，那之前的数据呢？一个容器的时还好，但是当容器数量较多
时，处理起来就会相当麻烦，同时也会带来比较大的损失。所以就有了 k8s。

### Cluster

首先，k8s 应用场景是针对大的集群。一个正常的 k8s 集群至少要有 2 台 Master 主机和 3 台 Node
主机。官网中将 Master 主机叫做  Control Plane。

k8s 的工作流程是这样的：

  requests(from client) -> API server -> [Controller Manager] -> scheduler ->
  kubelet -> Pod

下面将从 Node 和 Control Plane 来介绍流程中的组件。

#### 基本概念

在介绍 Node 和 Control Plane 之前，需要先介绍几个 k8s 的基础概念。

- Pods: Pod 是 k8s 中的最小单元，通常来说一个 pod 对应一个容器。每个 pod 都有独立的 IP，
  每次 pod 重建时都会重新分配 IP。当然，一个 pod 多个容器的情况是一种相对高级的场景，只有在
  容器之间关联紧密时才会使用这种模式。
- Service: 由于 pod 的重建会分配新的 IP，这种变动不利于服务之间的通信，同时为了负载均衡，
  所以就有了 Service。每个 Service 也都有个独立的 IP，同时 Service 通过 selector 选择
  label，而 label 与 pod 进行绑定。这样，即便是 pod 的 IP 改变了，但是其绑定的 label 没有
  发生改变，所以其他的 pod 或是外部与 pod 通信时，只需要与 Service 通信就可以了。同时也是
  通过 label 对 pod 进行负载均衡。
- Ingress: 由于 Service 会直接暴露 IP 和端口，为了隐藏 IP 和端口，就有了 Ingress，同时
  也更符合 Web 访问的操作，Ingress 会绑定域名，然后通过 Ingress 控制器来选择 Ingress。
  所以 Ingress 是个管理外部访问集群中服务的 API 对象。
- ConfigMap: 对于某些 pod，通信需要一些数据，比如说数据库的连接。当某个 pod 中的数据改变
  时，需要进行重新配置，而 ConfigMap 就是将这些数据都保存在一个文件中，这让对服务进行变动时
  变得很简单，只需修改 ConfigMap 相关的配置就好。但是要注意，不能将一些认证信息不能放在
  ConfigMap 中。
- Secret: 因为认证信息（即用户名/密码）不能以明文的形式些在配置文件中，所以就有了 secret，
  这个文件用来保存加密（base64 加密）后的认证信息。
- Volumes: 因为 pod 重启后并不会恢复原有的数据，所以就有了 Volumes 这个抽象，可以将外部的
  存储设备进行虚拟化，将一些需要保存的数据存放在这些设备中，让后通过 Volumes 对其进行映射。

#### Control Plane

Control Plane 负责管理集群的，包括协调集群活动、集群服务调度、集群服务状态、集群服务拓展以及
集群服务更新。同时，Control Plane 主机需要有以下四个程序：

- API Server: 相当于集群的网管，负责与客户端交互，然后对客户端的命令进行验证。负责处理请求及
  验证请求是否有效。
- Scheduler: 负责集群资源的调度，对集群的资源进行分配，与 Node 端的 Kublet 交互。
- Controller Mananger:负责检查集群的状态，若是发生改变，会通知 Scheduler 执行相对应的调度
- etcd: 相当于集群的大脑，其中以键值对的方式记录了集群的状态信息，包括集群健康状态、资源状态
  以及集群状态。

#### Node

Node 既可以是物理主机也可以是虚拟主机，是集群的的服务运行的机器。每个 node 都需要安装以下三个
程序：

- container runtime: docker 容器的运行环境
- kubelet: 负责管理 node 上的 pod，和 control plane 进行通信（即与 Scheduler 交互）
- kube proxy: 当不同 pod 之间进行通信时，需要 kube proxy 来处理这些请求

## Summary

总的来说，k8s 是为了能够更加高效、更加简单地管理 docker 容器，尽可能地保障生产线的稳定。

当然，关于 k8s，还有相关的 [`namespace`][k8s-namespace] 和 [`deployment`][deployment]等没有介绍，具体内容查看连接所指向的文档。


[entrypoint]: https://docs.docker.com/engine/reference/builder/#entrypoint

[docker-compose]: https://docs.docker.com/compose/

[docker0]: http://docs.docker.oeynet.com/engine/userguide/networking/

[nat]: https://baike.baidu.com/item/nat/320024

[bridge]: https://baike.baidu.com/item/网络桥接

[hostonly]: https://www.linuxidc.com/Linux/2016-09/135521p3.htm

[internal-network]: https://baike.baidu.com/item/内部网

[intranet]: https://baike.baidu.com/item/Intranet/3247037

[namespace]: https://www.linux.com/news/understanding-and-securing-linux-namespaces

[dockerfile]: https://docs.docker.com/engine/reference/builder/

[dockerhub]: https://hub.docker.com/

[k8s-namespace]: http://docs.kubernetes.org.cn/242.html

[deployment]: https://www.kubernetes.org.cn/deployment
