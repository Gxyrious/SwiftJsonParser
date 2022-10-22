# SwiftJsonParser

> - Swift语言下的一个简单JSON解析器

在Xcode中，苹果官方已经给出关于Swift中解析和创建JSON对象的类和协议，大致可列举如下：

- Codable: `typealias Codable = Decodable & Encodable`

- JSONEncoder: An object that encodes instances of a data type as JSON objects.

- JSONDecoder: An object that decodes instances of a data type from JSON objects.

- JSONSerialization: An object that converts between JSON and the equivalent Foundation objects.


本项目利用Swift语言中面向对象的特性，尝试复现关于JSON解析的实现方式，并参考了一些开源的一些项目。

---

主要实现的功能如下：

- 在已知类型本身以及该类型某个对象生成的字典或JSON格式时，生成该对象实体

并非所有类型都可以转换为JSON格式，故需要作出限定，因此要求类型继承`JsonParsable`类；在`JsonParsable`类中实现了属性赋值的初始化函数。在初始化函数中采用`Mirror`类来获取`JsonParsable`子类的运行时属性，对应初始化参数中的字典，依次赋值。

JSON转换为字典采用的是Foundation库中的`JSONSerialization`，如果输入并非标准JSON字符串则会抛出异常。

- 在已知类型本身以及该类型的某个对象，将该对象转换为字典或JSON格式

使用`Mirror`类遍历获取该对象的属性名和属性值，并生成对应的字典。`Mirror`是Foundation库用于动态反射的工具，下面是官方文档中的描述：

*A mirror describes the parts that make up a particular instance, such as the instance’s stored properties, collection or tuple elements, or its active enumeration case. Mirrors also provide a “display style” property that suggests how this mirror might be rendered.*

字典转换为JSON格式采用`JSONSerialization`和`String`中的相关函数。



