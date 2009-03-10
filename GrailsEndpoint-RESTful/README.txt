The scaffolded URL for the UI is:
http://localhost:8080/restgrails/contestant/list

The restful URL for the same controller is:
http://localhost:8080/restgrails/contestantREST/



To test the restful services:

Get a list of Contestants:
curl -X GET http://localhost:8080/restgrails/contestantsREST/

Create a Contestant:
curl -X POST -d "name=Badman" http://localhost:8080/restgrails/contestantREST/

Get a Contestant's details
curl -X GET http://localhost:8080/restgrails/contestantREST/1

Delete Contestant:
curl -X DELETE http://localhost:8080/restgrails/contestantREST/1

Update Name:
curl -X PUT -d "name=Joe Smith" http://localhost:8080/restgrails/contestantREST/1
 
