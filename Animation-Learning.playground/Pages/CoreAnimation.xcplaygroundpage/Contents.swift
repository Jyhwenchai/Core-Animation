//: [Previous](@previous)

import UIKit
import PlaygroundSupport

//: ## CALayer
//: 在开始说明 `Core Animation` 中的相关动画前我们需要对 `CALayer` 有些了解。可以说使用核心动画作用的对象是 `CALayer` 的相关属性，如果你有查看 `CALayer` 的相关属性列表，你可以看到绝大多数的属性都带有 `Animatable` 的备注，这说明这些属性都是可动画的，你可以这个[列表](https://developer.apple.com/library/archive/documentation/Cocoa/Conceptual/CoreAnimation_guide/AnimatableProperties/AnimatableProperties.html#//apple_ref/doc/uid/TP40004514-CH11-SW1)中查看所有可动画属性。

//: ### Frame & Bounds & AnchorPoint & Position
//: 在开始实现动画一些动画前我们来对 `CALayer` 的 `frame`、`bounds` 、`anchorPoint`、 `position` 这几个属性进行说明。
//: * `bounds` 属性相对于图层本身的坐标系统，它确定图层本身的坐标以及自身的大小。
//: * `position` 属性是相对于其父图层坐标系统上的位置，修改值会改变图层在父图层中的位置
//: * `frame` 属性很多开发者会简单的将其看成是相对于父坐标系统上的位置，这就和 `position` 类似了，实际上 `frame` 是由根据 `bounds` 与 `position` 两者衍生出来的属性，它会受旋转、缩放等操作的影响，所以当你对图层进行了一些旋转、缩放等行为之后你不能依据 `frame` 来确定图层的大小，而是应该使用 `bounds` 与 `position` 获取大小和位置信息。
//: * `anchorPoint` 属性你可以将其看成是一个支点，所有的旋转、缩放等行为都是围绕这个点进行的操作。
//:
//: 有一点需要知道的是 `position` 始终指向 `anchorPoint` 的位置，当你调整 `anchorPoint` 的值时，此时图层的位置将发生变化，`position` 与 `anchorPoint` 将不再同一个位置，这时候为了保持 `position` 指向 `anchorPoint` 的位置你需要调整 `position` 的值。可以观察下面示图中图层相关信息（你可以只关注左半部分的内容）：
//:
//:
//: ![](layer_coords_anchorpoint_position_2x.png)
//:
//:
//: 示图中 `anchorPoint` 初始默认值为（0.5，0.5）位于图层的中心，此时对应的 `position` 的值为（100，100）, 在下一张中调整 `anchorPoint` 值为（0，0）, 此时如果你不调整 `position` 的值那么图层将往右下角移动，因为这样 `anchorPoint` 才会与 `position` 在一个位置。所以当在示图中为了保持图层相对于父视图的位置不变，当 `anchorPoint` 的值为（0，0）时，你需要修改 `position` 的值为（40，60）, 保持两者指向相同的位置。
//:
//:
//: **你可以下面的公式来计算调整 `anchorPoint` 后图层相对父视图的位置以及如何调整以保持相对父视图的位置保持不变**
//:
//: #### 调整 `anchorPoint` 后图层相对父视图的位置
//: `new.origin.x = origin.x - (new.anchorPoint.x - 0.5) * width`, 其中 `origin.x` 表示图层相对于父图层的初始位置，`new.origin.x` 为调整 `anchorPoint x` 后的新位置
//: #### 如果你需要保持调整前后相对于父视图位置不变
//: `new.position.x = position.x + (new.anchorPoint.x - 0.5) * width` 或者是 `new.position.x = position.x + origin.x - new.origin.x`
//:
//: - note: 你也可以通过这个[示例代码](https://github.com/Jyhwenchai/Core-Animation-Example/AnchorPoint&Position)来观察它们之间的关系

