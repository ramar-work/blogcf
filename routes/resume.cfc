component name="resume" extends="base" {
	function init( myst, model ) {
		Super.init( myst );
		return {
		  "resume.pdf" = {
				model = function( myst, model ) {
					Super.init( myst );
					var path = "files/Resume.pdf";
					return myst.serveStaticResource([], path, "File not found.");
				}
			}
		}
	}

}

