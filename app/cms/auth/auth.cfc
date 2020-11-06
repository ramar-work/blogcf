/* ------------------------------------------------------ *
 * auth.cfc
 *
 * @author Antonio R. Collins II (ramar@collinsdesign.net)
 * @description Authentication for HTML interface.
 * ------------------------------------------------------ */
component name="auth" extends="std.base.model" {
	void function init( myst, model ) {
		Super.init( myst );

		//Check if form variables came through
		if ( StructIsEmpty( form ) ) {
			location( addtoken=false, url="/cms/login" );
		}

		//Check if the user exists and if the password is right...
		if ( !(auth = components.cms.checkAuthorization()).status ) {
			//password incorrect on server side, return home?
			location( addtoken=false, url="/cms/login" );
		}

		//...
		if ( !components.cms.createUserSession( form.username ) ) {
			//for some reason the session didn't start... reason should probably go here...
			location( addtoken=false, url="/cms/login" );
		} 
		
		//redirect to */cms/list	
		location( addtoken=false, url="/cms/posts" );
	}
}


