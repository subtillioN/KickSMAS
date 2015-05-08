#KickSMAS - A SCALABLE MODULAR ARCHITECTURE (SMACSS) FOR SASS

This document presents preliminary ideas on the general organization (the file structuring, naming conventions, coding practices, philosophy etc.) for a Scalable Modular Architecture ("SMA" herein) using SASS.  It is roughly based on the SMACSS (SMA using CSS, pronounced "smacks") conceptual approach by Jonathan Snook, as fleshed out into a more detailed project management scheme called SMURF (Scalable, Modular, reUsable Rails Frontends) by Jakob Hilden.  However, to decouple from "Rails Frontends" because we are only using SASS, a bit of renaming is in order. Retaining Snook's core SMA, we can just call this little project-framework "SMA for SASS," or SMAS, and the SMAS project generater (forthcoming) we can call a "Kickstarter for SMAS," or just "Kick SMAS"!  ;)


##SMACSS/SMAS APPLICABILITY: CLASSITIS VS. HTML DECOUPLING

SMACSS was designed for managing large websites and web applications, such as Yahoo!.  As we will see below, it somewhat reverses a previous trend away from a dominant use of CSS classes and closer to what has been called "classitis."  Steve Workman describes an "easy" diagnosis as classitis a such [3]: "...the first sign is in the HTML. Look closely at each element, it may have a class attached to it. If it does, does the one above have the same one? If this repeats all over the page, you may have classitis. In the navigation of your site, do all the list items have the same class name? You may have classitis. The way to tell for sure is to dive into the CSS: If the styles are predominately classes (i.e. are ?.className?) with ancestor selectors being few and far between, then you have classitis."
	While projects like SMACSS and Twitter Bootstrap are somewhat reversing the trend away from strict avoidance of a dominance of class selectors, I don't believe they are falling into classitis.  In SMACSS, classes are used to their greatest strength, namely getting explicit with your styling (e.g. classes for CSS and IDs for JavaScript) and decoupling (to the extent possible) from the specifics of the changing HTML hierarchy and context.  While this is absolutely critical for large-scale projects such as Yahoo! where Snooks refined this approach, it may be less so for smaller projects.  So a balance between the use of classes and ancestor selectors will be based largely on project and module specifics such as scope, content, and perhaps the specifics of the CMS generating the HTML.  That being said, the example code herein will assume a project of a large enough scope to warrant a strict adherance to the SMACSS approach, but each project will vary and one can relax some of the organizational constraints as best fits the project at hand.


##SMAS OVERVIEW

The basic concept of Snook's SMACSS is to organize CSS styles into 5 categories: BASE, LAYOUT, MODULES, STATES, and THEMES.  Each category comes with a set of naming conventions and usage rules. In SMAS these categories are loaded and layered into the CSS cascade via a specific series of SASS imports in generally the same order as listed above.  And because the natural cascade of the SMACSS categories happens to be alphabetical, thus at a glance, in a tree-view in the terminal or finder (see directory structure below), or in a project-view in an IDE, the CSS cascade sequence and style dependency structure is quickly and easily observable at a global level, alphabetically from top to bottom: BASE --> LAYOUT --> MODULES --> STATES --> THEMES .... This makes it extremely easy to keep in sight (and in mind) which styles generally *could* override which others, and hence deal more readily with the inevitable issues of the increasing complexity of the CSS cascade as the project evolves.  Note that this resolves only the sequential aspect of the cascade, so you still have to take into account the selector weighting aspect and drill into greater selector specificity on occasion to oughtweigh a previously loaded selector.  SMAS also gives general guidelines and protocols for approaching the goal of a streamlined cascade where the rules do not override each other (except for those "retro" rules specifically designed to do so at the end of the cascade, such as STATES and THEMES, as we will see below).



##THE CORE SMAS CASCADE
At the core of the SMAS cascade are the three categories, BASE --> LAYOUT --> MODULES.  They flow forward generally in order from a tight (albeit ambient) coupling with the DOM at the BASE (via element and attribute selectors), to a general decoupling from the surrounding DOM hierarchy (ideally) at the level of the MODULES, via a focus on classes and a seperation of concerns. Because the ideal cascade should be organized, understood and controlled, the use of overriding styles (especially '!important') here in the core cascade, is a direct indication at this level of a sub-optimal SMAS cascade (ad hoc retrofitting to unforseen complexities in the development process, generally, and often unavoidably). The cascade *should* flow organically forward through these levels of the SMAS organization, and such an attempt at optimal flow is the key function of the SMAS structuring of the CSS cascade.

###BASE:
BASE styles prepare the ground of the CSS cascade.  They are defaults such as general styles, CSS resets, colors, fonts, variables, functions and other SASS helpers.  Because BASE styles directly prepare the SASS/CSS interface and ground of the DOM for the more decoupled MODULES to come, selecters at this level in the SMAS cascade are generally DOM-centric (as opposed to custom classes or ids), such as element or attribute selectors (as in CSS resets and global styles).  This coupling of the BASE level to the DOM is in direct opposition to the MODULE level of the cascade where DOM-centric selectors are kept to a minimum so as to reduce module dependency on the changing specifics of the HTML structure.

###LAYOUT:
On top of the BASE level, LAYOUT styles then lay out the foundation for the site structure and provide spatial orientation for the MODULES.  LAYOUT, naturally, is where we find the styles for dividing and positioning the page into spatial locations, general divisions into which the more specific MODULES and other elements can be placed, loosely coupled from the surrounding HTML hierarchy.  This includes grid systems, some responsive break-point logic, and the spatial (and temporal) logic for positioning the domains required for headers, footers, sections, and so forth.

###MODULES:
The MODULE level in the SMAS cascade takes advantage of the prepared and coupled ground of the BASE level, and the structural foundations and hooks at the LAYOUT level (generally class selectors), allowing the modules themselves to become largely decoupled from the surrounding HTML/DOM element hierarchy.  The bulk of the styles in any flexible project should be coded as these reusable MODULES. The MODULES connect to the DOM typically only through key hooks via *class* selectors tying their shallow class hierarchies (ideally) to the DOM structure at one simple and explicit point per module (and for each subcomponent, submodule, or modifier).  In reality, that's not *always* the best, or even an *available* form of hooking into the DOM, but in general class selectors are preferred over ID, element, or attribute selectors because the coupling with the DOM via classes is specific, CSS-explicit (semantic, because we know exactly what classes are for), and content-independent, or relatively decoupled from the surrounding DOM hierarchy.  So the use of DOM-based selectors, such as we find predominately in the BASE level, should be minimized at the MODULES level of the SMAS cascade.

###NON-MODULAR:
Because it does not always make sense to write SASS code as distinct SMAS modules, and to keep the MODULES category clean, SMURF introduced a catch-all category for other styles: NON-MODULAR. These styles may be in progress towards MODULE-status, or perhaps not.  Maybe they are just difficult to categorize and modularize, such as styles for "cross-cutting concerns".*  Or who knows.  Regardless, the idea here is that all styles that cannot be considered actual SMAS modules (or any of the other SMAS categories) belong in NON-MODULAR.  NON-MODULAR comes at the end of the SMAS Cascade because the code here is generally an after-thought.  And already not fitting into the optimal flow, this code would be more likely in need of overriding prior portions of the cascade.  A good rule of thumb may be that (1) if the style is not a STATE (or otherwise part of the RETRO-CASCADE meta-category, see below), and (2) if it has to override prior styles as part of the Core Cascade, and (3) if it cannot otherwise be worked into the optimal forward flow, then it should go here, in NON-MODULAR.  Otherwise, again, the only styles *within* the Core Cascade (which excludes THEMES) that should be overriding prior styles are STATES, which are generally found in or near their respective styles, most often in MODULES, but sometimes in LAYOUT or BASE.



##THE "RETRO-CASCADE" OF THE OVERRIDING CATEGORIES
Both STATES and THEMES share the characteristic that they are designed to override, retro-fit, or "retro-cascade", in effect reaching back into the the prior layers of the organic forward unfolding of the optimum SMAS cascade.  In this sense, they can be loosely considered a single "retro-cascade" category, distinguished mainly by scale or scope of their concerns.  STATES *could* be considered micro-THEMES applied as overriding overlays to elements or modules.  And THEMES *could* be considered macro-STATES applied as overriding layers to the site or page as a whole (or large portions thereof).  This re-styling, retro-cascade action of the SMAS cascade at this level, however, is deliberate, based on application specifics, such as user input or localizing variables and application context.  So at this level in the SMAS layers, overriding is common, and even the use of '!important' is OK, if need be.

###STATES:
STATES are styles whose function it is to change the appearance of DOM elements LAYOUT containers or MODULES based on user interaction.  These include: class-based states (.is-hidden), pseudo-classes (:hover, :focus) attribute states (data-state="transitioning"), or @media query states.  These states are generally better organized within or near their respective MODULES, using the STATE naming convention for the classes where applicable, discussed below.  They are a separate category because they have their own naming convention and usage rules.  But because STATES generally operate at a sub-modular level, they do not (typically) have their own directory/layer in the SMAS cascade.

###THEMES:
THEMES are generally the icing on the SMAS cascade layer-cake. They are global overlays overriding the styles of the previous layers of the cascade, giving special-case styling for state-like aspects of application or page *context*, like user-preferences or localization.  However, because THEMES are not often used in most sites, and because theming in SASS is often easier under the hood using variables and such, it will not be included in the default project category structure, but can be added following the general logic here. Conversely, THEMES could simply be placed in the 'non-modular' (catch-all and sketch-up) category (directory structure below).


##A QUICK OVERVIEW OF THE SMAS CASCADE

CORE SMAS CASCADE  	(optimal forward/downward flow, no overrides... ideally)
	+ BASE          ...	(use DOM-coupled selectors, e.g. elements and attributes. Can contain STATES)
	+ LAYOUT        ...	(generally use DOM-decoupled classes. Can contain STATES)
	+ MODULES    	...	(use DOM-decoupled classes. Will contain most STATES)
    + NON-MODULAR 	...	(should contain all the Core Cascade styles doing the overrides, other than STATES in MODULES)
RETRO-CASCADE  		(generally use overrides as a function of application specifics, such as user details or input)
	+ STATES        ...
	+ THEMES        ...



##SASS DIRECTORY FILE STRUCTURE AND CASCADE LAYERS
The SASS directory structure for SMAS is based on the SMURF approach, and (as discussed above) because the categories are themselves ordered alphabetically in terms of the SMAS Cascade, this makes it very easy to see, with a simple glance at the directory structure, which SASS styles may get over-ridden by which others (selector specificity weighting aside).  The deeper level cascade, at the level of the sub-SMAS partials, however, deviates from SMURF and is determined by the @import sequence *within* the SMA-based partials ("SMAS-partials" herein) per category/directory (see below).  This gives the engineer explicit control of the cascade sequence at all levels.  Note that if your MODULES are properly designed and decoupled, the sequence of imports shouldn't matter.
	The SASS project structure is as follows.  Each directory is generated from a SMA category.  The exceptions to this rule are the retro-cascading STATES and THEMES categories, for reasons discussed above.  Within each of the SMAS directories is a corresponding main SMAS-partial of the same name, prefixed by a double underscore, such as __base.scss, __layout.scss, __modules.scss etc.  These main SMAS files are imported directly by the main app.scss file, and their responsibilities are:
	(A) When there are other (sub-SMAS) partials in the directory (such as we see in 'base/', with e.g. '_colors.scss') the main SMAS-partials (such as __base.scss in this case) are *solely* responsible for loading and cascading the sub-SMAS partials in their respective SMAS directory.  So, for example, app.scss @imports __base.scss (and _layout.scss etc...), whereas __base.scss imports _colors.scss, _element_defaults.scss, and so on.
	(B) Otherwise, when these SMAS-partials are the only files in the directory (such as we see with __modules.scss, in this example), the SMAS partial would contain and sequence the styles instead of only the @imports.

The following is an example directory structure similar to what you might see in tree view in Terminal (with annotations) to show how easy it is to visually keep track the flow of the cascade in SMAS (at least at the SMAS directory level).


* sass
  - app.scss                     // Root SASS file, @imports SMAS-partials, organizing the SMAS Cascade
* base/                         // (1) DOM-coupling, preparing CSS ground
  - __base.scss           	 // SMAS-partial: imports and cascades the BASE files
  - _colors.scss
  - _element_defaults.scss	 // sets the basic element/attribute styles of the site
  - _fonts.scss
  - _helpers.scss            // SASS functions, base-level mixins, etc.
  - _normalize.scss
  - _settings.scss           // Settings files are generally loaded first, at the sub-SMACSS level.
* layout/                       // (2) Laying out foundations
  - __layout.scss         	 // SMAS-partial: imports and cascades the LAYOUT files
  - _containers.scss
  - _grid.scss               // Example LAYOUT file
  - _l-settings.scss         // Settings files are generally loaded first, at the sub-SMACSS level.
* modules/                      // (3) DOM-decoupled
  - __modules.scss           // SMAS-partial: imports and cascades the MODULES files
* non-modular/                  // (4) Cascade-decoupled, overrides OK, e.g. with states in general
  - __non-modular.scss       // SMAS-partial: imports and cascades the NON-SMACSS files
  - _aspects.scss            // example categorization of non-modular rules in AOP terms
  - _states.scss             // if need be, STATES can be placed here
  - _themes.scss             // if need be, THEMES can be placed here
* style-guide.txt              // Living style-guide to maintain the SMAS structure



**A BRIEF NOTE ON PAGES**

If a more page-specific structure is required, the app.scss file could be renamed e.g. 'page1.scss' or 'home.scss' with a corresponding suffix appended to the required (and multiplied) SMAS partials, such as 'layout/__layout-home.scss' and 'modules/__modules-home.scss' for page-level @import.



##NAMING CONVENTIONS AND CODING PRACTICES

###STYLE-GUIDE:
In the effort to reinforce the best practices for a SMAS project, a "living" style-guide should be present, perhaps in the SASS directory, with updated naming conventions and coding practices (whatever those happen to be) on a per-project basis. This would quickly allow the developers to get up to speed on the SMAS organizational conventions used in the project and help to maintain the SMAS project integrity throughout its life-cycle.

###FILES/PARTIALS:
As discussed above, the names of the files responsible for the cascade within each SMAS category (the SMAS-partials) are designated with a double-underscore, such as '__base.scss'.  This is the only SASS file naming rule to follow.  Other than this, it may be common to load a 'settings' partial first before whatever other partials may be loaded into the sub-SMAS cascade. Also, (obviously) THEME partials likely would be prefixed or otherwise contain the word 'theme', and may reside in the 'non-modular' or a 'themes' directory.

###A NOTE ON IDS:
As mentioned briefly above, in order to maintain a clear seperation of concerns between javascript and CSS, and for maximum MODULE flexibility, IDs are generally not to be used for styling, and only to be used for javascript.

###A NOTE ON SELECTORS:
The general class selector naming and coding conventions below are abstracted from Hilden's SMURF documentation.[2]  He lists the advantages to these conventions as such.
	+ you can learn something about a selector's semantics just by looking at its naming convention
	+ styles have a more well-defined (single) responsibility
	+ you make sure that styles only apply where they should
	+ you can suddenly safely and comprehensibly share and inherit styles to DRY up your CSS and improve maintainability

###BASE:
**Selectors**: DOM-based, elements, attributes, etc
	
As discussed above, because the BASE level is tightly coupled to the DOM, BASE selectors are generally just element and attribute selectors, such as in resets or general themes.

###LAYOUT:
**Selectors**: 	class-based (ideally), prefixed with 'l-', e.g. '.l-single-centered-column'

LAYOUT selectors could be pretty much anything, but, moving into greater decoupling from the DOM, selectors here typically and ideally would be classes. These class names should be prefixed with 'l-'.

###MODULE:
**Module Selectors**: class-based, prefixed with 'm-', e.g. '.m-box', or '.m-panel'.

**Components**: Parts of the MODULE.  When descendent selectors are not applicable, such as '& > li ', component selectors
    				begin with the MODULE name and are followed by "--" followed by component functional descriptor, e.g.
    				'.m-box--header' or .m-box--body
    				
**Submodules**: Significant variations of the MODULE.  Selector names for the submodules often begin with the MODULE name
	 				and are followed by '_' and then a descriptor of variation, e.g. '.m-box_sidebar', meaning ".m-box
	 				styled for the sidebar."
	 				
**Modifiers**: Slight variations of the MODULE.  Selector names for the modifiers begin with the MODULE name and are
     				followed by a '.' and then a descriptor of what's different with the modified version of the module
     				e.g. '.m-box.no-border,' meaning "an m-box with no border."

###A NOTE ON EXTENDING MODULES:
As discussed in Hilden's SMURF documentation[2], and as commonly known in the SASS community, there are potential issues arising from uncareful usage of SASS's @extend directive, which can multiply selectors out of hand when the structure and hierarchy gets too complex (another reason why hierarchies should be kept as flat as possible).  This problem with using the @extend directive can easily bring a SASS compile to its knees if not tightly controlled.  This happens mostly when extending across module domains, such as when an '.m-form--submit' button module extends an '.m-button' module.  And it is commonly understood that using the @mixin directive quickly generates repetition in the CSS and unnecessary bloat (violating DRY, Don't Repeat Yourself), so @mixin is no DRY solution for modularity functionality either. To get around this, SMURF originally provided a hard and fast rule, "Never @extend across modules!".  But fortunately, with SASS 3.2 that all changed, so the rule becomes more of a watch-point to be careful of, as we will see below.
	For more adaptable extension and modularity in SMURF, Hilden discusses the use of the "placeholder selector," which uses '%'.  The function of the placeholder selector is to create an "extend only" style, so in order for it to appear in the CSS the style *must* be extended.  Conveniently, extending only placeholders *designed* for extending, eliminates the problems with extending across module lines.

Here's an example from Hilden's SMURF documentation (adapted for our purposes) of a module with all of these rules and class hooks in place, including cross-module extension, '.m-form--submit' @extending '%m-button_attention':


	// button module declaration
	// placeholder selector which won't be compiled to CSS but can be @extended
	%m-button {
	  border: 1px solid black;
	}

	// button module instantiation
	// .m-button no longer defines any properties but @extends the placeholder selector
	.m-button {
	  @extend %m-button;
	}

	// modifier declaration
	%m-button.no-border {
	  border-style: none;
    }

	// modifier instantiation
	.m-button.no-border {
	  @extend %m-button.no-border;
    }

	// submodule declaration
	%m-button_attention {
	  @extend %m-button;
	  border-color: red;
    }

	// submodule instantiation
	.m-button_attention {
	  @extend %m-button_attention;
    }

	// form module, reusing styles from button module
	.m-form {
	  .m-form--submit {  // component
		@extend %m-button_attention;
		float: right;
	  }
    }

	// m-button module also used as a selector in a different context
	.l-sidebar {
	  .m-button {
		border-color: green;
	  }
    }

Largely decoupled from the surrounding DOM hierarchy at this stage of the SMAS cascade, MODULES would (ideally) be hooked to the DOM very loosely with class selectors for MODULE, component, submodule and modifier etc, as shown above.  In practice, however, there may often be a few element and attribute modifiers in the MODULE selector hierarchy.

###A NOTE ON SASS HIERARCHY:
Although in general it's best to limit SASS/CSS hierarchies to as flat a state as possible, and nesting isn't necessary, it does help with the logical grouping and hence the readability of the SASS files and module structures.  So Hilden discovered that (for him) it makes sense to group the submodules, modifiers, and components within the module selector.  This decision should be made on a project and module basis, however, so long as hierarchy depth is kept at a mininum.


###STATE:
**Selectors**: 	class-based (ideally), pre- or mid-fixed with '.is-', e.g. '.is-selected' or '.m-box.is-hidden'
				Also things like pseudo-classes.

STATE selectors are generally found within or near to their respective styles, such as the following.  Note the continuation of the SMAS organization at the sub-MODULE level:

	// -- module --
    .m-box {
      @extend %m-box;

      // components
      .m-box--header {...}

      .m-box--body {...}

      // modifiers
      &.no-border {
        border: none;
      }

      &.right {
        float: right;
      }

      // states
      &.is-disabled {
        background-color: #ccc;
      }
    }


###THEMES:
For inclusiveness I'm putting this final category here mostly as a place-holder.  In general, themes, being retro-cascade stylings, would span the gamut of selectors, depending on what needs theming.



##NOTES

*[[I was tempted to call this NON-MODULAR category ASPECTS, as in Aspect Oriented Programming, where instead of objects (or modules) there are "aspects" which slice across the object heirarchy (the cascade and module level) and address less coherent or "harder to understand" "concerns."  But perhaps that's a bit confining a term, so I think I will keep it as NON-MODULAR.  But perhaps it may suit the project or code to introduce aspects as a NON-MODULAR partial.  Also, calling it ASPECTS upsets the convenient and lovely alphabetic category and SMAS directory ordering visually mirroring the SMAS cascade, see below.]]


##REFERENCES

[1] SMACSS: http://smacss.com/

[2] SMURF: http://railslove.com/blog/2012/03/28/smacss-and-sass-the-future-of-stylesheets
http://railslove.com/blog/2012/11/09/taking-sass-to-the-next-level-with-smurf-and-extend
http://vimeo.com/51903907

[3] Steve Workman on "classitis": http://www.steveworkman.com/html5-2/standards/2009/classitis-the-new-css-disease/