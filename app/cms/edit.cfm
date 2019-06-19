<cfscript>
//...
if ( !StructKeyExists( url, "post_id" ) ) 
	location( url=link( "list.cfm" ), addToken="no" );	
else {
	model = {
	  edit = 1
	, metas = QueryNew( "tagname", "varchar" )
	, parent_id = url.post_id 
	, postContent = cms.qGetSinglePost( url.post_id )
	, contentMessage = "Continue editing your content here."
	};
}

//writedump(model.postContent);abort;
</cfscript>
