<div class="container">
	<cfoutput>
	<ul class="project">
		<cfloop from=1 to=3 index=w>
		<li>
			<div class="full">
				<div class="half">
					<h1>Project</h1>
					#lorem.generate(2)#
				</div>

				<div class="images">
					<ul>
					<cfloop array="#model.images#" index="n">
						<li><img src="#link('assets/img/examples/#n#')#"></li>
					</cfloop>
					</ul>
				</div>
			</div>
		</li>
		</cfloop>
	</ul>
	</cfoutput>
</div>
