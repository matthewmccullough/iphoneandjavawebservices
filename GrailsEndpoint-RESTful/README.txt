The scaffolded URL for the UI is:
http://localhost:8080/restgrails/contestant/list

The restful URL for the same controller is:
http://localhost:8080/restgrails/contestantREST/



To test the restful services:

Get a list of all existing contestants:
curl -X GET http://localhost:8080/restgrails/contestantRESTList/

Create/add a new contestant:
curl -X POST -d "name=Badman" http://localhost:8080/restgrails/contestantREST/
or
curl -X POST http://localhost:8080/restgrails/contestantREST/?name=Applegate

Get an existing contestant's details:
curl -X GET http://localhost:8080/restgrails/contestantREST/1

Delete an existing contestant:
curl -X DELETE http://localhost:8080/restgrails/contestantREST/1

Update an existing contestant:
curl -X PUT -d "name=Joe Smith" http://localhost:8080/restgrails/contestantREST/1
 
Select a random contestant (winner):
curl http://localhost:8080/restgrails/contestantRESTRandom