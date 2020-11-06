component name="node" extends="base" accessors=true {

	property name="randlen" type="numeric" default=64;

	//Table long ID column name
	property name="uuidColumnName" type="string" default="content_long_id";

	//Table numeric ID column name
	property name="idColumnName" type="string" default="content_id";

	//Field text is handled here now
	property name="fieldText" type="string" default="lucy-text";
	property name="fieldName" type="string" default="lucy";

	//....
	public struct function create( required args ) {
		var ct_constant = components.cms.getConstText();
		var set = { mimetype = "text/html", class = "T" };
		var writeable_cont;

		//Fork again, and... 
		if ( StructKeyExists( args, variables.fieldText ) )
			writeable_cont = args[ variables.fieldText ];
		else if ( StructKeyExists( args, variables.fieldName ) ) {
			var xy = args[ variables.fieldName ];
			ct_constant = components.cms.getMimeCategoryIndex( xy.serverfileext );
			set.mimetype = components.cms.getMimetype( xy.serverfileext ); 
			set.class = "F";

			//Read content in and write it to a random file...
			try {
				var contents = FileRead( xy.fullpath );
				var bc = BinaryDecode( contents, "Base64" );
				var fpath = myst.getConstantMap()["files"];
				var rndFilename = myst.randStr( getRandlen() ) & "." & xy.serverfileext;
				//TODO: Writing to memory is the best option, this is stupid...
				//Write new file and delete the original afterwards...
				FileWrite( "#fpath#/#components.cms.getNamespace()#/#rndFilename#", bc );
				FileDelete( xy.fullpath );
				writeable_cont = rndFilename;
			}
			catch ( any e ) {
				return myst.lfailure( 500, "Failed to write stream to file.", e );  
			}

			//Adding these keys to the result set would be very helpful
			set.filename = xy.serverfilename;
			set.bytes = xy.oldfilesize;
			set.modified = xy.timelastmodified;
		}

		//This writes to the content table
		vs = myst.dbExec(
			datasource = components.cms.getDatasource()
		, bindArgs = {
				ctype = { value = ct_constant, type = "integer" }
			,	class = set.class
			,	ctfull = set.mimetype
			,	file = writeable_cont
			,	oid = args.order
			, pid = args.parent_id
			}
		, string = "
				INSERT INTO #table# (
					content_collection_match_id
				,	content_type_i
				,	content_type
				,	content_type_class
				,	content_order
				,	content_text
				)
				VALUES (
					:pid
				, :ctype
				, :ctfull
				, :class 
				, :oid
				, :file
				)"
		);

		//Die if the write was unsuccessful.
		if ( !vs.status )
			return vs;

		if ( ( set.uuid = get_long_id( vs.prefix.generatedKey ) ) eq "" )
			return myst.lfailure( 500, "No ID found for #vs.prefix.generatedKey#" );

		return { 
			status = true
		, httpstatus = 200
		, message = "Successfully wrote new content row."
		, metadata = set
		};
	}

	/*
	public struct function retrieve( required args ) {
		//This writes to the content table
		var vs = myst.dbExec(
			string = "SELECT * FROM #table# WHERE collection_long_id = :pid"
		, datasource = components.cms.getDatasource()
		, bindArgs = { pid = { value = id, type = "varchar" } }
		);
		if ( !vs.status ) {
			return vs;
		}
		//return myst.success( vs.results );
		return { 
			status = true
		, message = "..." 
		, results = vs.results
		};
	}
	*/

	public struct function deleteByCollectionId( required string id ) {
		var r = myst.dbExec(
			datasource = components.cms.getDatasource()
		,	string = "DELETE FROM	#table# WHERE content_collection_match_id = :pid"
		, bindArgs = { pid = { value=id, type="varchar" } }
		);

		if ( !r.status ) {
			return r;
		}

		//return Super.delete({ results = r.prefix.generatedKey })
		return {
			status = true
		, message = "Success deleting nodes"
		}
	}


	private struct function deleteFileById( required string id ) {
		//If the type is a file, the file needs to be deleted too...
		r = myst.dbExec( 
			datasource = components.cms.getDatasource()
		,	string = "SELECT * FROM	#table# WHERE content_long_id = :pid"
		, bindArgs = { pid = { value=id, type="varchar" } }
		);

		if ( r.status && r.prefix.recordCount eq 1 && r.results.content_type_class eq "F" ) {
			var ff = r.results.content_text;
			var f = "#myst.getRootDir()#files/#components.cms.getNamespace()#/#ff#";
			//TODO: What a strange way to handle this...
			FileDelete( f );
			return { status = !FileExists( f ) };
		}

		return { status = true };
	}


	//Delete an id
	public struct function delete( required string id ) {
		if ( !deleteFileById( id ).status ) {
			//This is not a fatal error...
		}

		r = myst.dbExec(
			datasource = components.cms.getDatasource()
		,	string = "DELETE FROM	#table# WHERE content_long_id = :pid"
		, bindArgs = { pid = { value=id, type="varchar" } }
		);

		if ( !r.status ) {
			return r;
		}

		//return Super.delete({ results = r.prefix.generatedKey })
		return {
			status = true
		, message = "success deleting node [#id#]"
		}
	}


	//Update a node
	public struct function update( required args ) {
	}

	function init( myst, model ) {
		Super.init( myst );
		table = "#prefix#content";
		return this;
	}
}
