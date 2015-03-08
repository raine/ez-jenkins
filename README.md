# ez-jenkins [![Build Status](https://travis-ci.org/raine/ez-jenkins.svg?branch=master)](https://travis-ci.org/raine/ez-jenkins) [![npm version](https://badge.fury.io/js/ez-jenkins.svg)](https://www.npmjs.com/package/ez-jenkins)

<p align="right">
  <a href="https://github.com/raine/ez-jenkins/blob/media/tail.gif">
    <img align="right" width="198" height="135" src="https://github.com/raine/ez-jenkins/blob/media/tail-anim-small.gif">
  </a>
</p>

> Jenkins CI for people who like command-line

```sh
npm install -g ez-jenkins
jenkins setup
jenkins tail <job-name>
```

## requirements

- node `>= v0.11.3`

## features

- **`tail`** a job for output indefinitely
- open job configuration view in browser with **`configure`**
- fuzzy search: provides suggestions when a job name provides no exact match

## usage

```
$ jenkins
Usage: jenkins <command> [options]

Commands:
  tail         read build logs
  configure    open configure view in browser for a job
  setup        interactively configure jenkins base url
```

### tail

```
$ jenkins tail -h
Usage: jenkins tail [options] <job-name>

Options:
  -f, --follow  follow a job's build logs indefinitely (think tail -f)
  -b, --build   show output for a specific build

Examples:
  jenkins tail my-build -f
  jenkins tail my-build -b 70
```

### configure

```
$ jenkins configure -h
Usage: jenkins configure <job-name>

Examples:
  jenkins configure my-build
```

[![](https://raw.githubusercontent.com/raine/ez-jenkins/media/iojs-build-smaller.png)](https://raw.githubusercontent.com/raine/ez-jenkins/media/iojs-build.png)
