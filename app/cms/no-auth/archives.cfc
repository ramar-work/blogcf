/* ------------------------------------------------------ *
 * archives.cfc
 * ------------
 * 
 * @author
 * Antonio R. Collins II (ramar@collinsdesign.net)
 *
 * @summary
 * Archives page.
 * 
 * @todo
 * ...
 * ------------------------------------------------------ */
component extends="base" name="archives" {
	property name="dependencies" default="app.cms.shared.collection.post";
	property name="UUIDColumnName" type="string" default="category_uuid";
	property name="IDColumnName" type="string" default="category_id";

	function init(myst, model) {
		Super.init( myst );
		var posts = post.published().results;
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
