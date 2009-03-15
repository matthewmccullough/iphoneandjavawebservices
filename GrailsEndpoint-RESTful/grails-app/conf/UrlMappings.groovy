class UrlMappings {
    static mappings = {
        "/contestantREST/$id?"(controller:"contestant"){
            action = [GET:"getREST", PUT:"updateREST", DELETE:"deleteREST", POST:"createREST"]
        }
        
        "/contestantsRESTList"(controller:"contestant"){
            action = [GET:"listREST"]
        }
        
        "/contestantRESTRandom"(controller:"contestant"){
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
