# Loot Tint (VGLootTint)

![Standard pickup unchanged; Enhanced pickup tinted blue](docs/screenshots/pickup-tint.png)

Tints floating item pickup notifications using the game's rarity palette. Standard
items retain vanilla colors. No balance changes, save data, or mod configuration.

## Development status

This branch requires the **unreleased VGModAPI pickup-presentation API**. The public
0.2.8 release does not contain it. Do not distribute this consumer with 0.2.8.
The loader minimum must be set to the owner-selected API release containing this
feature before this branch is released; no new release version is assumed here.

## Runtime

Install BepInEx 5, the matching VGModAPI build, and `VGLootTint.dll` under
`BepInEx/plugins/`. The API is a hard dependency. Loot Tint registers one color
resolver through `ModApi.Services.PickupPresentation`; it has no Harmony patches,
native game references, or fallback patch path.

The API supplies the actual item's rarity color without name lookups, and preserves
the color during fade. Standard rarity abstains. Unavailable game integration leaves
vanilla colors untouched. Unloading the plugin disposes its registration.

To uninstall, remove `VGLootTint.dll` (or its plugin folder).

## Build

Build the API feature branch first, then:

```sh
make build VGAPI_DLL=/absolute/path/to/VGModAPI.Abstractions.dll
```

Only the plugin DLL is deployed; do not bundle API, BepInEx, Unity or game DLLs.
`make deploy` is a separate explicitly authorized installation action.

## License

MIT — see [LICENSE](LICENSE).
