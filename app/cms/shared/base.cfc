/* ------------------------------------------------------ *
 * base.cfc
 * --------
 * 
 * @author
 * Antonio R. Collins II (ramar@collinsdesign.net)
 *
 * @summary
 * Base utilities for messing with CMS modules
 * 
 * @todo
 * ...
 * ------------------------------------------------------ */
component name="base" extends="std.base.model" accessors=true {

	//The name of the database column containing a record's UUID
	property name="UUIDColumnName" type="string" default="_";

	//The name of the database column containing a record's numeric ID
	property name="IDColumnName" type="string" default="_";

	//The name of the database column used to check for a record's existence
	property name="PrimeColumnName" type="string" default="_";

	//Eventually, these properties will be used to instruct the CMS to work with certain columns
	//property name="columnsOnCreate" type="string" default="";
	//property name="columnsOnUpdate" type="string" default="";
	//property name="columnsOnDelete" type="string" default="";
	//property name="columnsOnRetrieve" type="string" default="";

	property name="dependencies" type="list" default="";

	property name="errorOnCreate" type="string" default="";

	property name="errorOnUpdate" type="string" default="";

	property name="errorOnDelete" type="string" default="";

	property name="errorOnRetrieve" type="string" default="";

	//Run after a database call
	private string function stringTypes( required string list ) {
		var a = [];
		for ( var i=0; i < ListLen( list ); i++ ) {
			ArrayAppend( a, "varchar" );
		}
		return ArrayToList( a );
	}


	//Return an empty query containing columns
	private query function emptyQuery( required string list ) {
		return QueryNew( list, stringTypes( list ) );  
	}


	//Selects are acting weird...
	private struct function select( struct r ) {
		//TODO: Do I actually need this?  
		//If there is an error, it'd be nice to know, but maybe a better idea to log it...
		if ( r.status && r.prefix.recordCount == 0 ) {
			return { 
				status = true
			, count = 0
			, results = emptyQuery( r.prefix.columnList )
			}
		}
		else {
			var rr = {};
			rr.status = r.status;
			rr.count = !r.status ? -1 : r.prefix.recordCount;
			if ( !r.status )
				rr.message = r.message;
			else {
				rr.results = r.results;
			}
			return rr;
		}
	}


	//TODO: Use either number or arguments
	private string function get_long_id ( required numeric id ) {
		return myst.dbExec(
			string = "SELECT #getUUIDColumnName()# FROM #table# WHERE #getIdColumnName()# = :id"
		, bindArgs = { id = id }	
		).results[ getUUIDColumnName() ];
	}

	//private boolean function exists ( required value ) {
	private boolean function exists ( required value ) {
		var r = myst.dbExec(
			string = "SELECT #getPrimeColumnName()# FROM #table# WHERE #getPrimeColumnName()# = :v"
		, bindArgs = { v = value }	
		);

		return ( r.prefix.recordCount > 0 );
	}


	public struct function create( required args ) {
		return myst.success( "Created new #name#" );
	}

	public struct function update( required args ) {
		return myst.success( "Updated #name#" );
	}

	public struct function delete( required args ) {
		return myst.success( "Deleted new #name#" );
	}

	public struct function all( required args ) {
		return myst.success( "Retrieved #name#" );
	}

	public struct function single( required string id ) {
		return myst.success( "Retrieving one record with id = #name#" );
	}

	public struct function matching( required string id ) {
		return myst.success( "Retrieving multiple records containing id = #name#" );
	}

	function init( myst, model ) {
		Super.init( myst );
		variables.prefix = components.cms.getPrefix(); 
		variables.name = createName();
		variables.table = "#prefix##name#";
		return this;
	}

}
