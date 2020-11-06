/* ------------------------------------------------------ *
 * post.cfc
 * --------
 * 
 * A post is a collection of nodes.  The presentation can be
 * completely different based on the way the CMS is configured.
 * 
 * All CMS installs come with post.cfc as a default collection.
 * 
 * TODO: Hash a version of the title, and make this the unique id
 * Or rely on that other thing...
 * ------------------------------------------------------ */
component extends="app.cms.shared.collection" name="post" {
	function init( myst, model ) {
		Super.init( myst );
		table = "cms_collection";
		return this;
	}
}
