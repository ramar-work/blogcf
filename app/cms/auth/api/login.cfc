/* ------------------------------------------------------ *
 * login.cfc
 *
 * @author Antonio R. Collins II
 * @description Checks that a user has valid credentials.
 * ------------------------------------------------------ */
component extends="base" {
	property name="dependencies" default="app.cms.shared.image";
	property name="requiredOnCreate" type="struct" default="title";
	property name="requiredOnUpdate" type="struct" default="parent_id,title";
	property name="requiredOnDelete" type="struct" default="";
	property name="requiredOnRetrieve" type="struct" default="";
	property name="optionalOnCreate" type="struct" default="comments=0,draft=0,footer=0,previewimg=0";
	property name="optionalOnUpdate" type="struct" default="author='',comments=0,draft=0,footer=0,previewimg=0";
	property name="optionalOnDelete" type="struct" default="";
	property name="optionalOnRetrieve" type="struct" default="";

	function init( myst, model ) {
		Super.init( myst );

		//Check if anything even came through...
		if ( StructIsEmpty( form ) ) {
			return { status = false };
		}

		//Check if the user is valid or not
		if ( !components.cms.authorize() ) {
			return { status = false, message = "User name or password is invalid." }
		}

		return { status = true };
	}
}
