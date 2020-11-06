/* ------------------------------------------------------ *
 * category.cfc
 * ------------
 * 
 * @author
 * Antonio R. Collins II (ramar@collinsdesign.net)
 *
 * @summary
 * Category model.
 * 
 * @todo
 * ...
 * ------------------------------------------------------ */
component name="category" extends="base" accessors=true {

	property name="uuidColumnName" type="string" default="category_uuid";

	property name="idColumnName" type="string" default="category_id";

	property name="primeColumnName" type="string" default="category_name";

	//Get all in a set
	public struct function all() {
		return select( myst.dbExec( string = "SELECT * FROM #table#" ) );
	}	

	//Get by UUID or ID
	public struct function single( args ) {
		//why is this returning like this?
		var r = myst.dbExec( 
			string = "SELECT * FROM #table# WHERE category_uuid = :id"
		, bindArgs = { id = args.id } 
		);
		return select( r );
	}

	//Get a matching
	public struct function matching( required string id ) {
		var r = myst.dbExec(
			bindArgs = { id = id }
		, string = "
				SELECT * FROM
					( SELECT * FROM #prefix#category ) as Cat
				INNER JOIN
					( SELECT * FROM #prefix#category_rel ) as Rel
				ON
					Rel.catrel_categorymatch_id = Cat.category_uuid
				WHERE
					Rel.catrel_postmatch_id = :id
			"
		);
		return select( r );
	}


	public struct function assign( required string pid, required string cid ) {
		//not 'get', instead use 'add'
		var r = myst.dbExec(
			bindArgs = { pid = pid, cid = cid }
		, string = "
			INSERT INTO #prefix#category_rel 
				( catrel_postmatch_id, catrel_categorymatch_id ) 
			VALUES 
				( :pid, :cid )
			"
		);	
	}


	public struct function create( required args ) {
		var r = myst.dbExec( 
			string = "INSERT INTO #table# ( category_name ) VALUES ( :name )"
		, bindArgs = { name = args.name }
		);

		return ( !r.status ) ? r : {
			status = true
		, httpstatus = 201 
		, id = get_long_id( r.prefix.generatedKey )
		}
	}


	public struct function delete( required string id ) {
		var r = myst.dbExec(
			string = "DELETE FROM #table# WHERE category_uuid = :id"
		, bindArgs = { id = id }
		);

		if ( !r.status )
			return r;
		else if ( r.prefix.recordcount eq 0 )
			return myst.lfailure( 404, "File referenced by #id# not found." );
		else {
			//if there is nothing, the httpstatus should probably change
			return { 
				status = true
			, id = id
			, count = r.prefix.recordCount
			}
		}
	}


	public struct function update( required string id, required args ) {
		if ( StructKeyExists( args, "name" ) && StructKeyExists( args, "description" ) )
			columns = "category_name = :name, category_description = :description"; 
		else if ( StructKeyExists( args, "description" ) )
			columns = "category_description = :description"; 
		else if ( StructKeyExists( args, "name" ) )
			columns = "category_name = :name"; 
		else {
			return myst.lfailure( 400, "Nothing to update." );
		}	

		var r = myst.dbExec(
			string = "UPDATE #table# SET #columns# WHERE category_uuid = :id"
		, bindArgs = { 
			  id = id
			, name = StructKeyExists( args, "name" ) ? args.name : false
			, description = StructKeyExists( args, "description" ) ? args.name : false
			}
		);

		return ( !r.status ) ? r : {
			status = true
		, httpstatus = 202
		,	id = id
		}
	}


	function init( myst, model ) {
		Super.init( myst );
		return this;
	}
}
