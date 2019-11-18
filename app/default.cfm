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
		var basepath = getRootDir() & "files/projects/#d#/";
		t.title = d; 
		t.description = "";
		t.link = "/";
		t.logo = "";
		if ( FileExists( basepath & "description.html" ) ) 
			t.description = FileRead( basepath & "description.html" );
		if ( FileExists( basepath & "link" ) ) 
			t.link = FileRead( basepath & "link" );
		if ( FileExists( basepath & "logo.png" ) ) 
			t.logo = "/files/projects/#d#/" & "logo.png";
		//Get images by selecting on paths that end with screenshots
		var ii = dbExec( 
			qq=files
		, string="select name as iname, directory from _mem_ where directory LIKE '%screenshots'"  
		);
		t.images = ii.results;
	}
}
//writedump( model );abort;
</cfscript>
