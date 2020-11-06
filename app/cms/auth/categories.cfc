component accessors=true extends="base" {
	property name="dependencies" type="list" default="app.cms.shared.category";
	function init( myst, model ) {
		Super.init(myst);
		return {
			categories = category.all().results
		};
	}
}
