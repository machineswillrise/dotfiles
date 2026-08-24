# Agent Rules

## General Rules
- NEVER use spaces for indentation, always use tabs
- ALWAYS put braces on the next line (Allman style) unless you are working on a project that uses other brace styles
- ALWAYS use braces even for single-line if statements, never skip them except for switch statements
- ALWAYS Sort imports into three sections:
	- Standard Library
	- External Libraries
	- Project-specific

## Language-Specific Rules
### Java
- NEVER use fully-qualified names, ALWAYS use import
- NEVER use wildcard imports, ALWAYS use specific imports

### Python
- ALWAYS use double quotes, not single ones

### Raku
- ALWAYS use the official kebab-case style with dashes for variable names like `$turbo-encabulator`
- ALWAYS use `if not $variable` instead of `unless`
- NEVER use `loop`, always use `for`

### C
- NEVER use `inline` on functions that are not static