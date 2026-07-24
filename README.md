# Box

Box is my ideal computing environment for focus and creativity.

## Philosophy

The box space is designed to:

1. be a distraction and bloat free creative learning space
2. make common actions and workflows as effortless as possible
3. learn more about linux and computer programming fundamentals
4. be aesthetically beautiful, calming, yet minimal

## Install

```sh
git clone https://github.com/emmanueletti/box.git ~/box
cd ~/box
./install.sh
```

## Run specific module

To rerun just one module group, call its `setup.sh`

```sh
platforms/arch/modules/03-configs/setup.sh
```

## Run single step

`BOX_ROOT` must be set in the environment (zsh config setup does this):

```sh
platforms/arch/modules/03-configs/001-symlink-configs.sh
```
