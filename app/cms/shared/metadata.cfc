/* ------------------------------------------------------ *
 * metadata.cfc
 * ------------
 * 
 * ...
 * ------------------------------------------------------ */
component name="metadata" extends="base" {

	//Table long ID column name
	property name="uuidColumnName" type="string" default="meta_long_id";

	//Table numeric ID column name
	property name="idColumnName" type="string" default="meta_id";

	//Different collectiontypes will inherit from this, this defines how stuff is presented.
	function create( required args, required string cid ) {
		var vs = myst.validate( args, {
		  draft = { req = false, ifNone = 0 }
		, footer = { req = false, ifNone = 0 }
		, previewimg = { req = false, ifNone = 0 }
		, comments = { req = false, ifNone = 0 }
		});

		//Make the insert
		r = myst.dbExec(
			datasource = components.cms.getDatasource()
		,	string = "
			INSERT INTO #table#
				( pmd_collection_match_id, pmd_isdraft, pmd_showfooter, pmd_showpimg, pmd_showcomments )
			VALUES 
				( :plong_id, :draft, :footer, :pimg, :comments )
			"
		, bindArgs = {
			 	plong_id = { value=cid, type="varchar" }
			,	draft = { value=vs.results.draft, type = "bit" }
			,	footer = { value=vs.results.footer, type = "bit" }
			,	pimg = { value=vs.results.previewimg, type = "bit" }
			,	comments = { value=vs.results.comments, type = "bit" }
			}
		);

		if ( !r.status ) {
			return myst.lfailure( 500, "Failure at collection metadata write - #r.message#" );
		}

		//return Super.create({ results = r.prefix.generatedKey })
		return {
			status = true
		, message = "success writing metadata"
		, results = r.prefix.generatedKey
		}
	}


	//...
	function update ( required args, required string id ) {
		var vs = myst.validate( args, {
		  draft = { req = false, ifNone = 0 }
		, footer = { req = false, ifNone = 0 }
		, previewimg = { req = false, ifNone = 0 }
		, comments = { req = false, ifNone = 0 }
		});

		//Update the title and stuff
		r = myst.dbExec(
			datasource = components.cms.getDatasource()
		,	string = "
				UPDATE 
					#table#
				SET 
					pmd_isdraft = :pd
				, pmd_showfooter = :pf
				, pmd_showpimg = :pi
				, pmd_showcomments = :pc
				WHERE
					pmd_collection_match_id = :pid
			"
		, bindArgs = {
				pid = { value=id, type="varchar" }
			, pc = { value=vs.results.comments, type="integer" }
			, pd = { value=vs.results.draft, type="integer" }
			, pf = { value=vs.results.footer, type="integer" }
			, pi = { value=vs.results.previewimg, type="integer" }
			}
		);

		if ( !r.status ) {
			return r;
		}

		//return Super.update({ results = r.prefix.generatedKey })
		return {
			status = true
		, message = "success writing metadata"
		}
	}


	public struct function delete ( required string id ) {
		var r = myst.dbExec(
			datasource = components.cms.getDatasource()
		,	string = "DELETE FROM	#table# WHERE pmd_collection_match_id = :pid"
		, bindArgs = { pid = { value=id, type="varchar" } }
		);

		if ( !r.status ) {
			return r;
		}

		//return Super.delete({ results = r.prefix.generatedKey })
		return {
			status = true
		, message = "success deleting metadata"
		}
	}


	function init( myst, model ) {
		Super.init( myst );
		table = "#prefix#collection_metadata";
		return this;
	}

}
