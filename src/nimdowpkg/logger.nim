import
  os,
  logging,
  strutils,
  times

export logging

var
  enabled* = false
  initalized = false
  logger: RollingFileLogger
  pendingMessages: seq[tuple[line: string, level: Level]]

template log*(message: string, level: Level = lvlInfo) =
  const module = instantiationInfo().filename[0 .. ^5]
  let line = "[$# $#][$#]: $#" % [getDateStr(), getClockStr(), module, message]
  echo "$# $#" % [LevelNames[level], line]

  if enabled:
    logLine(line, level)
  elif not initalized:
    pendingMessages.add (line, level)

template logLine*(line: string, level: Level = lvlInfo) =
  if logger == nil:
    try:
      logger = newRollingFileLogger(getHomeDir() & ".nimdow.log", fmAppend)
    except:
      let err = getCurrentExceptionMsg()
      echo "Failed to open log file for logging:"
      echo err

  if logger != nil:
    logger.log(level, line)
    logger.file.flushFile()

proc enableLogging*(enable: bool) =
  if enable:
    enabled = true
    if not initalized:
      for (line, level) in pendingMessages: logLine(line, level)
  else:
    enabled = false
  initalized = true

