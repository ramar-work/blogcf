component extends="std.base.model" {
	function init( myst, model ) {
		Super.init( myst );
		return components.cms.checkAuthorization();
	}
}
