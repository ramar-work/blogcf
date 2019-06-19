<div class="container">
	<div class="middle blog">
	<cfoutput>
	<cfloop query="#model.summary#">
		<div class="post">
			<div class="featured-image">
				<img src="#featured_image#">
			</div>
			
			<!--- Content Preview --->
			<cfif #content_type_i# eq cms.getConstText()>
				<h2><a href="#link("get.cfm?id=#post_long_id#")#">#post_name#</a></h2>
				<div class="time">
					Posted on <span>#DateFormat( post_date_added, "mmmm d, yyyy" )#</span>
				</div>
				<p>#content_text#</p>
			<cfelseif #content_type_i# eq cms.getConstAudio()>
				<audio class="regular" src="#link("admin/files/#content_text#")#"></audio>
			<cfelseif #content_type_i# eq cms.getConstImage()>
				<img class="regular" src="#link("admin/files/#content_text#")#"></img>
			<cfelseif #content_type_i# eq cms.getConstVideo()>
				<video controls class="regular" src="#link("admin/files/#content_text#")#"></video>
			<cfelse>
			</cfif>

			<a class="comments" href="">20 Comments</a>
		</div>	
	</cfloop>
	</cfoutput>
	</div>
</div>
