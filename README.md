# EnvKit (🌲)

EnvKit is a Swift package for transmitting environment variables between shell processes.

## Usage

Some basic examples:

```swift
import EnvKit

let env = try Env(["env-key": "env-value"])
env["env-key"] = "env-new-value"
try env.save() 
try env.destroy()
```


## Install

Just use the Swift Package Manager as usual:

```swift
.package(url: "https://github.com/binarybirds/env-kit", from: "1.0.0"),
```

Don't forget to add "Env" to your target as a dependency:

```swift
.product(name: "EnvKit", package: "env-kit"),
```

That's it.



## License

[WTFPL](LICENSE) - Do what the fuck you want to.
