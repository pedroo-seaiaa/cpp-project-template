# Building

This project comes with [CMakePresets.json](../CMakePresets.json) file that contains all cmake presets for building.
These presets contain all the options for configuration, building, testing and packaging the project.

> Please change them as you see fit.

The standard configurations include:
- Windows
- - MSVC
- - Clang
- Linux
- - GNU
- - Clang

By default, the project uses `ninja` as the build system generator.
