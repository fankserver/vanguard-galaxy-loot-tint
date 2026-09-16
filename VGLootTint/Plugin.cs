using System;
using BepInEx;
using VGModAPI;

namespace VGLootTint;

[BepInPlugin(PluginGuid, PluginName, PluginVersion)]
[BepInProcess("VanguardGalaxy.exe")]
[BepInDependency(ModApi.PluginId)]
public class Plugin : BaseUnityPlugin
{
    public const string PluginGuid = "vglootint";
    public const string PluginName = "Loot Tint";
    public const string PluginVersion = "0.1.0";

    private IDisposable? _registration;

    private void Awake()
    {
        var presentation = ModApi.Services.PickupPresentation;
        _registration = presentation.Register(PluginGuid, pickup => pickup.RarityColor);
        Logger.LogInfo($"{PluginName} v{PluginVersion} loaded (VGModAPI pickup presentation)");
        if (!presentation.Availability.IsAvailable)
            Logger.LogWarning("Pickup presentation is unavailable; leaving vanilla colors unchanged.");
    }

    private void OnDestroy()
    {
        _registration?.Dispose();
        _registration = null;
    }
}
