<cfscript>

//Get published posts...
model = cms.qGetSummary();
//writedump( model );abort;

/*
//Loop through all of the posts.
model = {
	summary = QueryNew(
		"content_type_i,post_long_id,post_id,post_date_added,post_name,content_text,featured_image"
	, "integer,varchar,varchar,varchar,varchar,varchar,varchar"
	, [
	{
		content_type_i=2
	 ,post_long_id=0
	 ,post_id=0
	 ,post_date_added="2017-08-23"
	 ,post_name="Work"
	 ,content_text=lorem.generate(2,2)
	 ,featured_image=link( 'assets/img/cms/suzuki_swift.jpg' )
	}
	,{
		content_type_i=2
	 ,post_long_id=1
	 ,post_id=1
	 ,post_date_added="2017-09-11"
	 ,post_name="The Thing"
	 ,content_text=lorem.generate(4,1)
	 ,featured_image=link( 'assets/img/cms/suzuki_swift.jpg' )
	}
		]
	)
}
*/

</cfscript>
