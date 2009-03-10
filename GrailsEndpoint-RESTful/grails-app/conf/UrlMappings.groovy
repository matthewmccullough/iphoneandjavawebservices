class UrlMappings {
    static mappings = {
        "/contestantREST/$id?"(controller:"contestant"){
            action = [GET:"getREST", PUT:"updateREST", DELETE:"deleteREST", POST:"createREST"]
        }
        
        "/contestantsREST/"(controller:"contestant"){
            action = [GET:"listREST"]
        }
        
      "/$controller/$action?/$id?"{
	      constraints {
			 // apply constraints here
		  }
	  }
	  "500"(view:'/error')
	}
}
