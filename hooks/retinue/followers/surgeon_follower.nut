::Hardened.HooksMod.hook("scripts/retinue/followers/surgeon_follower", function(q) {
	// Public
	q.m.HD_RequiredTreatedInjuries <- 5;

	q.create = @(__original) function()
	{
		__original();

		this.m.Cost = 3000;		// Vanilla: 3500
		this.m.Effects.remove(1);	// We remove the entry about injuries taking one day less to heal
		// TODO make this a hoverable tooltip
		this.m.Effects.push("All recruits can now learn the Nine Lives perk.");
	}

	q.onBuildPerkTree = @(__original) { function onBuildPerkTree( _perkTree )
	{
		__original(_perkTree);
		// We remove it and add it so that it goes on the first tier
		if (_perkTree.hasPerk("perk.nine_lives"))
		{
			_perkTree.removePerk("perk.nine_lives");
		}
		_perkTree.addPerk("perk.nine_lives");
	}}.onBuildPerkTree;

	// Overwrite, because we change the condition the requirement text, and make it more moddable
	q.onEvaluate = @() function()
	{
		local injuriesTreated = 0;
		injuriesTreated += ::World.Statistics.getFlags().getAsInt("InjuriesTreatedAtTemple");	// This flag is incremented in Vanilla
		injuriesTreated += ::World.Statistics.getFlags().getAsInt("InjuriesTreatedWithBandage");	// This flag is incremented in Hardened

		injuriesTreated = ::Math.min(this.m.HD_RequiredTreatedInjuries, injuriesTreated);

		this.m.Requirements[0].Text = "Treated " + injuriesTreated + "/" + this.m.HD_RequiredTreatedInjuries + " Injuries with Bandages or at a Temple";
		if (injuriesTreated >= this.m.HD_RequiredTreatedInjuries)
		{
			this.m.Requirements[0].IsSatisfied = true;
		}
	}
});
