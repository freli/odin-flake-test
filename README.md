# odin-flake-test

Testing ground for updating `odin-flake`.

## Get started

- Clone the repo
- Init submodules

``` bash
git submodule update --init
```

- Enter the developer environment

``` bash
nix develop
```

- Run Odin tests

``` bash
odin run src/raylib
odin run src/sdl2
odin run src/sdl3
```

The flake would normally use pinned versions of the libraries and should match
what the included version of Odin expects.

You can change Odin version in `odin-flake/flake.nix`, to test with a
different version.  
This is the Odin version that will be downloaded and built. 

The Odin submodule is only included to ease generating patches or diving into
the source, it's not used for the developer environment.  
You can `nix-shell` for an environment where you can build it, if you want to
play with it.

To run the included examples:

```bash
cd Odin
nix-shell
./build_odin.sh
./odin run ../src/raylib
```
