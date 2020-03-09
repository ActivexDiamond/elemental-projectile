--[[

TODO: add all classes to a template similar to love's.
	Usage:
		local IHealth = act.beahvior.IHealth
		-- the rest is the same.
	Pros:
		- Far less keystrokes to include class.
			No require ""
			Auto-completion is available.
		- First-time requiring of all modules would always happen in a predictable order.
	Debate:
		Disallow direct usage of act.package.class?
			Allow it only for utils/libs?
			Allow it only in class-headers?
				local WorldObj = act.libs.class("WorldObj", act.template.Thing):include(act.behavior.IBoundingBox)
				local WorldObj = class("WorldObj", Thing):include(IBoundingBox)
			Allow it everywhere?

TODO: do a proper logging system
TODO: move most highly-generic helper functions here
--]]

utils = require "libs.misc"
utils.t = require "libs.tables"



