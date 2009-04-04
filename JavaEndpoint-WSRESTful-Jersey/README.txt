This is the RESTful/Jersey/IntelliJ plain-text response variant of JavaWeb Services for the iPhone talk.

It does not use JSON or XML.

You can CURL the additions and winner picking as follows:

addContestant =
curl -X PUT localhost:9090/drawing/<SomeName>

getWinner =
curl localhost:9090/drawing
