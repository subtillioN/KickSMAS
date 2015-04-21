
BASE:
 Selectors: DOM-based, elements, attributes, etc

 LAYOUT:
 Selectors: class-based (ideally), prefixed with 'l-', e.g. '.l-single-centered-column'

 MODULE:
 Module Selectors: class-based, prefixed with 'm-', e.g. '.m-box', or '.m-panel'.

 	Components: Parts of the MODULE. When descendent selectors are not applicable, such as '& > li ', 
 		component selectors begin with the MODULE name and are followed by "--" followed by component 
 		functional descriptor, e.g. '.m-box--header' or .m-box--body.

 	Submodules: Significant variations of the MODULE. Selector names for the submodules often begin 
 		with the MODULE name and are followed by '_' and then a descriptor of variation, e.g. '.m-box_sidebar', 
 		meaning ".m-box styled for the sidebar."

 	Modifiers: Slight variations of the MODULE. Selector names for the modifiers begin with the MODULE name 
 		and are followed by a '.' and then a descriptor of what's different with the modified version of the 
 		module e.g. '.m-box.no-border,' meaning "an m-box with no border." 

 A NOTE ON EXTENDING MODULES:
 For more adaptable extension and modularity use of the "placeholder selector," which uses '%'. The function of the placeholder selector is to create an "extend only" style, so in order for it to appear in the CSS the style *must* be extended. Conveniently, extending only placeholders *designed* for extending, eliminates the problems with extending across module lines.

 Example documentation:

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
 		.m-form--submit {	// component
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


 STATE:
 Selectors: class-based (ideally), pre- or mid-fixed with '.is-', e.g. '.is-selected' or '.m-box.is-hidden' Also things like pseudo-classes.

 STATE selectors are generally found within or near to their respective styles, such as the following. Note the continuation of the SMAS organization at the sub-MODULE level:

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
