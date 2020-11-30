Config {
       font = "xft:Monospace:pixelsize=11",
       -- used to make the bar appear correctly after Mod-q in older xmonad implementations (0.9.x)
       -- doesn't seem to do anything anymore (0.10, darcs)
--       lowerOnStart = False,
       commands = [
                Run Weather "BOS" ["-t"," <tempF>F","-L","64","-H","77","--normal","green","--high","red","--low","lightblue"] 36000,
                Run Cpu ["-L","3","-H","50","--normal","green","--high","red"] 10,
                Run Memory ["-t","Mem: <usedratio>%"] 10,
                Run Swap [] 10,
                Run Date "%a %b %_d %l:%M" "date" 10,
                Run Network "ra0" [] 10,
                Run StdinReader
                ]
       , sepChar = "%"
       , alignSep = "}{"
       , template = "%StdinReader% }{ %ra0% | %cpu% | %memory% * %swap%    <fc=#ee9a00>%date%</fc> | %KADS%"
       }
