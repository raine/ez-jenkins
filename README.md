# ez-jenkins [![Build Status](https://travis-ci.org/raine/ez-jenkins.svg?branch=master)](https://travis-ci.org/raine/ez-jenkins) [![npm version](https://badge.fury.io/js/ez-jenkins.svg)](https://www.npmjs.com/package/ez-jenkins)

<p align="right">
  <a href="https://github.com/raine/ez-jenkins/blob/media/tail.gif">
    <img align="right" width="198" height="135" src="https://raw.githubusercontent.com/raine/ez-jenkins/media/tail.gif">
  </a>
</p>

> cli for jenkins ci

```sh
npm install -g ez-jenkins
jenkins setup
jenkins list <pattern>
jenkins tail <job-name>
```

## features

- **`list`** jobs in a table, usable as [terminal walldisplay](https://github.com/raine/ez-jenkins/tree/master/etc)
- **`tail`** a job for output indefinitely
- open job configuration view in browser with **`configure`**
- fuzzy search: provides suggestions when a job name provides no exact match

## requirements

- node `>= v0.11.3`

## usage

```
$ jenkins
Usage: jenkins <command> [options]

Commands:
  list         list jobs
  tail         read build logs
  configure    open configure view in browser for a job
  setup        interactively configure jenkins base url
```

## roadmap

- [ ] start and stop builds
- [ ] tail multiple builds

## screenshots

[![](https://raw.githubusercontent.com/raine/ez-jenkins/media/iojs-build-smaller.png)](https://raw.githubusercontent.com/raine/ez-jenkins/media/iojs-build.png)

[![](https://raw.githubusercontent.com/raine/ez-jenkins/media/list-smaller.png)](https://raw.githubusercontent.com/raine/ez-jenkins/media/list.png)
