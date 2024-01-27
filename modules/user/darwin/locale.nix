{pkgs, ...}: {
  imports = [];
  targets.darwin.defaults.NSGlobalDomain = {
    # locale / language / units
    AppleLanguages = ["en"];
    AppleLocale = "en_US";
    AppleMeasurementUnits = "Centimeters";
    AppleMetricUnits = true;
    AppleTemperatureUnit = "Celsius";
  };
}
