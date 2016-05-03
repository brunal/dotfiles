{-# LANGUAGE OverloadedStrings #-}

import XMonad hiding ((|||))
import XMonad.Hooks.UrgencyHook
import XMonad.Config.Gnome
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import qualified XMonad.StackSet as W
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import qualified Data.Map as M

import XMonad.Hooks.DynamicLog
import qualified DBus as D
import qualified DBus.Client as D
import qualified Codec.Binary.UTF8.String as UTF8

main = do
    dbus <- D.connectSession
    getWellKnownName dbus
    xmonad myConfig { logHook = dynamicLogWithPP $ prettyPrinter dbus }

myConfig = gnomeConfig
        { modMask = mod4Mask
        , manageHook = manageDocks
        , layoutHook = myLayout
        , keys = newKeys
        , workspaces = myWorkspaces
        , terminal = "urxvtc"
        , borderWidth = 3
        , focusedBorderColor = "blue"
        , handleEventHook = docksEventHook <+> fullscreenEventHook
        }

newKeys x = M.fromList (myKeys x) <+> keys defaultConfig x

myKeys (XConfig {modMask = modm }) =
        [ ((modm, xK_u),    focusUrgent)
        , ((modm, xK_b),    sendMessage ToggleStruts)
        , ((modm, xK_F1),   sendMessage $ JumpToLayout "Spacing 9 Tall")
        , ((modm, xK_F2),   sendMessage $ JumpToLayout "Mirror Spacing 9 Tall")
        , ((modm, xK_F3),   sendMessage $ JumpToLayout "Full")
        , ((0, xK_Print),   spawn "scrot")
        , ((shiftMask, xK_Print),   spawn "sleep 0.2; scrot -s")
        , ((shiftMask .|. modm, xK_Escape), spawn "xscreensaver-command --lock")
        , ((shiftMask, xK_Escape), spawn "xscreensaver-command --lock")
        ]

myWorkspaces = map show [1..9]

myLayout = avoidStruts . smartBorders $ Mirror tiled ||| tiled ||| noBorders Full
    where
        tiled = spacing 9 $ Tall nmaster delta ratio
        nmaster = 1
        ratio = 1/2
        delta = 3/100

-- gnome applet-related stuff

prettyPrinter :: D.Client -> PP
prettyPrinter dbus = defaultPP
    { ppOutput   = dbusOutput dbus
    , ppTitle    = pangoSanitize
    , ppCurrent  = pangoColor "blue" . wrap "[" "]" . pangoSanitize
    , ppVisible  = pangoColor "light blue" . wrap "(" ")" . pangoSanitize
    , ppHidden   = pangoSanitize
    , ppHiddenNoWindows = const " "
    , ppUrgent   = pangoColor "red"
    , ppLayout   = const ""
    , ppSep      = "    "
    }

getWellKnownName :: D.Client -> IO ()
getWellKnownName dbus = do
  D.requestName dbus (D.busName_ "org.xmonad.Log")
                [D.nameAllowReplacement, D.nameReplaceExisting, D.nameDoNotQueue]
  return ()

dbusOutput :: D.Client -> String -> IO ()
dbusOutput dbus str = do
    let signal = (D.signal "/org/xmonad/Log" "org.xmonad.Log" "Update") {
            D.signalBody = [D.toVariant $ "<b>" ++ (UTF8.decodeString str) ++ "</b>"]
        }
    D.emit dbus signal

pangoColor :: String -> String -> String
pangoColor fg = wrap left right
  where
    left  = "<span foreground=\"" ++ fg ++ "\">"
    right = "</span>"

pangoSanitize :: String -> String
pangoSanitize = foldr sanitize ""
  where
    sanitize '>'  xs = "&gt;" ++ xs
    sanitize '<'  xs = "&lt;" ++ xs
    sanitize '\"' xs = "&quot;" ++ xs
    sanitize '&'  xs = "&amp;" ++ xs
    sanitize x    xs = x:xs
