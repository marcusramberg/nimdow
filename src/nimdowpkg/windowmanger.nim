import config/config  

proc testAction*() =
  echo "I did a thing with the windows"

proc testAction2*() =
  echo "I did a ANOTHER thing with the windows"

proc setupActions*() =
  config.configureAction("testAction", testAction)
  config.configureAction("testAction2", testAction2)

