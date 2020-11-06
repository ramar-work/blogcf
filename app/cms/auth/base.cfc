component accessors=true extends="std.base.model" {
	function init( myst, model ) {
		Super.init( myst );
		//Redirect to login if the check fails...
		if ( !components.cms.checkUserToken() ) {
			location( addtoken=false, url="/cms/login" );
		}
	}
}
