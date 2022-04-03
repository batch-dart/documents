# 1. Fundamentals

<!-- TOC -->

- [1. Fundamentals](#1-fundamentals)
  - [1.1. Event](#11-event)
    - [1.1.1. Job](#111-job)
    - [1.1.2. Step](#112-step)
    - [1.1.3. Task](#113-task)
      - [1.1.3.1. Declare](#1131-declare)
      - [1.1.3.2. Constructor](#1132-constructor)
      - [1.1.3.3. Define Process](#1133-define-process)
    - [1.1.4. Parallel](#114-parallel)
      - [1.1.4.1. Parallel Task](#1141-parallel-task)
      - [1.1.4.2. Parallel Task and Task](#1142-parallel-task-and-task)
  - [1.2. ExecutionContext](#12-executioncontext)
  - [1.3. Branch](#13-branch)

<!-- /TOC -->

## 1.1. Event

Each scheduled processes in `Batch.dart` is represented centrally as an `Event`.
An `Event` is a very simple concept consisting of the following elements.

1. **_Job_** - The largest unit.
2. **_Step_** - The intermediate unit.
3. **_Task_** - The smallest unit.
4. **_Parallel_** - It's kind of `Task` but represents parallel processes.

### 1.1.1. Job

- A `Job` is the largest unit of events.
- A `Job` event can have multiple `Step`s and multiple unscheduled `Job`s as branches, and the `Job` at the top level must be scheduled.

### 1.1.2. Step

- A `Step` is an intermediate unit of event between a `Job` and a `Task`.
- A `Step` can have multiple `Task`s and multiple `Step`s as branches.

### 1.1.3. Task

- A `Task` is the smallest unit of an `Event`.
- A `Task` can have multiple `Tasks` as branches.

The `Task` defines the specific process at each step. For example, define the following.

```dart
import 'package:batch/batch.dart';

// Basic tasks can be created by extending the `Task` class and implementing the `execute` method.
class DoSomethingTask extends Task<DoSomethingTask> {
  // This constructor definition does not have to be optional to work.
  // If you want to use a callback in this Task process, define it as follows.
  DoSomethingTask({
    Function(ExecutionContext context)? onStarted,
    Function(ExecutionContext context)? onSucceeded,
    Function(ExecutionContext context, dynamic error, StackTrace stackTrace)?
        onError,
    Function(ExecutionContext context)? onCompleted,
    RetryConfiguration? retryConfig,
  }) : super(
          onStarted: onStarted,
          onSucceeded: onSucceeded,
          onError: onError,
          onCompleted: onCompleted,
          retryConfig: retryConfig,
        );

  @override
  void execute(ExecutionContext context) {
    // Write your code here.
  }
}
```

Okay, now let's look at the above example in more detail.

#### 1.1.3.1. Declare

The `Task` class is designed to take the type of a concrete class that extends `Task` as generics like below.

```dart
class DoSomethingTask extends Task<DoSomethingTask> {}
```

The reason why the `Task` class receives the type of the concrete class from which the `Task` class inherits is to use the name of this received type in the system log provided by the framework. Therefore, as in the previous example, the generics of the `Task` class should specify the type of the concrete class from which the `Task` class is inherited.

#### 1.1.3.2. Constructor

As described in the comments of the previous [example](#113-task), the constructor definition of `Task` is optional and can be omitted if not necessary.

```dart
DoSomethingTask({
  Function(ExecutionContext context)? onStarted,
  Function(ExecutionContext context)? onSucceeded,
  Function(ExecutionContext context, dynamic error, StackTrace stackTrace)?
      onError,
  Function(ExecutionContext context)? onCompleted,
  RetryConfiguration? retryConfig,
}) : super(
        onStarted: onStarted,
        onSucceeded: onSucceeded,
        onError: onError,
        onCompleted: onCompleted,
        retryConfig: retryConfig,
      );
```

#### 1.1.3.3. Define Process

The specific processing of the task should be written in the `execute` method. This `execute` method is a simple method with no return value, but it takes a rather difficult `ExecutionContext` as an argument.

```dart
@override
void execute(ExecutionContext context) {
  // Write your code here.
}
```

The `ExecutionContext` passed as an argument contains objects such as execution status and parameters from the current `Job` to this `Task`. This `ExecutionContext` is especially important when controlling [Branches](#13-branch), which will be introduced later.

The `ExecutionContext` is passed from the framework at the start of each `Task`, so the user does not need to be aware of the creation of this `ExecutionContext`.

Since `ExecutionContext` is an important but somewhat counter-intuitive concept, so it will be described in detail in a [separate chapter](<(#12-executioncontext)>).

### 1.1.4. Parallel

- `Parallel` is an event that represents the parallel processing of tasks.
- `Parallel` has objects that inherit from multiple `ParallelTasks` that define specific parallel processing.

#### 1.1.4.1. Parallel Task

The `ParallelTask` is a `Task` for parallel processing that inherits from and extends the previously introduced [Task](#113-task) class.

`ParallelTask` is used in the same way as `Task`, but there are following differences.

- The name of the overriding execution method is `invoke`.
- The `invoke` method does not take `ExecutionContext` as an argument.
- `ParallelTask` cannot define callback processing. Instead, define a callback if needed for `Parallel` events.

The differences above stem from the difficulty of parallel processing. However, despite some technical limitations, the parallel processing provided by `Batch.dart` is very powerful.

Therefore, implement as follows.

```dart
import 'dart:async';

import 'package:batch/batch.dart';

class DoSomethingParallelTask extends ParallelTask<DoSomethingParallelTask> {
  @override
  FutureOr<void> invoke() {
    // Write your code here.
  }
}
```

#### 1.1.4.2. Parallel Task and Task

`Parallel` is a somewhat exceptional event, because it is part of a task, and `Step` events can be treated in the same way as the `Task` class.
Indeed, the `Step` class can handle `Task` and `Parallel` classes simultaneously and maintain the order of execution as shown below.

```dart
import 'dart:async';

import 'package:batch/batch.dart';

void main() {
  Step(name: 'Test Step')
    ..nextParallel(
      Parallel(
        name: 'Parallel Tasks',
        tasks: [
          DoSomethingParallelTask(),
          DoSomethingParallelTask(),
          DoSomethingParallelTask(),
          DoSomethingParallelTask(),
        ],
      ),
    )
    ..nextTask(DoSomethingTask());
}

class DoSomethingTask extends Task<DoSomethingTask> {
  @override
  void execute(ExecutionContext context) {
    // Write your code here.
  }
}

class DoSomethingParallelTask extends ParallelTask<DoSomethingParallelTask> {
  @override
  FutureOr<void> invoke() {
    // Write your code here.
  }
}
```

In the above example, multiple `ParallelTask`s and a singular `Task` are set at the same time, but the order of execution is as defined: the `Task` is executed after all `ParallelTask`s are completed.

## 1.2. ExecutionContext

## 1.3. Branch
