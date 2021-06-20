class "night"
local table = [[
{
    "CharacterLighting": {
        "CharacterLightEnable": "true",
        "FirstPersonEnable": "true",
        "LockToCameraDirection": "true",
        "CameraUpRotation": "27.482999801636",
        "CharacterLightingMode": "1",
        "BlendFactor": "0.02",
        "TopLight": "1:1:1:",
        "BottomLight": "1:1:1:",
        "TopLightDirX": "0",
        "TopLightDirY": "0.0"
    },
    "ColorCorrection": {
        "Realm": "0",
        "Enable": "true",
        "Brightness": "1:1:1:",
        "Contrast": "1.0:1.0:1.02:",
        "Saturation": "0.7275:0.7725:0.9225:",
        "Hue": "0.0",
        "ColorGradingEnable": "false"
    },
    "DynamicAO": {
        "Realm": "0",
        "Enable": "true",
        "SsaoFade": "1.0",
        "SsaoRadius": "1.0",
        "SsaoMaxDistanceInner": "1.0",
        "SsaoMaxDistanceOuter": "1.0",
        "HbaoRadius": "1.0",
        "HbaoAngleBias": "1.0",
        "HbaoAttenuation": "1.0",
        "HbaoContrast": "1.0",
        "HbaoMaxFootprintRadius": "1",
        "HbaoPowerExponent": "1.0"
    },
    "Enlighten": {
        "Realm": "0",
        "Enable": "false",
        "BounceScale": "0.1",
        "SunScale": "0",
        "TerrainColor": "(0.0, 0.0, 0.0)",
        "CullDistance": "-1.0",
        "SkyBoxEnable": "false",
        "SkyBoxSkyColor": "(0.022000, 0.078000, 0.177000)",
        "SkyBoxGroundColor": "(0.085000, 0.206000, 0.394000)",
        "SkyBoxSunLightColor": "(0.282000, 0.991000, 3.000000)",
        "SkyBoxSunLightColorSize": "0.0",
        "SkyBoxBackLightColor": "(0.022000, 0.078000, 0.177000)",
        "SkyBoxBackLightColorSize": "0.1",
        "SkyBoxBackLightRotationX": "171.95899963379",
        "SkyBoxBackLightRotationY": "26.563999176025"
    },
    "Fog": {
        "Realm": "0",
        "Enable": "true",
        "FogDistanceMultiplier": "1.0",
        "FogGradientEnable": "true",
        "Start": "15",
        "EndValue": "1000.0",
        "Curve": "0.4:-0.77:1.3:-0.01:",
        "FogColorEnable": "true",
        "FogColor": "0.001:0.001:0.001:",
        "FogColorStart": "0",
        "FogColorEnd": "5000",
        "FogColorCurve": "6.1:-11.7:5.62:-0.18:",
        "HeightFogEnable": "false",
        "HeightFogFollowCamera": "0.0",
        "HeightFogAltitude": "0.0",
        "HeightFogDepth": "100.0",
        "HeightFogVisibilityRange": "100.0"
    },
    "OutdoorLight": {
        "Realm": "0",
        "Enable": "true",
        "SunColor": "(0, 0, 0)",
        "SkyColor": "(0.015, 0.015, 0.015)",
        "GroundColor": "(0.0005, 0.0005, 0.0005)",
        "SunSpecularScale": "0",
        "SunRotationX": "0",
        "SunRotationY": "0"
    },
    "Sky": {
        "Realm": "0",
        "Enable": "true",
        "BrightnessScale": "0.005",
        "SunSize": "0.01",
        "SunScale": "1.5",
        "CloudLayerSunColor": "(0, 0, 0)",
        "CloudLayer1Altitude": "500000.0",
        "CloudLayer1TileFactor": "0.25",
        "CloudLayer1Rotation": "223.52900695801",
        "CloudLayer1Speed": "-0.001",
        "CloudLayer1SunLightIntensity": "0.1",
        "CloudLayer1SunLightPower": "0.1",
        "CloudLayer1AmbientLightIntensity": "0.1",
        "CloudLayer1Color": "(0.1, 0.1, 0.1)",
        "CloudLayer1AlphaMul": "0.5",
        "CloudLayer2Altitude": "5000000.0",
        "CloudLayer2TileFactor": "0.60000002384186",
        "CloudLayer2Rotation": "237.07299804688",
        "CloudLayer2Speed": "-0.0010000000474975",
        "CloudLayer2SunLightIntensity": "1.0",
        "CloudLayer2SunLightPower": "5.0",
        "CloudLayer2AmbientLightIntensity": "1",
        "CloudLayer2Color": "1:1:1:",
        "CloudLayer2AlphaMul": "0.3",
        "StaticEnvmapScale": "0",
        "SkyVisibilityExponent": "0",
        "SkyEnvmap8BitTexScale": "5",
        "CustomEnvmapScale": "1",
        "CustomEnvmapAmbient": "1"
    },
    "SunFlare": {
        "Element1Size": "0.0:0.0:",
        "Element2Size": "0.0:0.0:",
        "Element3Size": "0.0:0.0:",
        "Element4Size": "0.0:0.0:",
        "Element5Size": "0.0:0.0:"
    },
    "Tonemap": {
        "Realm": "0",
        "TonemapMethod": "2",
        "MiddleGray": "0.25",
        "MinExposure": "0.8",
        "MaxExposure": "3.5",
        "ExposureAdjustTime": "0.5",
        "BloomScale": "0.05:0.05:0.05:",
        "ChromostereopsisEnable": "false",
        "ChromostereopsisScale": "1.0",
        "ChromostereopsisOffset": "1.0"
    },
    "Wind": {
        "Realm": "0",
        "WindDirection": "211.25799560547",
        "WindStrength": "1.7"
    },
    "Name": "DefaultNight",
    "Type": "DefaultNight",
    "Priority": "10",
    "Visibility": "1"
}
]]

function night:GetPreset()
  return table
end

return night
