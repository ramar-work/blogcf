component extends="base" name="single" {
	property name="dependencies" default="app.cms.shared.collection.post";
	property name="UUIDColumnName" type="string" default="category_uuid";
	property name="IDColumnName" type="string" default="category_id";

	function init(myst, model) {
		Super.init( myst );
		var post = post.single( lid = route.active ).results;  
		return {
			collection = {
				author = "#post.author_fname# #post.author_lname#"
			, date = DateFormat( post.datemod, "yyyy/m/dd" )
			, set = post
			, title = post.title
			, types = {
					text = components.cms.getConstText()
				, audio = components.cms.getConstAudio()
				, image = components.cms.getConstImage()
				, video = components.cms.getConstVideo()
				}
			}
		}
	}
}
