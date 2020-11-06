component extends="base" name="summary" {
	property name="dependencies" default="app.cms.shared.collection.post";
	function init(myst, model) {
		Super.init( myst );
		var posts = post.summary( 5 ).results;  
		return {
			collection = {
				set = posts
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
