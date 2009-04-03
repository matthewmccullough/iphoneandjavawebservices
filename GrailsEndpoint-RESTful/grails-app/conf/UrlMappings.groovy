class UrlMappings {
    static mappings = {
        "/contestantREST/$id?"(controller:"contestantREST"){
            action = [GET:"getREST", PUT:"updateREST", DELETE:"deleteREST", POST:"createREST"]
        }
        
        "/contestantRESTList"(controller:"contestantREST"){
            action = [GET:"listREST"]
        }
        
        "/contestantRESTRandom"(controller:"contestantREST"){
            action = [GET:"randomREST"]
        }
        
      "/$controller/$action?/$id?"{
	      constraints {
			 // apply constraints here
		  }
	  }
	  "500"(view:'/error')
	}
}
