<cfscript>
var dirs = DirectoryList( 
	"#getRootDir()#files/projects", false, 'name', "", "", "dir"
);


//Do another for, because recursing sucks...
model = {};
for ( var d in dirs ) {
	var files = DirectoryList( getRootDir() & "files/projects/#d#", true, 'query', "", "", "file" );
	var xx = dbExec( qq=files, string="select name from _mem_ where name = 'SKIP'"  );
	//Skip
	if ( !xx.prefix.recordCount ) {
		model[ d ] = {};	
		var t = model[d];	
		t.title = d; 
		//The description since I have to read it
		t.description = FileRead( "#getRootDir()#files/projects/#d#/description.html" );
		//The link since I also have to read it 
		t.link = FileRead( "#getRootDir()#files/projects/#d#/link" );
		//The logo (preferably in vector format so it resizes)
		t.logo = "files/projects/#d#/logo.png";
		//Get images by selecting on paths that end with screenshots
		var ii = dbExec( 
			qq=files
		, string="select name as iname, directory from _mem_ where directory LIKE '%screenshots'"  
		);
		t.images = ii.results;
	}
}
</cfscript>
