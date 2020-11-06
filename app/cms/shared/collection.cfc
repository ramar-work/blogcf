/* ------------------------------------------------------ *
 * collection.cfc
 * ------------
 * 
 * @author
 * Antonio R. Collins II (ramar@collinsdesign.net)
 *
 * @summary
 * A "collection" is a base object, a collection of nodes.
 * So there will be primitives dealing with nodes and IDs here.
 * 
 * @todo
 * Hash a version of the title, and make this the unique id
 * Or rely on that other thing...
 * ------------------------------------------------------ */
component name="collection" extends="base" accessors=true {

	//Dependencies injected at the start
	property name="dependencies" default="app.cms.shared.metadata,app.cms.shared.node";

	//Dependency base directory (exists to allow developers to use short names)
	property name="dependencyBaseDir" default="app.cms.shared";

	//Different collectiontypes will inherit from this, this defines how stuff is presented.
	property name="collectiontype" type="string"; 

	//Table long ID column name
	property name="uuidColumnName" type="string" default="collection_long_id";

	//Table numeric ID column name
	property name="idColumnName" type="string" default="collection_id";

	//Prime column name
	property name="primeColumnName" type="string" default="collection_name";

	//create
	public struct function create( required args ) {
		var r = myst.dbExec(
			datasource = components.cms.getDatasource()
		,	string = "
			INSERT INTO #table#
				( collection_name, collection_type )
			VALUES 
				( :pname, :ptype )"
		, bindArgs = {
				pname = { value=args.title, type="varchar" }
			,	ptype = { value=createName(), type="varchar" }
			}
		);

		if ( !r.status ) {
			return myst.lfailure( 500, "Failure at collection write - #r.message#" );
		}

		//Get the long id
		if ( ( id = get_long_id( r.prefix.generatedKey ) ) == "" ) {
			return myst.lfailure( 500, "Could not retrieve id at #name#.create - #r.message#" );
		}

		//Create a new entry in the metadata table
		if ( !(r = metadata.create( args, id )).status ) {
			return myst.lfailure( 500, r.message );
		}

		return {
			status = true 
		, id = id 
		,	message = "Everything is successful." 
		};
	}


	//update a collection
	public struct function update( required args ) {
		//Update the title and stuff
		var r = myst.dbExec(
			datasource = components.cms.getDatasource()
		,	string = "
				UPDATE 
					#table#
				SET 
					collection_name = :pname
				, collection_owner = :pauthor
				WHERE
					collection_long_id = :pid
			"
		, bindArgs = {
				pid = { value=args.parent_id, type="varchar" }
			,	pauthor = { value=args.author, type="varchar" }
			,	pname = { value=args.title, type="varchar" }
			}
		);

		if ( !r.status ) {
			return r;
		}

		//Update the metadata
		if ( !(r = metadata.update( args, args.parent_id )).status ) {
			return r;
		}

		//Return a status
		return {
			status = true
		, id = args.parent_id
		, message = "Successfully updated #name#"
		}
	}


	public struct function delete( required string id ) {
		//Update the title and stuff
		var r = myst.dbExec(
			datasource = components.cms.getDatasource()
		, bindArgs = { pid = { value=id, type="varchar" } }
		,	string = "DELETE FROM	#table# WHERE collection_long_id = :pid"
		);

		if ( !r.status ) {
			return r;
		}

		//Also delete metadata
		if ( !( r = metadata.delete( id ) ).status ) {
			return r;
		}

		//...and nodes associated with the collection
		if ( !( r = node.deleteByCollectionId( id ) ).status ) {
			return r;
		}

		return {
			status = true
		, message = "Deleted row and rows"
		}
	}


	//Retrieve all the collections regardless of draft status.
	public struct function all() {
		var r = myst.dbExec(
	   	string = "
			SELECT * FROM
				( SELECT * FROM #prefix#collection ) AS p
			INNER JOIN
				( SELECT * FROM #prefix#collection_metadata ) AS m
			ON 
				p.collection_long_id = m.pmd_collection_match_id
			ORDER BY 
				collection_date_added 
			DESC
			"
		);

		return r;
	}


	//Retrieve one collection	
	public struct function single( numeric id, string lid ) {
		var pid; 
		var plid;
		var r;

		//Choose the right thing
		if ( StructKeyExists( arguments, "id" ) ) {
			pid = arguments.id;
			plid = -1;
		}
		else if ( StructKeyExists( arguments, "lid" ) ) {
			plid = arguments.lid; 
			pid = -1; 
		}
		else {
			//Useful to combine url and argument scopes?  Then I just move through one.
			var vs = myst.validate( url, {
				{ collection_id = { req = false, ifNone = -1 } }
			 ,{ collection_long_id = { req = false, ifNone = -1 } }
			});
			pid = vs.results.collection_id; 
			plid = vs.results.collection_long_id; 
		}

		//Make the insert
		r = myst.dbExec(
			datasource = myst.getDatasource()
		, bindArgs = { pid = pid, plid = plid }
		, string = "	
			SELECT
				collection_long_id as pid
			, collection_name as title 
			, collection_date_modified as datemod 
			, lm_prefix as author_prefix
			, lm_suffix as author_suffix
			, lm_fname as author_fname
			, lm_mname as author_mname
			, lm_lname as author_lname
			, login_uuid as author_uuid
			, collection_type as type
			, pmd_isdraft as draft 
			, pmd_showfooter as footerstatus
			, pmd_showpimg as fimagestatus
			, pmd_showcomments as commentstatus
			, content_long_id as cid
			, content_type_i as ctypei
			, content_type
			, content_type_class
			, content_order
			, content_text as ctext 
			FROM
				(
					SELECT * FROM
					(
						SELECT * FROM
							(
							SELECT *
							FROM
								( SELECT * FROM #prefix#login ) as login
							INNER JOIN
								( SELECT * FROM #prefix#login_metadata ) as lmeta
							ON
								login.login_id = lmeta.lm_match_id
							) as LL
						INNER JOIN
							( 
							SELECT * FROM 
								#prefix#collection 
							WHERE 
								collection_id = :pid OR collection_long_id = :plid 
							) as PP
						ON
							LL.login_uuid = PP.collection_owner	
					) as ap
					INNER JOIN
					( SELECT * FROM #prefix#collection_metadata ) AS pm
					ON ap.collection_long_id = pm.pmd_collection_match_id
				) as p
			INNER JOIN
				( SELECT * FROM #prefix#content ) as c
			ON 
				p.collection_long_id = c.content_collection_match_id
			ORDER BY 
				p.collection_id
			, c.content_order
			ASC"
		);

		return {
			status = r.status
		, message = r.message
		, results = components.cms.convertResultSetToFullPaths( r, "ctext" )
		}
	}


	//Retrieve all the published collections.
	public struct function published() {
		var r = myst.dbExec(
	   	string = "
				SELECT * FROM
					( SELECT * FROM #prefix#collection ) AS p
				INNER JOIN
					( SELECT * FROM #prefix#collection_metadata WHERE pmd_isdraft = 0 ) AS m
				ON 
					p.collection_long_id = m.pmd_collection_match_id
				ORDER BY 
					collection_date_added 
				DESC
			"
		);
		
		return r;
	}

	//Retrieve summary of collections.
	public struct function summary( numeric collectioncount ) {
		var ct;
		if ( arguments[1] neq "" )
			ct = arguments[1];
		else if ( StructKeyExists( arguments, "collectioncount" ) )
			ct = count;
		else if ( StructKeyExists( url, "collectioncount" ) )
			ct = url.count;
		else {
			ct = getPostCount();
		}

		var b = myst.dbExec(
		  bindArgs = { cct = ct }
		, datasource = components.cms.getDatasource()
		, string = "	
			SELECT * FROM (
				SELECT * FROM
					( SELECT * FROM #prefix#collection ) AS ap
				INNER JOIN
					( SELECT * FROM #prefix#collection_metadata WHERE pmd_isdraft = 0 ) AS pm
				ON ap.collection_long_id = pm.pmd_collection_match_id
			) as p
			INNER JOIN
				( SELECT * FROM #prefix#content WHERE content_order < :cct ) as c
			ON 
				p.collection_long_id = c.content_collection_match_id
			ORDER BY 
				p.collection_id
			, c.content_order 
			ASC
			"
		);

		var c = myst.dbExec(
		  bindArgs = { cct = ct }
		, query = b.results
		, string = "SELECT * FROM _mem_ WHERE content_order < 1"
		);

		return {
			status = c.status
		, message = c.message
		, results =	components.cms.convertResultSetToFullPaths( c, "content_text" )
		}
	}

	function init( myst, model ) {
		Super.init( myst );
		return this;
	}
}
