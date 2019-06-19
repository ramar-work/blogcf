<div class="container">
	<div class="projects">
	<cfoutput>
	<ul class="project">
		<cfloop from=1 to=3 index=w>
		<li>
			<div class="full">
				<div class="half">
					<h1>Project</h1>
					#lorem.generate(2)#
					<div class="container-full"></div>
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
</div>
