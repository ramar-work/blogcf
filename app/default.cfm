<cfscript>
model = {
	images = DirectoryList( "#getRootDir()#assets/img/examples", false, 'name' )
};
//writedump(model.images); abort;
</cfscript>
