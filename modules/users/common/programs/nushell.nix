{
  flake.modules.homeManager.programNushell = {
    nushell = {
      enable = true;
      extraConfig = ''
        let fish_completer = {|spans|
            fish --command $'complete "--do-complete=($spans | str join " ")"'
            | from tsv --flexible --noheaders --no-infer
            | rename value description
        }
        $env.config = {
            completions: {
                external: {
                    enable: true
                    completer: $fish_completer
                }
            }
        }
      '';
    };
  };
}
