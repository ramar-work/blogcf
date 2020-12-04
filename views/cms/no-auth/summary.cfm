<!--- summary.cfm --->
<div class="collection summary">
<cfoutput>
<cfloop query=model.collection.set>
	<div class="content-regular">
		<div class="content-regular-header"></div>
	<cfif #content_type_i# eq model.collection.types.text>
		<div class="featured-image">
		</div>
		<h2><a href="#link("blog/#collection_long_id#")#">#collection_name#</a></h2>
		<div class="time">
			Posted on <span>#DateFormat( collection_date_added, "mmmm d, yyyy" )#</span>
		</div>
		<p>#content_text#</p>
	<cfelseif #content_type_i# eq model.collection.types.audio>
		<audio controls src="#content_text#">
			Your browser does not support HTML5 audio.
		</audio>
	<cfelseif #content_type_i# eq model.collection.types.image>
		<img src="#content_text#">
	<cfelseif #content_type_i# eq model.collection.types.video>
		<video controls src="#content_text#">
			Your browser does not support HTML5 video.
		</video>
	<cfelse>
		<a href="#content_text#">#content_text#</a>
	</cfif>
		<a class="comments" href="#link("blog/#collection_long_id#")#">Click to Read More</a>
		<!--- <a class="comments" href="">xx Comments</a> --->
	</div>
</cfloop>
</cfoutput>
</div>
