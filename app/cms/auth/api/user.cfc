component extends="base" {
	property name="dependencies" default="app.cms.shared.user";
	property name="requiredOnCreate" type="struct" default="username,password,role";
	property name="requiredOnUpdate" type="struct" default="";
	property name="requiredOnDelete" type="struct" default="";
	property name="requiredOnRetrieve" type="struct" default="";
	property name="optionalDefaultToString" type="boolean" default=true;
	property name="optionalOnCreate" type="struct" default="fname,mname,lname,suffix,prefix,avatar,description,role"
	property name="optionalOnUpdate" type="struct" default="author='',comments=0,draft=0,footer=0,previewimg=0";
	property name="optionalOnDelete" type="struct" default="";
	property name="optionalOnRetrieve" type="struct" default="";

	//TODO: Remove these.  Shouldn't be needed.
	property name="UUIDColumnName" type="string" default="login_uuid";
	property name="IDColumnName" type="string" default="login_id";

	private struct function create( args ) {
		return user.create( args );
	}

	private struct function retrieve( args ) {
		return user.retrieve( args );
	}

	private struct function update( args ) {
		return user.update( args );
	}

	private struct function delete( args ) {
		return user.delete( route.active );
	}

	function init( myst, model ) {
		return Super.init( myst );
	}
}
