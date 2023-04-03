-- Base

-- Actions

-- Data

-- Hooks

-- for some fullscreen events, also for xcomposite in obs.

-- Layouts

-- Layouts modifiers

-- Utilities

-- ColorScheme module (SET ONLY ONE!)
-- Possible choice are:
-- DoomOne
-- Dracula
-- GruvboxDark
-- MonokaiPro
-- Nord
-- OceanicNext
-- Palenight
-- SolarizedDark
-- SolarizedLight
-- TomorrowNight
import Colors.DoomOne
import Data.Char (isSpace, toUpper)
import qualified Data.Map as M
import Data.Maybe (fromJust, isJust)
import Data.Monoid
import Data.Tree
import System.Directory
import System.Exit (exitSuccess)
import System.IO (hClose, hPutStr, hPutStrLn)
import XMonad
import XMonad.Actions.CopyWindow (kill1)
import XMonad.Actions.CycleWS (Direction1D (..), WSType (..), moveTo, nextScreen, prevScreen, shiftTo)
import XMonad.Actions.GridSelect
import XMonad.Actions.MouseResize
import XMonad.Actions.Promote
import XMonad.Actions.RotSlaves (rotAllDown, rotSlavesDown)
import qualified XMonad.Actions.Search as S
import XMonad.Actions.WindowGo (runOrRaise)
import XMonad.Actions.WithAll (killAll, sinkAll)
import XMonad.Config.Kde
import XMonad.Hooks.DynamicLog (PP (..), dynamicLogWithPP, shorten, wrap, xmobarColor, xmobarPP)
import XMonad.Hooks.EwmhDesktops
import XMonad.Hooks.ManageDocks (ToggleStruts (..), avoidStruts, docks, manageDocks)
import XMonad.Hooks.ManageHelpers (doCenterFloat, doFullFloat, isFullscreen)
import XMonad.Hooks.ServerMode
import XMonad.Hooks.SetWMName
import XMonad.Hooks.StatusBar
import XMonad.Hooks.StatusBar.PP
import XMonad.Hooks.WindowSwallowing
import XMonad.Hooks.WorkspaceHistory
import XMonad.Layout.Accordion
import XMonad.Layout.GridVariants (Grid (Grid))
import XMonad.Layout.LayoutModifier
import XMonad.Layout.LimitWindows (decreaseLimit, increaseLimit, limitWindows)
import XMonad.Layout.MultiToggle (EOT (EOT), mkToggle, single, (??))
import qualified XMonad.Layout.MultiToggle as MT (Toggle (..))
import XMonad.Layout.MultiToggle.Instances (StdTransformers (MIRROR, NBFULL, NOBORDERS))
import XMonad.Layout.NoBorders
import XMonad.Layout.Renamed
import XMonad.Layout.ResizableTile
import XMonad.Layout.ShowWName
import XMonad.Layout.Simplest
import XMonad.Layout.SimplestFloat
import XMonad.Layout.Spacing
import XMonad.Layout.Spiral
import XMonad.Layout.SubLayouts
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import qualified XMonad.Layout.ToggleLayouts as T (ToggleLayout (Toggle), toggleLayouts)
import XMonad.Layout.WindowArranger (WindowArrangerMsg (..), windowArrange)
import XMonad.Layout.WindowNavigation
import qualified XMonad.StackSet as W
import XMonad.Util.Dmenu
import XMonad.Util.EZConfig (additionalKeysP, mkNamedKeymap)
import XMonad.Util.Hacks (javaHack, trayAbovePanelEventHook, trayPaddingEventHook, trayPaddingXmobarEventHook, trayerAboveXmobarEventHook, trayerPaddingXmobarEventHook, windowedFullscreenFixEventHook)
import XMonad.Util.NamedActions
import XMonad.Util.NamedScratchpad
import XMonad.Util.Run (runProcessWithInput, safeSpawn, spawnPipe)
import XMonad.Util.SpawnOnce

myFont :: String
myFont = "xft:IosevkaTerm Nerd Font Mono:regular:size=12:antialias=true:hinting=true"

myModMask :: KeyMask
myModMask = mod4Mask -- Sets modkey to super/windows key

myTerminal :: String
myTerminal = "alacritty" -- Sets default terminal

myBrowser :: String
myBrowser = "firefox" -- Sets qutebrowser as browser

myEditor :: String
-- myEditor = "emacsclient -c -a 'emacs' "  -- Sets emacs as editor
myEditor = myTerminal ++ " -e nvim " -- Sets nvim as editor

myBorderWidth :: Dimension
myBorderWidth = 2 -- Sets border width for windows

myNormColor :: String -- Border color of normal windows
myNormColor = colorBack -- This variable is imported from Colors.THEME

myFocusColor :: String -- Border color of focused windows
myFocusColor = "#1e2127" -- This variable is imported from Colors.THEME

windowCount :: X (Maybe String)
windowCount = gets $ Just . show . length . W.integrate' . W.stack . W.workspace . W.current . windowset

myStartupHook :: X ()
myStartupHook = do
  -- spawn "killall conky" -- kill current conky on each restart
  spawn "killall trayer" -- kill current trayer on each restart
  spawnOnce "lxsession"
  spawnOnce "picom"
  spawnOnce "nm-applet"
  spawnOnce "volumeicon"
  -- spawnOnce "notify-log $HOME/.log/notify.log"

  -- spawn ("sleep 2 && conky -c $HOME/.config/conky/xmonad/" ++ colorScheme ++ "-01.conkyrc")
  spawn ("sleep 2 && trayer --edge top --align right --widthtype request --padding 0 --SetDockType true --SetPartialStrut true --expand true --monitor 1 --transparent true --alpha 0 " ++ colorTrayer ++ " --height 28")

  spawn "/home/changfeng/bin/swap_caps_esc_in_xmonad.sh" -- swap keys
  spawn "/home/changfeng/bin/enbale_wifi.sh" -- enable WIFI

  -- spawnOnce "xargs xwallpaper --stretch < ~/.cache/wall"

  spawnOnce "exec /usr/bin/fcitx5"
  spawnOnce "nitrogen --restore &" -- nitrogen set wallpaper
  setWMName "XMonad"

myNavigation :: TwoD a (Maybe a)
myNavigation = makeXEventhandler $ shadowWithKeymap navKeyMap navDefaultHandler
  where
    navKeyMap =
      M.fromList
        [ ((0, xK_Escape), cancel),
          ((0, xK_Return), select),
          ((0, xK_slash), substringSearch myNavigation),
          ((0, xK_Left), move (-1, 0) >> myNavigation),
          ((0, xK_h), move (-1, 0) >> myNavigation),
          ((0, xK_Right), move (1, 0) >> myNavigation),
          ((0, xK_l), move (1, 0) >> myNavigation),
          ((0, xK_Down), move (0, 1) >> myNavigation),
          ((0, xK_j), move (0, 1) >> myNavigation),
          ((0, xK_Up), move (0, -1) >> myNavigation),
          ((0, xK_k), move (0, -1) >> myNavigation),
          ((0, xK_y), move (-1, -1) >> myNavigation),
          ((0, xK_i), move (1, -1) >> myNavigation),
          ((0, xK_n), move (-1, 1) >> myNavigation),
          ((0, xK_m), move (1, -1) >> myNavigation),
          ((0, xK_space), setPos (0, 0) >> myNavigation)
        ]
    navDefaultHandler = const myNavigation

myColorizer :: Window -> Bool -> X (String, String)
myColorizer =
  colorRangeFromClassName
    (0x28, 0x2c, 0x34) -- lowest inactive bg
    (0x28, 0x2c, 0x34) -- highest inactive bg
    (0xc7, 0x92, 0xea) -- active bg
    (0xc0, 0xa7, 0x9a) -- inactive fg
    (0x28, 0x2c, 0x34) -- active fg

-- gridSelect menu layout
mygridConfig :: p -> GSConfig Window
mygridConfig colorizer =
  (buildDefaultGSConfig myColorizer)
    { gs_cellheight = 40,
      gs_cellwidth = 200,
      gs_cellpadding = 6,
      gs_navigate = myNavigation,
      gs_originFractX = 0.5,
      gs_originFractY = 0.5,
      gs_font = myFont
    }

spawnSelected' :: [(String, String)] -> X ()
spawnSelected' lst = gridselect conf lst >>= flip whenJust spawn
  where
    conf =
      def
        { gs_cellheight = 40,
          gs_cellwidth = 180,
          gs_cellpadding = 6,
          gs_originFractX = 0.5,
          gs_originFractY = 0.5,
          gs_font = myFont
        }

runSelectedAction' :: GSConfig (X ()) -> [(String, X ())] -> X ()
runSelectedAction' conf actions = do
  selectedActionM <- gridselect conf actions
  case selectedActionM of
    Just selectedAction -> selectedAction
    Nothing -> return ()

-- Makes setting the spacingRaw simpler to write. The spacingRaw module adds a configurable amount of space around windows.
mySpacing :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing i = spacingRaw False (Border i i i i) True (Border i i i i) True

-- Below is a variation of the above except no borders are applied
-- if fewer than two windows. So a single window has no gaps.
mySpacing' :: Integer -> l a -> XMonad.Layout.LayoutModifier.ModifiedLayout Spacing l a
mySpacing' i = spacingRaw True (Border i i i i) True (Border i i i i) True

-- Defining a bunch of layouts, many that I don't use.
-- limitWindows n sets maximum number of windows displayed for layout.
-- mySpacing n sets the gap size around the windows.
tall =
  renamed [Replace "tall"] $
    limitWindows 5 $
      smartBorders $
        windowNavigation $
          addTabs shrinkText myTabTheme $
            subLayout [] (smartBorders Simplest) $
              mySpacing 4 $
                ResizableTall 1 (3 / 100) (1 / 2) []

monocle =
  renamed [Replace "monocle"] $
    smartBorders $
      windowNavigation $
        addTabs shrinkText myTabTheme $
          subLayout
            []
            (smartBorders Simplest)
            Full

floats =
  renamed [Replace "floats"] $
    smartBorders
      simplestFloat

grid =
  renamed [Replace "grid"] $
    limitWindows 9 $
      smartBorders $
        windowNavigation $
          addTabs shrinkText myTabTheme $
            subLayout [] (smartBorders Simplest) $
              mySpacing 8 $
                mkToggle (single MIRROR) $
                  Grid (16 / 10)

spirals =
  renamed [Replace "spirals"] $
    limitWindows 9 $
      smartBorders $
        windowNavigation $
          addTabs shrinkText myTabTheme $
            subLayout [] (smartBorders Simplest) $
              mySpacing' 8 $
                spiral (6 / 7)

threeCol =
  renamed [Replace "threeCol"] $
    limitWindows 7 $
      smartBorders $
        windowNavigation $
          addTabs shrinkText myTabTheme $
            subLayout [] (smartBorders Simplest) $
              ThreeCol 1 (3 / 100) (1 / 2)

threeRow =
  renamed [Replace "threeRow"] $
    limitWindows 7 $
      smartBorders $
        windowNavigation $
          addTabs shrinkText myTabTheme $
            subLayout [] (smartBorders Simplest)
            -- Mirror takes a layout and rotates it by 90 degrees.
            -- So we are applying Mirror to the ThreeCol layout.
            $
              Mirror $
                ThreeCol 1 (3 / 100) (1 / 2)

tabs =
  renamed [Replace "tabs"]
  -- I cannot add spacing to this layout because it will
  -- add spacing between window and tabs which looks bad.
  $
    tabbed shrinkText myTabTheme

tallAccordion =
  renamed
    [Replace "tallAccordion"]
    Accordion

wideAccordion =
  renamed [Replace "wideAccordion"] $
    Mirror Accordion

-- setting colors for tabs layout and tabs sublayout.
myTabTheme =
  def
    { fontName = myFont,
      activeColor = color15,
      inactiveColor = color08,
      activeBorderColor = color15,
      inactiveBorderColor = colorBack,
      activeTextColor = colorBack,
      inactiveTextColor = color16
    }

-- Theme for showWName which prints current workspace when you change workspaces.
myShowWNameTheme :: SWNConfig
myShowWNameTheme =
  def
    { swn_font = "xft:IosevkaTerm Nerd Font Mono:bold:size=60",
      swn_fade = 1.0,
      swn_bgcolor = "#1c1f24",
      swn_color = "#ffffff"
    }

-- The layout hook
myLayoutHook =
  avoidStruts $
    mouseResize $
      windowArrange $
        T.toggleLayouts floats $
          mkToggle (NBFULL ?? NOBORDERS ?? EOT) myDefaultLayout
  where
    myDefaultLayout =
      tall
        ||| monocle
        ||| floats
        ||| tabs
        ||| grid
        ||| spirals
        ||| threeCol
        ||| threeRow
        ||| tallAccordion
        ||| wideAccordion

-- myWorkspaces = [" 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 ", " 9 "]
myWorkspaces = [" sys ", " web ", " work ", " dev ", " chat ", " video ", " audio ", " docs ", " fun "]

myWorkspaceIndices = M.fromList $ zip myWorkspaces [1 ..] -- (,) == \x y -> (x,y)

clickable ws = "<action=xdotool key super+" ++ show i ++ ">" ++ ws ++ "</action>"
  where
    i = fromJust $ M.lookup ws myWorkspaceIndices

subtitle' :: String -> ((KeyMask, KeySym), NamedAction)
subtitle' x =
  ( (0, 0),
    NamedAction $
      map toUpper $
        sep ++ "\n-- " ++ x ++ " --\n" ++ sep
  )
  where
    sep = replicate (6 + length x) '-'

showKeybindings :: [((KeyMask, KeySym), NamedAction)] -> NamedAction
showKeybindings x = addName "Show Keybindings" $ io $ do
  h <- spawnPipe "yad --text-info --fontname=\"SauceCodePro Nerd Font Mono 14\" --fore=#46d9ff back=#282c36 --center --geometry=1200x800 --title \"XMonad keybindings\""
  -- hPutStr h (unlines $ showKm x) -- showKM adds ">>" before subtitles
  hPutStr h (unlines $ showKmSimple x) -- showKmSimple doesn't add ">>" to subtitles
  hClose h
  return ()

myKeys :: XConfig l0 -> [((KeyMask, KeySym), NamedAction)]
myKeys c =
  -- (subtitle "Custom Keys":) $ mkNamedKeymap c $
  let subKeys str ks = subtitle' str : mkNamedKeymap c ks
   in subKeys
        "Xmonad Essentials"
        [ ("M-r", addName "Recompile and restart XMonad" $ spawn "/home/changfeng/bin/update_xmonad.sh"),
          ("M-S-q", addName "Quit XMonad" $ sequence_ [io exitSuccess]),
          ("M-S-c", addName "Kill focused window" kill1),
          ("M-S-a", addName "Kill all windows on WS" killAll),
          ("M-S-b", addName "Toggle bar show/hide" $ sendMessage ToggleStruts)
        ]
        ^++^ subKeys
          "Switch to workspace"
          [ ("M-1", addName "Switch to workspace 1" $ windows (W.greedyView $ head myWorkspaces)),
            ("M-2", addName "Switch to workspace 2" $ windows (W.greedyView $ myWorkspaces !! 1)),
            ("M-3", addName "Switch to workspace 3" $ windows (W.greedyView $ myWorkspaces !! 2)),
            ("M-4", addName "Switch to workspace 4" $ windows (W.greedyView $ myWorkspaces !! 3)),
            ("M-5", addName "Switch to workspace 5" $ windows (W.greedyView $ myWorkspaces !! 4)),
            ("M-6", addName "Switch to workspace 6" $ windows (W.greedyView $ myWorkspaces !! 5)),
            ("M-7", addName "Switch to workspace 7" $ windows (W.greedyView $ myWorkspaces !! 6)),
            ("M-8", addName "Switch to workspace 8" $ windows (W.greedyView $ myWorkspaces !! 7)),
            ("M-9", addName "Switch to workspace 9" $ windows (W.greedyView $ myWorkspaces !! 8))
          ]
        ^++^ subKeys
          "Send window to workspace"
          [ ("M-S-1", addName "Send to workspace 1" $ windows (W.shift $ head myWorkspaces)),
            ("M-S-2", addName "Send to workspace 2" $ windows (W.shift $ myWorkspaces !! 1)),
            ("M-S-3", addName "Send to workspace 3" $ windows (W.shift $ myWorkspaces !! 2)),
            ("M-S-4", addName "Send to workspace 4" $ windows (W.shift $ myWorkspaces !! 3)),
            ("M-S-5", addName "Send to workspace 5" $ windows (W.shift $ myWorkspaces !! 4)),
            ("M-S-6", addName "Send to workspace 6" $ windows (W.shift $ myWorkspaces !! 5)),
            ("M-S-7", addName "Send to workspace 7" $ windows (W.shift $ myWorkspaces !! 6)),
            ("M-S-8", addName "Send to workspace 8" $ windows (W.shift $ myWorkspaces !! 7)),
            ("M-S-9", addName "Send to workspace 9" $ windows (W.shift $ myWorkspaces !! 8))
          ]
        ^++^ subKeys
          "Move window to WS and go there"
          [ ("M-S-<Page_Up>", addName "Move window to next WS" $ shiftTo Next nonNSP >> moveTo Next nonNSP),
            ("M-S-<Page_Down>", addName "Move window to prev WS" $ shiftTo Prev nonNSP >> moveTo Prev nonNSP)
          ]
        ^++^ subKeys
          "Window navigation"
          [ ("M-j", addName "Move focus to next window" $ windows W.focusDown),
            ("M-k", addName "Move focus to prev window" $ windows W.focusUp),
            ("M-m", addName "Move focus to master window" $ windows W.focusMaster),
            ("M-S-j", addName "Swap focused window with next window" $ windows W.swapDown),
            ("M-S-k", addName "Swap focused window with prev window" $ windows W.swapUp),
            ("M-S-m", addName "Swap focused window with master window" $ windows W.swapMaster),
            ("M-<Backspace>", addName "Move focused window to master" promote),
            ("M-S-,", addName "Rotate all windows except master" rotSlavesDown),
            ("M-S-.", addName "Rotate all windows current stack" rotAllDown)
          ]
        -- Rofi launcher
        ^++^ subKeys
          "Dmenu scripts"
          [ ("M-p a", addName "List applications" $ spawn "rofi -show-icons -show drun"),
            ("M-p w", addName "List windows" $ spawn "rofi -show-icons -show window"),
            ("M-p e", addName "List executables" $ spawn "rofi -show-icons -show run")
          ]

        ^++^ subKeys
          "Favorite programs"
          [ ("M-<Return>", addName "Launch terminal" $ spawn myTerminal),
            ("M-b", addName "Launch web browser" $ spawn myBrowser),
            ("M-M1-h", addName "Launch htop" $ spawn (myTerminal ++ " -e htop"))
          ]
        ^++^ subKeys
          "Monitors"
          [ ("M-.", addName "Switch focus to next monitor" nextScreen),
            ("M-,", addName "Switch focus to prev monitor" prevScreen)
          ]
        -- Switch layouts
        ^++^ subKeys
          "Switch layouts"
          [ ("M-<Tab>", addName "Switch to next layout" $ sendMessage NextLayout),
            ("M-<Space>", addName "Toggle noborders/full" $ sendMessage (MT.Toggle NBFULL) >> sendMessage ToggleStruts)
          ]
        -- Window resizing
        ^++^ subKeys
          "Window resizing"
          [ ("M-h", addName "Shrink window" $ sendMessage Shrink),
            ("M-l", addName "Expand window" $ sendMessage Expand),
            ("M-M1-j", addName "Shrink window vertically" $ sendMessage MirrorShrink),
            ("M-M1-k", addName "Expand window vertically" $ sendMessage MirrorExpand)
          ]
        -- Floating windows
        ^++^ subKeys
          "Floating windows"
          [ ("M-f", addName "Toggle float layout" $ sendMessage (T.Toggle "floats")),
            ("M-t", addName "Sink a floating window" $ withFocused $ windows . W.sink),
            ("M-S-t", addName "Sink all floated windows" sinkAll)
          ]
        -- Increase/decrease spacing (gaps)
        ^++^ subKeys
          "Window spacing (gaps)"
          [ ("C-M1-j", addName "Decrease window spacing" $ decWindowSpacing 4),
            ("C-M1-k", addName "Increase window spacing" $ incWindowSpacing 4),
            ("C-M1-h", addName "Decrease screen spacing" $ decScreenSpacing 4),
            ("C-M1-l", addName "Increase screen spacing" $ incScreenSpacing 4)
          ]
  where
    -- The following lines are needed for named scratchpads.
    nonNSP = WSIs (return (\ws -> W.tag ws /= "NSP"))
    nonEmptyNonNSP = WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "NSP"))

main :: IO ()
main = do
  -- Launching three instances of xmobar on their monitors.
  xmproc0 <- spawnPipe ("xmobar -x 0 $HOME/.config/xmobar/" ++ colorScheme ++ "-xmobarrc")
  -- xmproc1 <- spawnPipe ("xmobar -x 1 $HOME/.config/xmobar/" ++ colorScheme ++ "-xmobarrc")
  -- xmproc2 <- spawnPipe ("xmobar -x 2 $HOME/.config/xmobar/" ++ colorScheme ++ "-xmobarrc")
  xmonad $
    addDescrKeys' ((mod4Mask, xK_F1), showKeybindings) myKeys $
      ewmh $
        docks $
          def
            { manageHook = manageDocks,
              handleEventHook = windowedFullscreenFixEventHook <> swallowEventHook (className =? "Alacritty" <||> className =? "st-256color" <||> className =? "XTerm") (return True) <> trayerPaddingXmobarEventHook,
              modMask = myModMask,
              terminal = myTerminal,
              startupHook = myStartupHook,
              layoutHook = showWName' myShowWNameTheme myLayoutHook,
              workspaces = myWorkspaces,
              borderWidth = myBorderWidth,
              normalBorderColor = myNormColor,
              focusedBorderColor = myFocusColor,
              logHook =
                dynamicLogWithPP $
                  xmobarPP
                    { ppOutput = hPutStrLn xmproc0, -- xmobar on monitor 1
                    -- >> hPutStrLn xmproc1 x   -- xmobar on monitor 2
                    -- >> hPutStrLn xmproc2 x   -- xmobar on monitor 3
                      ppCurrent =
                        xmobarColor color06 ""
                          . wrap
                            ("<box type=Bottom width=2 mb=2 color=" ++ color06 ++ ">")
                            "</box>",
                      -- Visible but not current workspace
                      ppVisible = xmobarColor color06 "" . clickable,
                      -- Hidden workspace
                      ppHidden =
                        xmobarColor color05 ""
                          . wrap
                            ("<box type=Top width=2 mt=2 color=" ++ color05 ++ ">")
                            "</box>"
                          . clickable,
                      -- Hidden workspaces (no windows)
                      ppHiddenNoWindows = xmobarColor color05 "" . clickable,
                      -- Title of active window
                      ppTitle = xmobarColor color16 "" . shorten 60,
                      -- Separator character
                      ppSep = "<fc=" ++ color09 ++ "> <fn=1>|</fn> </fc>",
                      -- Urgent workspace
                      ppUrgent = xmobarColor color02 "" . wrap "!" "!",
                      -- Adding # of windows on current workspace to the bar
                      ppExtras = [windowCount],
                      -- order of things in xmobar
                      ppOrder = \(ws : l : t : ex) -> [ws, l] ++ ex ++ [t]
                    }
            }
