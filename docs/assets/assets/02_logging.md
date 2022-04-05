# 1. Logging

<!-- TOC -->

- [1. Logging](#1-logging)
  - [1.1. Customize](#11-customize)
    - [1.1.2. LogOutput](#112-logoutput)

<!-- /TOC -->

## 1.1. Customize

It is very easy to customize the configuration of the Logger provided by the `Batch.dart` to suit your preferences.

Just pass the `LogConfiguration` object to the constructor when instantiating the `BatchApplication` as below.

```dart
BatchApplication(
  logConfig: LogConfiguration(
    // Change log level to debug.
    level: LogLevel.debug,
  ),
);
```

Also, the logging feature can be freely customized by inheriting the following abstract classes and setting them in the `LogConfiguration`.

|                | Description                                                                                                             |
| -------------- | ----------------------------------------------------------------------------------------------------------------------- |
| **LogFilter**  | This is the layer that determines whether log output should be performed. By default, only the log level is determined. |
| **LogPrinter** | This layer defines the format for log output.                                                                           |
| **LogOutput**  | This is the layer that actually performs the log output. By default, it outputs to the console.                         |

### 1.1.2. LogOutput

|                      | Description                                                                                                                      |
| -------------------- | -------------------------------------------------------------------------------------------------------------------------------- |
| **ConsoleLogOutput** | Provides features to output log to console. This filter is used by default.                                                      |
| **FileLogOutput**    | Provides features to output the log to the specified file.                                                                       |
| **MultiLogOutput**   | Allows multiple log outputs. This is useful, for example, when you want to have console output and file output at the same time. |

**_Example_**

```dart
BatchApplication(
  logConfig: LogConfiguration(
    output: ConsoleLogOutput(),
  ),
);
```

**_With MultiLogOutput_**

```dart
BatchApplication(
  logConfig: LogConfiguration(
    output: MultiLogOutput([
      ConsoleLogOutput(),
      FileLogOutput(file: File('./test.txt')),
    ]),
  ),
);
```
