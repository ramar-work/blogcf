/* ------------------------------------------------------ *
 * keyword.cfc
 * -----------
 * 
 * @author
 * Antonio R. Collins II (ramar@collinsdesign.net)
 *
 * @summary
 * Primitives dealing with keywords.
 * 
 * @todo
 * ...
 * ------------------------------------------------------ */
component name="keyword" extends="base" accessors=true {
	//Table long ID column name
	property name="UUIDColumnName" type="string" default="keyword_uuid";

	//Table numeric ID column name
	property name="idColumnName" type="string" default="keyword_id";

	public struct function matching( required string id ) {
		return myst.dbExec(
			bindArgs = { id = id }
		,	string = "SELECT * FROM #prefix#keyword WHERE keyword_postmatch_id = :id"
		);
	}


	public struct function create( required args ) {
		var r = myst.dbExec( 
			string = "
			INSERT INTO #table# ( keyword_postmatch_id, keyword_text ) VALUES ( :pid, :text )"
		, bindArgs = { pid = args.parent_id, text = args.name }
		);

		return ( !r.status ) ? r : {
			status = true
		, id = get_long_id( r.prefix.generatedKey )
		}
	}


	public struct function delete( required string id ) {
		var r = myst.dbExec(
			string = "DELETE FROM #table# WHERE keyword_uuid = :id"
		, bindArgs = { id = id }
		);
		if ( !r.status ) 
			return r;
		else if ( r.prefix.recordcount eq 0 )
			return myst.lfailure( 404, "Keyword referenced by #id# not found." );
		else {
			return {
				status = true
			, id = id
			, count = r.prefix.recordCount
			}
		}
	}


	function init( myst, model ) {
		Super.init( myst );
		return this;
	}
}
