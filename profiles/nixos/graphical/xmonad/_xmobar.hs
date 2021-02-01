Config { 

   -- appearance
     font =         "xft:Hack:size=11:Bold:antialias=true,Hack Nerd Font:size=12:Bold:antialias=true"
   , bgColor =      "#282a36"
   , fgColor =      "#f8f8f2"
   , alpha  =       255
   , position =     Static { xpos = 0 , ypos = 0, width = 1900, height = 20}
   , border =       NoBorder
   , borderColor =  "#373b41"

   -- layout
   , sepChar =  "%"   -- delineator between plugin names and straight text
   , alignSep = "}{"  -- separator between left-right alignment
   , template = "%StdinReader% }{<fc=#ff6ac1>%cpu%</fc> | <fc=#f1fa8c>%memory%</fc> | <fc=#57c7ff>%internet%</fc> | <fc=#bd93f9>%backlight%  %volume%</fc> | <fc=#5af78e>%battery%</fc> | <fc=#57c7ff>%clock% </fc>" 

   -- general behavior
   , lowerOnStart =     False    -- send to bottom of window stack on start
   , hideOnStart =      False   -- start with window unmapped (hidden)
   , allDesktops =      True    -- show on all desktops
   , overrideRedirect = False    -- set the Override Redirect flag (Xlib)
   , pickBroadest =     False   -- choose widest display (multi-monitor)
   , persistent =       True    -- enable/disable hiding (True = disabled),
   , iconRoot = "@icons@"

   -- plugins
   , commands = [
      --cpu 
      Run Com "@cpu@" [] "cpu" 50,

      --memory
      --  Run Com "@memory@" [] "memory" 50,

      --internet
      --  Run Com "@internet@" [] "internet" 50,

      --backlight
      --  Run Com "@backlight@" [] "backlight" 50,

      --volume
      --  Run Com "@volume@" [] "volume" 50,
       
      --battery
      --  Run Com "@battery@" [] "battery" 50,

      --clock
      --  Run Com "@clock@" [] "clock" 600,

       --stdinreader
       Run StdinReader
        	]
   }