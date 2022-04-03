# 1. Introduction

<!-- TOC -->

- [1. Introduction](#1-introduction)
  - [1.1. Mission](#11-mission)
  - [1.2. Features](#12-features)
  - [1.3. Background](#13-background)
  - [1.4. Expected Usage](#14-expected-usage)
  - [1.5. Operating Environment](#15-operating-environment)

<!-- /TOC -->

## 1.1. Mission

The goal of this project is to provide a **_high-performance_** and **_intuitive_** job scheduling framework in the Dart language ecosystem that anyone can use in the world.

And the development concept of this framework is "[DRY](https://en.wikipedia.org/wiki/Don%27t_repeat_yourself)", "[KISS](https://en.wikipedia.org/wiki/KISS_principle)" and "[YAGNI](https://en.wikipedia.org/wiki/You_aren%27t_gonna_need_it)", which has been said in software engineering circles for a long time.

## 1.2. Features

- Easy and intuitive job scheduling.
- Scheduling in Cron format provided as standard (Customizable).
- Powerful logging feature provided as standard (Customizable).
- You can easily define parallel processes.
- There are no hard-to-understand configuration files.
- Supports conditional branching of jobs.
- Extensive callback functions are provided at each step.
- Supports skipping and retrying according to user defined conditions.

## 1.3. Background

There is `Spring Batch`, my old and respected giant of the Java world, but these frameworks have too many configuration files and settings to run an application and take **_too long_** to set up. And above all, the actual implementation of the task is also **_non-intuitive_** and **_redundant_**.

Luckily I stumbled upon the Dart language around 2021 and was fascinated by the smart ecosystem of this language. I then started this project with the idea of rebuilding on top of this excellent ecosystem of the Dart language to make the world's most complex and bizarre job scheduling frameworks easy enough for **_anyone to handle_**.

And from this background, `Batch.dart` **_does not_** provide complex and bizarre configuration files, but is designed so that all settings **_can be added_** by the implementation as needed (It was not until after I released the initial build that I learned that this type of implementation using configuration files is not very common in the Dart language).

## 1.4. Expected Usage

Due to the nature of this framework, the following usage is recommended.

- CLI-based applications.

And **_not_** below.

- Applications that run in a browser or on a smartphone.

> Note:
> In pub.dev, the automatic determination at the time of release of this library labels it as usable in Flutter, but it is not suitable by any stretch of the imagination.

## 1.5. Operating Environment

The Dart language is a cross-platform language, so there are no platform restrictions that limit the use of this framework. You can use as many as you like on any platform.
