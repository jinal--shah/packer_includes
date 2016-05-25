[1]: https://www.gnu.org/software/make/manual/html_node/Wildcard-Function.html "make wildcard function"
[2]: recipes/README.md "recipes README"
# includes

* Makefile extracts that can be included in your project's own

* packer json that more than one product-role has in common

## Makefile tips

* Use the [wildcard function] [1] if you want to include a file only if it exists.

* `make -r` will shave off a few seconds (we don't use the implicit rules at all)

* `make --trace -d <target>` can be very enlightening.

See [README.md in ./recipes] [2] for some other interesting introspective things
offered by Make.
