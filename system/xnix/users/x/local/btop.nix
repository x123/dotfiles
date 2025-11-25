{...}: {
  imports = [];

  programs.btop = {
    settings = {
      # https://github.com/aristocratos/btop#configurability
      check_temp = false; # 2024-08-20 currently causes a segfault
      cpu_sensor = "nct6686/AMD TSI Addr 98h";
      show_coretemp = false;
    };
  };
}
