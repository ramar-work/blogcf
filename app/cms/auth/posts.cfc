component name="posts" extends="base" {
	property name="dependencies" 
		default="app.cms.shared.collection.post,app.cms.shared.meta,app.cms.shared.keyword,app.cms.shared.user,app.cms.shared.category";
	//property name="dependencyBaseDir" default="app.cms.shared";
	//property name="dependencies" default="post,meta,keyword,user,category";
	function init( myst, model ) {
		Super.init( myst );
		if ( route.active eq "posts" )
			return { collection = post.all().results };
		else {
			var post_i = post.single( lid = route.active ).results;
			return {
				collection = {
					categories = category.matching( post_i.pid ).results
				, edit = ( route.active neq "new" ) 
				//, fimage = node.matching( route.active, -1 ).results
				, keywords = keyword.matching( route.active ).results
				, message = "Drag files here."
				, metas = meta.standard()
				, navigation = [
						{ name = "/", href = "##" }
					, { name = "metadata", href = "##metadata" }
					, { name = "technical", href = "##technical" }
					, { name = "SEO", href = "##seo" }
					, { name = "content", href = "##content" }
					]
				, post = post_i
				, types = {
						text = components.cms.getConstText()
					, audio = components.cms.getConstAudio()
					, image = components.cms.getConstImage()
					, video = components.cms.getConstVideo()
					}
				, owner = user.single( post_i.author_uuid )
				, users = user.all()
				}
			};
		}
	}
}
