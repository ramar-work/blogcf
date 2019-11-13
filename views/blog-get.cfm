<div class="middle blog">
<cfoutput>
	<h2 style="font-size:3em">#model.post_name#</h2>

	<cfloop query = model>
	<cfif #content_type_i# eq cms.getConstText()>
		<p>#content_text#</p>
	<cfelseif #content_type_i# eq cms.getConstAudio()>
		<audio class="regular" src="#link("admin/files/#content_text#")#"></audio>
	<cfelseif #content_type_i# eq cms.getConstImage()>
		<img class="regular" src="#link("admin/files/#content_text#")#"></img>
	<cfelseif #content_type_i# eq cms.getConstVideo()>
		<video controls class="regular" 
			src="#link("admin/files/#content_text#")#">
		</video>
	<cfelse>
	</cfif>
	</cfloop>

	<div id="disqus_thread"></div>
	<script>
	var disqus_config = function () {
		this.page.url = "http://ramarcollins.com/get.cfm?id=#model.post_id#";  // Replace PAGE_URL with your page's canonical URL variable
		this.page.identifier = "#model.post_long_id#"; // Replace PAGE_IDENTIFIER with your page's unique identifier variable
		};
		(function() { // DON'T EDIT BELOW THIS LINE
		var d = document, s = d.createElement('script');
		s.src = 'https://ramarcollinscom.disqus.com/embed.js';
		s.setAttribute('data-timestamp', +new Date());
		(d.head || d.body).appendChild(s);
	})();
	</script>
	<noscript>Please enable JavaScript to view the <a href="https://disqus.com/?ref_noscript">comments powered by Disqus.</a></noscript>
															
	</div>

</cfoutput>
</div>
