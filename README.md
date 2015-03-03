# ez-jenkins [![npm version](https://badge.fury.io/js/ez-jenkins.svg)](https://www.npmjs.com/package/ez-jenkins)

> Easy CLI for Jenkins CI

```sh
npm install -g ez-jenkins
jenkins setup
jenkins tail <job-name>
```

## features

- `tail` a job for output indefinitely
- search by pattern: provides suggestions when a job name does not match

## usage

```
$ jenkins
Usage: jenkins <command> [options]

Commands:
  tail    read build logs
  setup   interactively configure jenkins base url
```

```
$ jenkins tail -h
Usage: jenkins tail [options] <job-name>

Options:
  -f, --follow  follow a job's build logs indefinitely (think tail -f)
  -b, --build   show output for a specific build
```

![](https://raw.githubusercontent.com/raine/ez-jenkins/media/tail.png)
