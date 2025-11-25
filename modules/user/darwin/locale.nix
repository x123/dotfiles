{pkgs, ...}: {
  imports = [];

  # locale / language / units
  targets.darwin.defaults.NSGlobalDomain.AppleLanguages = [ "en" ];
  targets.darwin.defaults.NSGlobalDomain.AppleLocale = "en_US";
  targets.darwin.defaults.NSGlobalDomain.AppleMeasurementUnits = "Centimeters";
  targets.darwin.defaults.NSGlobalDomain.AppleMetricUnits = true;
  targets.darwin.defaults.NSGlobalDomain.AppleTemperatureUnit = "Celsius";

  # typing/spelling
  targets.darwin.defaults.NSGlobalDomain.NSAutomaticCapitalizationEnabled = true;
  targets.darwin.defaults.NSGlobalDomain.NSAutomaticDashSubstitutionEnabled = true;
  targets.darwin.defaults.NSGlobalDomain.NSAutomaticPeriodSubstitutionEnabled = true;

}
