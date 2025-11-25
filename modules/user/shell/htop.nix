{
  pkgs,
  config,
  ...
}: {
  imports = [];

  programs.htop.enable = true;
  programs.htop.settings =
    {
      color_scheme = 6;
      cpu_count_from_one = 0;
      delay = 3;
      hide_function_bar = 0; # 0 never, 1 once, 2 permanently
      highlight_base_name = 1;
      highlight_megabytes = 1;
      highlight_threads = 1;
      show_program_path = 0;
      tree_view = 0;
      show_cpu_temperature = 1;
      show_cpu_frequency = 1;
      enable_mouse = 0;
      sort_key = config.lib.htop.fields.PERCENT_CPU;
      tree_sort_key = config.lib.htop.fields.PERCENT_CPU;
      sort_direction = -1;
      tree_sort_direction = 1;
      all_branches_collapsed = 0;
      hide_kernel_threads = 1;
      hide_userland_threads = 0;
      hide_running_in_container = 0;
      fields = [
        config.lib.htop.fields.PID
        config.lib.htop.fields.USER
        config.lib.htop.fields.PRIORITY
        config.lib.htop.fields.NICE
        config.lib.htop.fields.M_SIZE
        config.lib.htop.fields.M_RESIDENT
        config.lib.htop.fields.M_SHARE
        config.lib.htop.fields.STATE
        config.lib.htop.fields.PERCENT_CPU
        config.lib.htop.fields.PERCENT_MEM
        config.lib.htop.fields.TIME
        config.lib.htop.fields.COMM
      ];
    }
    // config.lib.htop.rightMeters [
      (config.lib.htop.bar "LeftCPUs8")
      (config.lib.htop.bar "Memory")
      (config.lib.htop.text "Systemd")
      (config.lib.htop.text "System")
      (config.lib.htop.text "Uptime")
      (config.lib.htop.bar "Battery")
    ]
    // config.lib.htop.leftMeters [
      (config.lib.htop.bar "RightCPUs8")
      (config.lib.htop.bar "CPU")
      (config.lib.htop.text "LoadAverage")
      (config.lib.htop.text "Tasks")
      (config.lib.htop.text "NetworkIO")
      (config.lib.htop.text "DiskIO")
    ];
}
