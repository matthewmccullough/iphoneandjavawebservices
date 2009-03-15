import grails.converters.*

class ContestantController {

    def scaffold = true
    
    def randomREST = {
        //curl http://localhost:8080/restgrails/contestantRESTRandom
        def contestant = null
        while (contestant == null) {
            contestant = Contestant.get(new Random().nextInt(Contestant.list().size+1))
        }
        
        render contestant as XML 
    }
    
    def listREST = {
        //curl http://localhost:8080/restgrails/contestantRESTList
        render Contestant.list() as XML
    }
    
    def getREST = {
        def contestant = Contestant.get(params['id'])
        if (!contestant)
            render "contestant ${params['id']} not found"
        else {
            render contestant as XML
        }
    }
    
    def updateREST = {
        def contestantToUpdate = Contestant.get(params['id'])
        if (!contestantToUpdate)
            render "contestant ${params['id']} not found"
        else {
            contestantToUpdate.name = params['name']
            contestantToUpdate.save()
            render contestantToUpdate as XML
        }
    }
    
    def deleteREST = {
        def contestantToDelete = Contestant.get(params['id'])
        if (!contestantToDelete)
            render "contestant ${params['id']} not found"
        else {
            contestantToDelete.delete()
            render contestantToDelete as XML
        }
    }
    
    def createREST = {
        def contestantToCreate = new Contestant()
        contestantToCreate.properties = params
        contestantToCreate.save()
        render contestantToCreate as XML
    }
}
