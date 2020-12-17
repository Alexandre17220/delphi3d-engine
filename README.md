# Delphi3D-Engine
A 3D-graphic and game engine for Delphi and Windows. It was used to develop the game [Rise of Legions](https://riseoflegions.com).

# Usage
Either copy all files in your project or the way we usually link to it: Add the Engine directory and alls subdirectory to your library path in Delphi (must be configured for each target 32-bit and 64-bit). The engine is tested (in Rise of Legions) to work with 32-bit using the graphic components (client) and 64-bit working without any graphic (server).

# Features

* Graphics
  * DirectX 11 graphic adapter
  *
*
* Math
* Tons of helpers

## License

[![License: MPL 2.0](https://img.shields.io/badge/License-MPL%202.0-brightgreen.svg)](https://opensource.org/licenses/MPL-2.0)

The code base is distributed under MPL 2.0

It make use of other Open-Source-Software stated below:

[assimp](https://github.com/assimp/assimp) - Modified, 3-clause BSD-License - Used for importing model files like FBX.

[DWScript](https://www.delphitools.info/dwscript/) - MPL 1.1 - Used as scripting language.

[Imaging](https://github.com/galfar/imaginglib) - MPL - Used for importing texture of complex formats.

[Jedi-WinApi](https://sourceforge.net/projects/jedi-apilib/) - MPL 1.1 - Used for various windows functions.

[LockBox](https://github.com/TurboPack/LockBox) - MPL 1.1 - Used for hashing.

[VerySimpleXML](https://github.com/Dennis1000/verysimplexml) - MPL 1.1 - Used for XML parsing.
