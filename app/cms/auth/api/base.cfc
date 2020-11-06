//component extends="std.base.model" {
component extends="app.cms.shared.base" {

	//A table to return
	property name="table" type="string";

	//Which module is this?
	property name="name" type="string";

	//Each of these really just an instance of the same object 
	property name="self" type="object";

	//Dependencies
	property name="dependencies" type="string";

	//If values are not specified, default to a blank string
	property name="optionalDefaultToString" type="boolean" default=false;

	//Keys to catch when running a /create
	property name="requiredOnCreate" type="struct" default="";

	//Keys to catch when running an /update
	property name="requiredOnUpdate" type="struct" default="";

	//Keys to catch when running a /delete
	property name="requiredOnDelete" type="struct" default="";

	//Keys to catch when running a /retrieve
	property name="requiredOnRetrieve" type="struct" default="";

	//Keys to catch when running a /create
	property name="optionalOnCreate" type="struct" default="";

	//Keys to catch when running an /update
	property name="optionalOnUpdate" type="struct" default="";

	//Keys to catch when running a /delete
	property name="optionalOnDelete" type="struct" default="";

	//Keys to catch when running a /retrieve
	property name="optionalOnRetrieve" type="struct" default="";

	//Only API will deal with this for now... but this may change
	private struct function filter( required string method, required args ) {
		//results are the results of myst.validate()
		var v = {};

		for ( var key in ListToArray( variables[ "requiredOn#method#" ] ) ) {
			v[ key ] = { req = true };
		}

		for ( var key in ListToArray( variables[ "optionalOn#method#" ] ) ) {
			var lr = ListToArray( key, "=" ); 
			if ( Len(lr) eq 1 ) {
				v[ key ] = { req = false }
				if ( variables.optionalDefaultToString ) {
					v[ key ].ifNone = ""; 
				}
			}
			else if ( lr[2] eq "file" ) {
				v[ lr[1] ] = { req = false, file = true }
			}
			else {
				v[ lr[1] ] = { 
					req = false
				, ifNone = lr[2]
				, type = myst.getType( lr[2] ).type
				}
			}
		}

		if ( !( valid = myst.validate( args, v ) ).status ) {
			return myst.lfailure( 400, valid.message );
		}

		//If the method is NOT create, then route.active should be added as the id
		if ( method neq "create" ) {
			valid.results[ "id" ] = route.active;
		}

		return { 
		  status = true 
		, results = valid.results
		};
	}

	private boolean function uuid_exists ( required string value ) {
		var r = myst.dbExec(
			string = "SELECT #getUUIDColumnName()# FROM #table# WHERE #getUUIDColumnName()# = :v"
		, bindArgs = { v = value }	
		);
		return ( r.status && r.prefix.recordCount > 0 );
	}

	//CRUD ops can be extended if I think about this...
	private struct function create( args ) {
		return self.create( args );
	}

	private struct function update( required id, args ) {
		return self.update( args );
	}

	private struct function delete( required id ) {
		return self.delete( args );
	}

	private struct function retrieve( required id ) {
		return self.single( id );
	}

	private struct function all( required id ) {
		return self.all( id );
	}

	function init( myst, model ) {
		Super.init( myst );

		//Others need this
		prefix = components.cms.getPrefix();

		//Check for some kind of valid credentials
		if ( !components.cms.checkUserToken() ) {
			return myst.lfailure( 401, "Invalid access token." );
		}

		//If method is POST and struct is empty form, then die...
		if ( cgi.request_method == "POST" && StructIsEmpty( form ) ) {
			return myst.lfailure( 400, "No data sent." );
		}

		//Dispatch to methods and filter necessary keys
		if ( ( map = doesRouteMap( 2 ) ).status )
			return ( !(r = filter( map.name, getScope() )).status ) ? r : this[ map.name ]( r.results ); 
		else if ( uuid_exists( route.active ) ) {
			//exists must return true for whatever it is... and call retrieve too
			return this.retrieve( { id = route.active } );	
		}

		//Other entries should return 404 automatically...		
		return myst.lfailure( 400, "Server could not fulfill this request." );
	}
}
