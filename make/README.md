[1]: https://www.gnu.org/software/make/manual/html_node/Wildcard-Function.html "make wildcard function"
[2]: recipes/README.md "recipes README"
# include files

* Makefile extracts that can be included in your project's own

* packer json that more than one product-role has in common (see under ./json dir)

## layout

        ./make
        ├── README.md       # ... you're reading this
        │
        ├── bootstraps
        │   └── ...         # ... the file your project calls that includes the
        │                         other snippets.
        ├── constants
        │   └── ...         # ... env vars with a fixed value (so, no, not really vars)
        │
        ├── custom_file.mak  # ... template you can call to include a snippet from your
        │                         project dir
        ├── generated_vars
        │   └── ...         # ... vars whose values are generated during compilation
        │
        ├── json
        │   └── ...         # ... common packer json - pick the one that suits you
        │                         or use one from your project dir.
        ├── mandatory_vars
        │   └── ...         # ... a list of env vars that must be defined before a
        │                         recipe is run. Use this to validate before build.
        ├── recipes
        │   └── ...         # ... common groups of recipe. Mix and match: include these
        │                         or your own from, yep, you guessed it, your project dir.
        ├── role_vars
        │   └── ...         # ... files of vars appropriate to a EUROSTAR_SERVICE_ROLE
        │                         e.g. gateway | appsvr | frontend
        │                         See bootstraps/product.mak for an example use-case.
        │
        └── user_vars       # ... files of env vars that can be user-defined (passed to `make`)
            └── ...


# Makefile tips

* Use the [wildcard function] [1] if you want to include a file only if it exists.

* Append to a var by using the `+=` operator e.g. `MY_VAR += some extra words`

* `make -r ...` will shave off a few seconds (we don't use the implicit rules at all)

* `make -r --print-data-base` will tell you in which file each var is declared and
   the source that defined it e.g. environment | default (from file) etc ...

* `make --trace -d <target>` can be very enlightening.

See [README.md in ./recipes] [2] for some other interesting introspective things
offered by Make.
