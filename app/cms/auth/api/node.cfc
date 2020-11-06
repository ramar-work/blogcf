component extends="base" {

	property name="dependencies" default="app.cms.shared.node";
	property name="requiredOnCreate" type="struct" default="order,parent_id";
	property name="requiredOnUpdate" type="struct" default="";
	property name="requiredOnDelete" type="struct" default="";
	property name="requiredOnRetrieve" type="struct" default="";
	property name="optionalOnCreate" type="struct" default="lucy-text,lucy=file";
	property name="optionalOnUpdate" type="struct" default="";
	property name="optionalOnDelete" type="struct" default="";
	property name="optionalOnRetrieve" type="struct" default="";

	//TODO: Remove me
	property name="UUIDColumnName" type="string" default="content_long_id";
	property name="IDColumnName" type="string" default="content_id";

	private struct function create( args ) {
		return node.create( args );
	}

	private struct function update( required id, args ) {
		return {};
	}

	private struct function delete( required args ) {
		var vs;
		var r;

		if ( !( vs = myst.validate(args, {node_id = { req = true }})).status ) {
			return vs;
		}

		return node.delete( vs.results.node_id );
	}

	private struct function retrieve( required id ) {
		//This writes to the content table
		var vs = myst.dbExec(
			string = "SELECT * FROM #prefix#content WHERE post_long_id = :pid"
		, datasource = components.cms.getDatasource()
		, bindArgs = { pid = { value = id, type = "varchar" } }
		);
		if ( !vs.status ) {
			return vs;
		}
		return { 
			status = true
		, message = "..." 
		, results = vs.results
		};
	}

	function init( myst, model ) {
		return Super.init( myst );
	}
}
