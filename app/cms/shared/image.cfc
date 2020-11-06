/* ------------------------------------------------------ *
 * image.cfc
 * ------------
 * 
 * @author
 * Antonio R. Collins II (ramar@collinsdesign.net)
 *
 * @summary
 * Deals with featured images.
 * 
 * @todo
 * ...
 * ------------------------------------------------------ */
component name="image" extends="base" {
	//Table long ID column name
	property name="uuidColumnName" type="string" default="fi_long_id";

	//Table numeric ID column name
	property name="idColumnName" type="string" default="fi_id";

	public struct function create( args ) {
		var vs = myst.validate( args, {
		  parent_id = { req = true }
		 ,draft = { req = false, ifNone = 0 }
		});

		if ( !vs.status ) {
			return vs;	
		}

		//Make the insert
		r = myst.dbExec(
			datasource = components.cms.getDatasource()
		,	string = "
			INSERT INTO #table#
				( fi_collection_match_id, fi_type_class, fi_path )
			VALUES 
				( :match_id, :type, :data )
			"
		, bindArgs = {
			 	match_id = { value=cid, type="varchar" }
			,	type = { value=vs.results.draft, type = "bit" }
			,	data = { value=vs.results.comments, type = "bit" }
			}
		);

		if ( !r.status ) {
			return myst.lfailure( 500, "Failure at image write - #r.message#" );
		}

		//return Super.create({ results = r.prefix.generatedKey })
		return {
			status = true
		, message = "success writing image data"
		, results = r.prefix.generatedKey
		}
	}

	public struct function delete( required string id ) {
		//Make the insert
		r = myst.dbExec(
			datasource = components.cms.getDatasource()
		,	string = "DELETE FROM #table# WHERE fi_collection_match_id = :id"
		, bindArgs = { id = { value=id, type="varchar" }}
		);

		if ( !r.status ) 
			return r;
		else {
			return {
				status = true
			, message = "success deleting image #id#"
			}
		}
	}

	public struct function update( args ) {
		//Make the insert
		r = myst.dbExec(
			datasource = components.cms.getDatasource()
		,	string = "UPDATE #table# 
				SET fi_path = :path 
			WHERE fi_collection_match_id = :id"
		, bindArgs = { id = { value=id, type="varchar" }}
		);

		if ( !r.status ) 
			return r;
		else {
			return {
				status = true
			, message = "success deleting image #id#"
			}
		}
	}

	public struct function matching( required string id ) {
		//Make the insert
		r = myst.dbExec(
			datasource = components.cms.getDatasource()
		,	string = "SELECT * FROM #table# WHERE fi_collection_match_id = :id"
		, bindArgs = { id = { value=id, type="varchar" }}
		);

		if ( !r.status ) 
			return r;
		else {
			return {
				status = true
			, message = "success deleting image #id#"
			}
		}
	}

	function init( myst, model ) {
		Super.init( myst );
		table = "#prefix#featured_image";
		return this;
	}
}
