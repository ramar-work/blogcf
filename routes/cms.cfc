/* ------------------------------------------------------ *
 * routes/cms.cfc
 * --------------
 * 
 * @author
 * Antonio R. Collins II (ramar@collinsdesign.net)
 *
 * @summary
 * Initialize the routes for a particular route
 * 
 * @todo
 * ...
 * ------------------------------------------------------ */
component name="cms" extends="base" {

	function init( myst, model ) {
		Super.init( myst );

		//Define standard routes first...
		var routes = {
			"#components.cms.getNamespace()#" = {
				authenticate = { model= path.private( "auth" ) }
			, login = { model= path.private( "assets", "@" ),	view = path.private( "@" ) }
			, logout = { model="cms/auth/revoke" }
			, file = {
					".*" = {
						model = function( myst, model ) {
							Super.init( myst );
							var path = "files/#components.cms.getNamespace()#/#route.active#";
							return myst.serveStaticResource([], path, "File not found.");
						}
					}
				}
				//HTML endpoints post-authentication
			, categories = {
					model = path.private( "assets", "@" )
				, view = path.private( "shared/head", "categories", "shared/tail" ) 
				}
			, settings = {
					model= path.private( "assets", "@" ) 
				, view = path.private( "shared/head", "settings", "shared/tail" ) 
				}
			, users = { 
					model = path.private( "assets", "@" ) 
				, view = path.private( "shared/head", "users", "shared/tail" ) 
				, ".*" = {
						model = path.private( "assets", "users" )
					, view = path.private( "shared/head", "user", "shared/tail" ) 
					}
				}
/*
			, "(categories)|(settings)|(users)" = {
					model= path.private( "assets", "@" )
				, view = path.private( "shared/head", "@", "shared/tail" )
				}
*/
			}
		};

		//Generate API endpoints
		var api = { returns = "application/json", check = { model = "cms/auth/api/check" }}
		for ( var name in ["node","post","keyword","category","user"] ) {
			var p = {
				"#name#" = {
					"create" = { model = "cms/auth/api/#name#" }
				, "delete" = { ".*" = { model = "cms/auth/api/#name#" } }
				, "update" = { ".*" = { model = "cms/auth/api/#name#" } }
				, ".*" = { model = "cms/auth/api/#name#" }
				}
			}
			StructAppend( api, p );
		}
		routes[ components.cms.getNamespace() ][ "api" ] = api;

	
		//Add each of the collection endpoints	
		for ( var name in components.cms.getCollections() ) {
			var p = {
				//TODO: These should be generated another way
				"#name#s" = {
					model= path.private( "assets", "@" )
				, view = path.private( "shared/head", "@", "shared/tail" )
				, "new" = { 
						model= path.private( "assets", "#name#s" )
					, view = path.private( "shared/head", "#name#", "shared/tail" )
					}
				, "edit" = { 
						".*" = {
							model = path.private( "assets", "#name#s" )
						, view = path.private( "shared/head", "#name#", "shared/tail" )
						}
					}
				}
			};
			StructAppend( routes[ components.cms.getNamespace() ] , p );
		}

		//Finally add regular user endpoints (where people can read content)
		var f = {
			//This is the summary page
			"#components.cms.getPageFront()#" = {
				model = path.public( "summary" )
			, view = path.public( "shared/head", "summary", "shared/tail" ) 
			, archives = {
					model = path.public("@")
				, view = path.public("shared/head", "archives", "shared/tail" )
				}
			, ".*" = {
					model = path.public( "single" )
				, view = path.public( "shared/head", "single", "shared/tail" )
				}
			}
		}
		StructAppend( routes, f );
		return routes;
	}
}
