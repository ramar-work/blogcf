component extends="base" name="meta" {
	property name="dependencies" default="app.cms.shared.meta";
	property name="requiredOnCreate" type="struct" default="title";
	property name="requiredOnUpdate" type="struct" default="parent_id,title";
	property name="requiredOnDelete" type="struct" default="";
	property name="requiredOnRetrieve" type="struct" default="";
	property name="optionalOnCreate" type="struct" default="comments=0,draft=0,footer=0,previewimg=0";
	property name="optionalOnUpdate" type="struct" default="author='',comments=0,draft=0,footer=0,previewimg=0";
	property name="optionalOnDelete" type="struct" default="";
	property name="optionalOnRetrieve" type="struct" default="";

	//TODO: Remove these.  Shouldn't be needed.
	property name="UUIDColumnName" type="string" default="meta_long_id";
	property name="IDColumnName" type="string" default="meta_id";

	private struct function create( args ) {
		return meta.create( args );
	}

	private struct function delete( args ) {
		if ( !StructKeyExists( args, "id" ) ) {
			return myst.lfailure( 400, "No 'id' specified." );
		}
		return meta.delete( args.id );
	}

	private struct function retrieve( args ) {
		return meta.retrieve( args );
	}

	private struct function update( args ) {
		return meta.update( args );
	}

	function init(myst, model) {
		return Super.init( myst );
	}
}
