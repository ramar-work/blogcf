<cfscript>
data.routes[ cms.getNamespace() ] = {
	/*CMS routes (not virtual yet, but good for testing)*/
  "login"= { 
		view = [ "cms/login/head", "cms/login", "cms/login/tail" ] 
	}
, "register"= { 
		view = [ "cms/login/head", "cms/register", "cms/login/tail" ] 
	}

, "settings"= { 
		model="cms/settings"
	, view = [ "cms/master/head", "cms/settings", "cms/master/tail" ] 
	}
, "list"= { 
		view = [ "cms/master/head", "cms/list", "cms/master/tail" ] 
	}
, "edit"= { 
		model="cms/edit"
	, view = [ "cms/master/head", "cms/modify", "cms/master/tail" ] 
	}
, "new"= { 
		model="cms/modify"
	, view = [ "cms/master/head", "cms/modify", "cms/master/tail" ] 
	}

	//Setup routines
,	"setup"	= { model = "cms/setup/cms" }
};
</cfscript>
