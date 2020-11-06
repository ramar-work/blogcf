component extends="base" {

	property name="requiredOnCreate" type="struct" default="title";
	property name="requiredOnUpdate" type="struct" default="parent_id,title";
	property name="requiredOnDelete" type="struct" default="";
	property name="requiredOnRetrieve" type="struct" default="";
	property name="optionalOnCreate" type="struct" default="comments=0,draft=0,footer=0,previewimg=0";
	property name="optionalOnUpdate" type="struct" default="author='',comments=0,draft=0,footer=0,previewimg=0";
	property name="optionalOnDelete" type="struct" default="";
	property name="optionalOnRetrieve" type="struct" default="";
	property name="dependencies" default="app.cms.shared.collection.post";

	//TODO: Remove these.  Shouldn't be needed.
	property name="UUIDColumnName" type="string" default="collection_long_id";
	property name="IDColumnName" type="string" default="collection_id";

	private struct function create( args ) {
		return post.create( args );
	}

	private struct function retrieve( args ) {
		return post.retrieve( args );
	}

	private struct function update( args ) {
		return post.update( args );
	}

	private struct function delete( args ) {
		/*
		if ( !StructKeyExists( args, "id" ) ) {
			return myst.lfailure( 400, "No 'id' specified." );
		}
		*/
		return post.delete( route.active );
	}

	function init( myst, model ) {
		//post = new app.cms.shared.collection.post( myst, model );
		return Super.init( myst );
	}
}
