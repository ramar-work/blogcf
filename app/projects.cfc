component name="projects" extends="std.base.model" {
	private string function stripLast( required string filename ) {
		return RemoveChars( filename, Len(filename) - 1, 1 );
	}

	private string function cutNewLine( required string filename ) {
		return Replace( filename, Chr(10), "" );
	}

	function init( myst, model ) {
		Super.init( myst );
		var rootdir = myst.getRootDir();
		var projdir = "assets/projects";
		var dirs = DirectoryList( "#rootdir##projdir#", false, 'name', "", "", "dir" );
		var records = [];

		//Do another for, because recursing sucks...
		for ( var d in dirs ) {
			var files = DirectoryList( "#rootdir##projdir#/#d#", true, 'query', "", "", "file" );
			var xx = myst.dbExec( query=files, string="select name from _mem_ where name = 'SKIP'"  );
			//Skip
			if ( xx.prefix.recordCount == 0 ) {
				var t = { title=d, description="", link="/", logo="", tech="", images=[] };
				var basepath = "#rootdir#/#projdir#/#d#/";
				if ( FileExists( basepath & "description.html" ) ) 
					t.description = FileRead( basepath & "description.html" );
				if ( FileExists( basepath & "link" ) ) 
					t.link = FileRead( basepath & "link" );
				if ( FileExists( basepath & "background" ) ) 
					t.background = cutNewLine( FileRead( basepath & "background" ) );
				if ( FileExists( basepath & "logo.png" ) ) 
					t.logo = "/#projdir#/#d#/" & "logo.png";
				if ( FileExists( basepath & "tech" ) ) 
					t.tech = FileRead( "/#projdir#/#d#/" & "tech" );
				if ( FileExists( basepath & "title" ) ) 
					t.name = FileRead( "/#projdir#/#d#/" & "title" );
				if ( FileExists( basepath & "adjust" ) ) 
					t.adjust = FileRead( "/#projdir#/#d#/" & "adjust" );
				if ( FileExists( basepath & "github" ) ) 
					t.github = FileRead( "/#projdir#/#d#/" & "github" );
				//Get images by selecting on paths that end with screenshots
				var ii = myst.dbExec( 
					query=files
				, string="select name as iname, directory from _mem_ where directory LIKE '%screenshots'"  
				);
				//Format these from here
				for ( var img in ii.results ) {
					ArrayAppend( t.images, myst.link( '#projdir#/#t.title#/screenshots/#img.iname#' ) );
				}
				ArrayAppend( records, t );
			}
		}
		return records;
	}
}
