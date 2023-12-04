{pkgs, config, ...}: {
  imports = [];

  programs.htop.enable = true;
  programs.htop.settings = {
    color_scheme = 6;
    cpu_count_from_one = 0;
    delay = 3;
    hide_function_bar = 0; # 0 never, 1 once, 2 permanently
    highlight_base_name = 1;
    highlight_megabytes = 1;
    highlight_threads = 1;
    show_program_path = 0;
    tree_view = 1;
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
    fields = with config.lib.htop.fields; [
      PID
      USER
      PRIORITY
      NICE
      M_SIZE
      M_RESIDENT
      M_SHARE
      STATE
      PERCENT_CPU
      PERCENT_MEM
      TIME
      COMM
    ];
  } // (with config.lib.htop; rightMeters [
    (bar "LeftCPUs8")
    (bar "Memory")
    (text "Systemd")
    (text "System")
    (text "Uptime")
    (bar "Battery")
  ])
  // (with config.lib.htop; leftMeters [
    (bar "RightCPUs8")
    (bar "CPU")
    (text "LoadAverage")
    (text "Tasks")
    (text "NetworkIO")
    (text "DiskIO")
  ]);

}
