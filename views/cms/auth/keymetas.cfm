<!---
	<div>
		<div class="container-section">
			<div class="input-group">
				<label class="input-member">Keywords</label> 
				<div>
					<input value="" class="input-member keywords" id=key name="keywords" type="text"></input>
					<ul>
					<cfloop query=#model.collection.keywords#>
						<li>#keyword_text#</li>
					</cfloop>
					</ul>
				</div>
			</div>

			<div class="input-group">
				<label class="input-member">Metas</label> 
				<div>
					<input value="" class="input-member metas" id=met name="metas" type="text"></input>	
					<ul>
					<cfloop query=#model.collection.metas#>
						<li>#meta_tag# - #meta_content#</li> 
					</cfloop>
					</ul>
				</div>
			</div>
		</div>
	</div>
--->

