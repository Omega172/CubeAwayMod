# Mod for Cube Away 

[Cube Away - 3DPuzzle](https://apps.apple.com/us/app/cubeaway-3dpuzzle/id6760325543) 1.7.0 mod for arm64 iOS. 

## Features
 - Ad blocker 
 - Infinite Coins - coin spending that increases the balance
 - Infinite Lives - Lives and in-level mistake stars don't go down. 

## Build

Edit `Project.json` to set the mod project name, SDK, minimum iOS target and C++ dialect. These settings only affect the mod and its outputs. The app identifiers, name and version are preserved.

Install Theos and its iOS compiler and SDK in Linux. Set `THEOS` to that installation, or use the default `$HOME/theos`. The project path must not contain spaces.

On Windows, run `Build.bat`. It invokes plain `wsl`, using your default distribution and user. 

On Linux, run `bash ./Build.sh` from the project folder. Both scripts compile the dylib to `Build/Release/CubeAwayMod.dylib`.

### Package a provided IPA

Use the supported decrypted Cube Away 1.7.0 IPA. From the project folder:

```powershell
.\Package.bat "./Game.ipa"
```

```bash
bash ./Package.sh "./Game.ipa"
```

Python 3.11+ is required for packaging. The commands build the dylib and produce `Build/Release/CubeAwayMod-NeedsSigning.ipa`. You can omit the input path if the project root contains exactly one IPA, or pass a direct HTTPS IPA URL instead. Existing output is replaced only after verification succeeds.

### Build with GitHub Actions

Open the repository's **Actions** tab and select a workflow:

- **Build and Draft IPA Release**: click **Run workflow**, enter a new `version` tag and a direct HTTPS `ipa_url`. The draft release includes the modded IPA and dylib.
- **Build and Draft Dylib Release**: click **Run workflow** and enter a new `version` tag. The draft includes only the dylib and needs no IPA.

Find the output under **Releases**.
