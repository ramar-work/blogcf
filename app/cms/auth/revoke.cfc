component name="revoke" extends="std.base.model" {
	void function init( myst, model ) {
		Super.init( myst );
		if ( components.cms.destroyUserSession() ) {
			location( addtoken=false, url="/cms/login" );
		}
	}
}
