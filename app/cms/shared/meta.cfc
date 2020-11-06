//Base utilities for messing with CMS modules
component name="meta" extends="base" accessors=true {

	//Table long ID column name
	property name="uuidColumnName" type="string" default="meta_long_id";

	//Table numeric ID column name
	property name="idColumnName" type="string" default="meta_id";

	public struct function create( required args ) {
		var vs = myst.validate( args, {
			/*The name of the record is what should exist in POST or GET*/
		  parent_id = { req = true }
		, title = { req = true }
		, draft = { req = false, ifNone = 0 }
		, footer = { req = false, ifNone = 0 }
		, previewimg = { req = false, ifNone = 0 }
		, comments = { req = false, ifNone = 0 }
		});

		//These sort of get their own db...
		return {}	
	}


	//Retrieve basic metas, eventually feed from datasource
	public query function standard() {
		//You can use a validator to catch arguments

		//Return a query	
		return QueryNew(
			"key,value,content"
		, "varchar,varchar,varchar"
		, [
				{ key="http-equiv", value="content-type", content="text/html; charset=utf-8" }
			 ,{ key="http-equiv", value="X-UA-Compatible", content="ie=edge" }
			 ,{ key="name", value="google-site-verification", content="rAPss2vKbyhbh6uzTuqqhhq2eoXUCKPQosTwcxNHjU4" }
			 ,{ key="name", value="viewport", content="minimum-scale=1.0, maximum-scale=1.0, width=device-width, user-scalable=no" }
			 ,{ key="name", value="apple-mobile-web-app-capable", content="yes" } 
			 ,{ key="name", value="apple-mobile-web-app-status-bar-style", content="black-translucent" } 
			 ,{ key="name", value="author", content="Antonio Ramar Collins II" } 
			 ,{ key="name", value="description", content="ramarcollins.com, a blog about programming and web design" } 
			 ,{ key="property", value="og:locale", content="en_US" } 
			 ,{ key="property", value="og:type", content="website" } 
			 ,{ key="property", value="og:title", content="ramarcollins.com | 5 Years In" } 
			 ,{ key="property", value="og:description", content="" }
			 ,{ key="property", value="og:url", content="http://ramarcollins.com/" } 
			 ,{ key="property", value="og:site_name", content="ramarcollins.com" } 
			 ,{ key="name", value="twitter:card", content="" } 
			// ,{ key="name", value="twitter:description", content="" }
			// ,{ key="name", value="twitter:title", content="" } 
			// ,{ key="name", value="twitter:site", content="@ranviainsights" } 
			// ,{ key="name", value="twitter:creator", content="@ranviainsights" } 
			]
		);
	}

	function init( myst, model ) {
		Super.init( myst );
		return this;
	}

}
