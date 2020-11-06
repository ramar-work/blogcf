component extends="base" name="keyword" {
	property name="dependencies" default="app.cms.shared.keyword";
	property name="requiredOnCreate" type="struct" default="parent_id,name";
	//TODO: Remove these.  Shouldn't be needed.
	property name="UUIDColumnName" type="string" default="keyword_uuid";
	property name="IDColumnName" type="string" default="keyword_id";

	private struct function create( args ) {
		return keyword.create( args );
	}

	private struct function delete( args ) {
		return keyword.delete( args.id );
	}

	// /cms/api/keyword/$ID
	private struct function retrieve( args ) {
		return keyword.matching( args.id ).results;
	}

	function init(myst, model) {
		return Super.init( myst );
	}
}
