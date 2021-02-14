{-# LANGUAGE OverloadedStrings #-}

import qualified Data.Map as M
import Graphics.X11.ExtraTypes.XF86
import System.Directory (getHomeDirectory)
import System.IO
import XMonad
import XMonad.Actions.Navigation2D
import XMonad.Actions.PhysicalScreens
import XMonad.Actions.UpdatePointer
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops(ewmh)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Layout.Fullscreen
import XMonad.Layout.Gaps
import XMonad.Layout.NoBorders
import XMonad.Layout.SimpleDecoration
import XMonad.Layout.Spiral
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import qualified XMonad.StackSet as W
import XMonad.Util.CustomKeys
import XMonad.Util.EZConfig (additionalKeys)
import XMonad.Util.Run (runProcessWithInput, safeSpawn, safeSpawnProg, spawnPipe)


-- Default terminal to use
myTerminal = "@alacritty@/bin/alacritty"

spawnXmobar = spawnPipe "@xmobar@/bin/xmobar @xmobarconf@"

myModMask = mod1Mask .|. controlMask .|. shiftMask

-- Workspaces
myWorkspaces = map show [1 .. 10]

-- Simple settings
myFocusFollowsMouse = True

-- No mouse bindings
myMouseBindings _ = M.empty

myKeys :: XConfig l -> M.Map (KeyMask, KeySym) (X ())
myKeys conf =
  M.fromList $
    mconcat $ do
      meh <- [modMask conf, mod3Mask]
      hyper <- [meh .|. mod4Mask]
      -- Switch workspace - meh-[1..9, 0]
      -- Move to workspace - hyper-[1..9, 0]
      workspaceCommands <- [ ((mask, key), windows (func n) >> resetPointer) | (n, key) <- zip (XMonad.workspaces conf) ([xK_1 .. xK_9] ++ [xK_0]), (func, mask) <- [(W.greedyView, meh), (W.shift, hyper)]]
      -- Switch screen - meh-[q,w,e]
      -- Move to screen - hyper-[q,w,e]
      screenCommands <-
       [ ((mask, key), func sc >> resetPointer)
             | (key, sc) <- zip [xK_q, xK_w, xK_e] [0 ..],
               (func, mask) <- [(viewScreen horizontalScreenOrderer, meh), (sendToScreen horizontalScreenOrderer, hyper)]
           ]
      return
        [ -- Application launcher
          ((meh, xK_d), spawn "rofi -lines 12 -padding 18 -width 60 -location 0 -show drun -sidebar-mode -columns 3 -font 'Fira Code 10'"),
          ((hyper, xK_d), spawn "dmenu_run"),
          -- Terminal
          ((meh, xK_Return), spawn $ XMonad.terminal conf),
          -- Applications
          ((meh, xK_F1), spawn "chromium"),
          ((meh, xK_F2), spawn "emacs"),
          ((meh, xK_F3), spawn "steam"),
          -- Management
          ((hyper, xK_k), kill),
          ((meh, xK_Left), windowGo L False >> resetPointer),
          ((meh, xK_Right), windowGo R False >> resetPointer),
          ((hyper, xK_Left), windowSwap' L False >> resetPointer),
          ((hyper, xK_Right), windowSwap' R False >> resetPointer),
          -- Restart XMonad, doesn't work as expected because of Nix, gotta fix
          ( (hyper, xK_r),
            do
              newXmonad <- runProcessWithInput "xmonad" [] ""
              restart newXmonad True
          ),
          -- Mute volume.
          ((0, xF86XK_AudioMute), safeSpawn "amixer" ["-D", "pulse", "sset", "Master", "toggle"]),
          -- Decrease volume.
          ((0, xF86XK_AudioLowerVolume), volume "-1%"),
          ((meh, xK_Page_Down), volume "-1%"),
          -- Increase volume.
          ((0, xF86XK_AudioRaiseVolume), volume "+1%"),
          ((meh, xK_Page_Up), volume "+1%"),
          workspaceCommands,
          screenCommands
        ]

  where
    windowSwap' direction wrap = windowSwap direction wrap >> windowGo direction wrap
    volume change = safeSpawn "volume" [change]
    resetPointer = updatePointer (0.5, 0.5) (0, 0)

-- Colors and borders
--
myNormalBorderColor = "#7c7c7c"

myFocusedBorderColor = "#ffb6b0"

-- Colors for text and backgrounds of each tab when in "Tabbed" layout.
tabConfig =
  def
    { activeBorderColor = "#7C7C7C",
      activeTextColor = "#CEFFAC",
      activeColor = "#000000",
      inactiveBorderColor = "#7C7C7C",
      inactiveTextColor = "#EEEEEE",
      inactiveColor = "#000000"
    }

-- Color of current window title in xmobar.
xmobarTitleColor = "#FFB6B0"

-- Color of current workspace in xmobar.
xmobarCurrentWorkspaceColor = "#CEFFAC"

-- Width of the window border in pixels.
myBorderWidth = 0

-- Window rules
myManageHook =
  composeAll
    [ className =? "Steam" --> doFloat,
      className =? "rofi" --> doFloat,
      -- Games
      className =? "factorio" --> doFloat,
      isFullscreen --> (doF W.focusDown <+> doFullFloat),
      className =? "Carrion" --> doFloat
    ]
-- Layout algorithms
myLayout =
  avoidStruts $
    tiled
      ||| Mirror tiled
      ||| Full
      ||| tabbed shrinkText def
      ||| threeCol
  where
    -- default tiling algorithm partitions the screen into two panes
    tiled = Tall nmaster delta ratio
    threeCol = ThreeCol nmaster delta ratio
    -- The default number of windows in the master pane
    nmaster = 1
    -- Default proportion of screen occupied by master pane
    ratio = 1 / 2
    -- Percent of screen to increment by when resizing panes
    delta = 2 / 100

main = do
  xmproc <- spawnXmobar
  xmonad $
    ewmh $
      def
        { -- simple stuff
          terminal = myTerminal,
          focusFollowsMouse = myFocusFollowsMouse,
          borderWidth = myBorderWidth,
          modMask = myModMask,
          workspaces = myWorkspaces,
          normalBorderColor = myNormalBorderColor,
          focusedBorderColor = myFocusedBorderColor,
          -- key bindings
          keys = myKeys,
          mouseBindings = myMouseBindings,
          -- hooks, layouts
          layoutHook = smartBorders myLayout,
          manageHook = myManageHook,
          handleEventHook = docksEventHook <+> fullscreenEventHook,
          logHook =
            dynamicLogWithPP $
              xmobarPP
                { ppOutput = hPutStrLn xmproc,
                  ppTitle = xmobarColor xmobarTitleColor "" . shorten 100,
                  ppCurrent = xmobarColor xmobarCurrentWorkspaceColor "",
                  ppSep = "   "
                }
        }
