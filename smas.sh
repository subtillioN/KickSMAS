#!/bin/sh
# creates the basic directory structure in either a new 'sass' dir or a directory of your choosing.
if [[ -z $1 ]]; then
	echo "Create a new 'sass' directory? ['y', or enter current directory path]";
	read input;
	if [[ $input = "y" ]]; then
		mkdir -p sass;
		SMAS_FOLDER="sass";
	else
		SMAS_FOLDER=$input;
	fi
else
	SMAS_FOLDER=$1;
fi

echo "Use .scss format? ['y', or 'n' for .sass]";
read input;

if [[ $input = "y" ]]; then
	SASS_FORMAT=".scss";
	END_LINE=";";
else
	SASS_FORMAT=".sass";
	END_LINE="";
fi

# make directories
mkdir -p ${SMAS_FOLDER}/base;
mkdir -p ${SMAS_FOLDER}/layout;
mkdir -p ${SMAS_FOLDER}/modules;
mkdir -p ${SMAS_FOLDER}/nonmodular;

#make files
APP_FILE=${SMAS_FOLDER}/app${SASS_FORMAT};
BASE_FILE=${SMAS_FOLDER}/base/__base${SASS_FORMAT};
touch ${APP_FILE};
touch ${BASE_FILE};
touch ${SMAS_FOLDER}/layout/__layout${SASS_FORMAT};
touch ${SMAS_FOLDER}/modules/__modules${SASS_FORMAT};
touch ${SMAS_FOLDER}/nonmodular/__nonmodular${SASS_FORMAT};
touch ${SMAS_FOLDER}/style-guide.txt
#make common base files
touch ${SMAS_FOLDER}/base/_normalize${SASS_FORMAT};
touch ${SMAS_FOLDER}/base/_settings${SASS_FORMAT};
touch ${SMAS_FOLDER}/base/_helpers${SASS_FORMAT};
touch ${SMAS_FOLDER}/base/_colors${SASS_FORMAT};
touch ${SMAS_FOLDER}/base/_fonts${SASS_FORMAT};
touch ${SMAS_FOLDER}/base/_element_defaults${SASS_FORMAT};

APP_TEXT="@import \"base/__base\"${END_LINE}\n@import \"layout/__layout\"${END_LINE}\n@import \"modules/__modules\"${END_LINE}\n@import \"non-modular/__non-modular\"${END_LINE}";

echo ${APP_TEXT} >> ${APP_FILE};

BASE_TEXT="@import \"compass\"${END_LINE}\n@import \"settings\"${END_LINE}\n@import \"helpers\"${END_LINE}\n@import \"colors\"${END_LINE}\n@import \"fonts\"${END_LINE}\n@import \"normalize\"${END_LINE}\n@import \"element_defaults\"${END_LINE}\n";

echo ${BASE_TEXT} >> ${BASE_FILE};

STYLE_GUIDE_TEXT="\nBASE:\n
Selectors: DOM-based, elements, attributes, etc\n\n

LAYOUT:\n
Selectors: 	class-based (ideally), prefixed with 'l-', e.g. '.l-single-centered-column'\n\n

MODULE:\n
Module Selectors: class-based, prefixed with 'm-', e.g. '.m-box', or '.m-panel'.\n\n

\tComponents: Parts of the MODULE.  When descendent selectors are not applicable, such as '& > li ', \n
\t\tcomponent selectors begin with the MODULE name and are followed by \"--\" followed by component \n
\t\tfunctional descriptor, e.g. '.m-box--header' or .m-box--body.\n\n

\tSubmodules: Significant variations of the MODULE.  Selector names for the submodules often begin \n
\t\twith the MODULE name and are followed by '_' and then a descriptor of variation, e.g. '.m-box_sidebar', \n
\t\tmeaning \".m-box styled for the sidebar.\"\n\n

\tModifiers: Slight variations of the MODULE.  Selector names for the modifiers begin with the MODULE name \n
\t\tand are followed by a '.' and then a descriptor of what's different with the modified version of the \n
\t\tmodule e.g. '.m-box.no-border,' meaning \"an m-box with no border.\" \n\n

A NOTE ON EXTENDING MODULES:\n
For more adaptable extension and modularity use of the \"placeholder selector,\" which uses '%'.  The function of the placeholder selector is to create an \"extend only\" style, so in order for it to appear in the CSS the style *must* be extended.  Conveniently, extending only placeholders *designed* for extending, eliminates the problems with extending across module lines.\n\n

Example documentation:\n\n


\t// button module declaration\n
\t// placeholder selector which won't be compiled to CSS but can be @extended\n
\t%m-button {\n
\t\t  border: 1px solid black;\n
\t}\n\n

\t// button module instantiation\n
\t// .m-button no longer defines any properties but @extends the placeholder selector\n
\t.m-button {\n
\t\t@extend %m-button;\n
\t}\n\n

\t// modifier declaration\n
\t%m-button.no-border {\n
\t\tborder-style: none;\n
\t}\n\n

\t// modifier instantiation\n
\t.m-button.no-border {\n
\t\t@extend %m-button.no-border;\n
\t}\n\n

\t// submodule declaration\n
\t%m-button_attention {\n
\t\t@extend %m-button;\n
\t\tborder-color: red;\n
\t}\n\n

\t// submodule instantiation\n
\t.m-button_attention {\n
\t\t@extend %m-button_attention;\n
\t}\n\n

\t// form module, reusing styles from button module\n
\t.m-form {\n
\t\t.m-form--submit {\t// component\n
\t\t\t@extend %m-button_attention; \n
\t\t\tfloat: right;\n
\t\t}\n
\t}\n\n

\t// m-button module also used as a selector in a different context\n
\t.l-sidebar { \n
\t\t.m-button { \n
\t\t\tborder-color: green;\n
\t\t}\n
\t}\n\n\n


STATE:\n
Selectors: 	class-based (ideally), pre- or mid-fixed with '.is-', e.g. '.is-selected' or '.m-box.is-hidden' Also things like pseudo-classes.\n\n

STATE selectors are generally found within or near to their respective styles, such as the following.  Note the continuation of the SMAS organization at the sub-MODULE level:\n\n

\t// -- module --\n
\t.m-box { \n
\t\t@extend %m-box;\n\n

\t\t// components\n
\t\t.m-box--header {...}\n\n

\t\t.m-box--body {...} \n\n

\t\t// modifiers \n
\t\t&.no-border { \n
\t\t\tborder: none;\n
\t\t} \n

\t\t&.right {\n
\t\t\tfloat: right;\n
\t\t} \n\n

\t\t// states \n
\t\t&.is-disabled { \n
\t\t\tbackground-color: #ccc;\n
\t\t}\n
\t}"

echo ${STYLE_GUIDE_TEXT} >> ${SMAS_FOLDER}/style-guide.txt;