component name="settings" extends="base" {
	property name="dependencies" default="app.cms.shared.settings";
	function init( myst, model ) {
		Super.init( myst );	
		return {
			settings = settings.all()
		};
	}
}
