# Slurm REST API

> @author Chen Quanwei

## 简介

**API（Application Programming Interface）** 翻译过来是应用程序编程接口的意思。

**REST API** 经常也被叫做 **RESTful API** ，全称是 **Resource Representational State Transfer** ，翻译过来比较晦涩，简单理解就是一份用于编写HTTP接口的规范，其实现在互联网常见的HTTP接口基本都是这个规范，详细了解见 **[RestFul API 简明教程](https://javaguide.cn/system-design/basis/RESTfulAPI.html)** 。

**OpenAPI** 是描述 HTTP API 的规范，可以理解为 REST API 是接口编码设计的规范，OpenAPI是调用接口的说明文档，文档介绍了接口URL、参数、调用方法等信息，详细了解见 [**OpenAPI 规范（中文版）**](https://openapi.xiniushu.com/) 。

**Slurm REST API** 即 slurm 推出的符合RESTful规范的一组HTTP接口，方便用户通过HTTP接口调用slurm功能，如获取集群信息、创建账户、提交作业、查看作业等常用功能，基本可满普通用户的使用需求，官方文档见 [**Slurm REST API**](https://slurm.schedmd.com/rest.html) 。

## 导航

- README.md

  本文将介绍以下内容

  1. 安装

     Slurm REST API 的安装和配置

  2. 权限控制

     API 接口的鉴权方式，Slurm REST API 是如何识别用户的

  3. 接口功能介绍

     一些常用的接口介绍，使用案例

- Makefile

​	作者学习使用时的一些命令，里面有大量案例和注释，对Makefile语法熟悉的同学，可以直接看它学习和使用，不会Makefile的同学可以学习 [**Makefile介绍**](https://seisman.github.io/how-to-write-makefile/introduction.html) 。

- conf

  配置文件夹，存放user_token等文件

- openapi

  接口调用文档，是调用Slurm REST API接口直接生成的

- request

  使用HTTP POST接口的request body

## 安装



## 权限控制





## 接口介绍

