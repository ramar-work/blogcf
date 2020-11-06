/* ------------------------------------------------------ *
 * assets.cfc
 *
 * @author Antonio R. Collins II (ramar@collinsdesign.net)
 * @description Returns paths to static assets... 
 * ------------------------------------------------------ */
component name="assets" extends="std.base.model" {

	private array function initializeCss( boolean isLogin ) {
		var css = [];
		for ( var file in components.cms.getCssFilelist() ) {
			ArrayAppend( css, components.cms.getAssetPath( 'css', "#file#.css" ) )	
		}
		if ( arguments.isLogin ) {
			ArrayAppend( css, components.cms.getAssetPath( 'css', "login.css" ) )	
		}
		return css;
	}


	private array function generateNavigation ( ) {
		var arr = [];
		for ( var n in [ "Settings", "Categories", "Users" ] ) {
			ArrayAppend( arr, { name = n, href = components.cms.getPublicPath(LCase(n)) } );	
		}
		for ( var n in components.cms.getCollections() ) {
			ArrayAppend( arr, { name = "#n#s", href = components.cms.getPublicPath(LCase("#n#s")) } );	
		}
		return arr;
	}


	function init( myst, model ) {
		Super.init( myst );	
		return {
		base = {
			cssfilelist = initializeCss( route.active eq "login" ) 
		, jsfilelist = [ components.cms.getAssetPath( "js", "cms.js" ) ]
		, logo = components.cms.getAssetPath( "img", "simplelogo.png" )
		, profile = components.cms.getAssetPath( "img", "aeon-thumb.jpg" )
		, debug = components.cms.getDebug()
		, navigation = generateNavigation()
		, title = components.cms.getAdminTitle()

		, href = {
				authenticate = components.cms.getPublicPath( 'authenticate' )
			,	edit = components.cms.getPublicPath( 'posts/edit' )
			,	list = components.cms.getPublicPath( 'list' )
			,	"new" = components.cms.getPublicPath( 'posts/new' )
			}
		}
		}
	}
}
