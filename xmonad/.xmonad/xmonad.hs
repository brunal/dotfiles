import XMonad hiding ((|||))
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.UrgencyHook
import XMonad.Config.Desktop
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.EwmhDesktops
import qualified XMonad.StackSet as W
import XMonad.Layout.LayoutCombinators
import XMonad.Layout.Spacing
import XMonad.Layout.NoBorders
import XMonad.Config.Azerty
import qualified Data.Map as M

main = do
        barConf  <- statusBar bar myPP toggleBar myConfig
        xmonad barConf

bar = "xmobar .xmonad/xmobar.hs"
myPP = xmobarPP { ppUrgent = xmobarColor "red" "blue" . xmobarStrip }
toggleBar XConfig {modMask = modm} = (modm, xK_b)

myConfig = desktopConfig
        { modMask = mod4Mask
        , layoutHook = myLayout
        , keys = newKeys
        , workspaces = myWorkspaces
--        , manageHook = newManageHook
        , terminal = "urxvtc"
        , borderWidth = 3
        , focusedBorderColor = "blue"
        , handleEventHook = fullscreenEventHook
        }

newKeys x = M.union  (M.fromList $ myKeys x) $ azertyKeys x <+> keys defaultConfig x

myKeys (XConfig {modMask = modm }) =
        [ ((0, 0x1008FF14), spawn "mpc toggle")
        , ((0, 0x1008FF15), spawn "mpc stop")
        , ((0, 0x1008FF16), spawn "mpc prev")
        , ((0, 0x1008FF17), spawn "mpc next")
        , ((0, 0x1008FF12), spawn "amixer sset Master toggle")
        , ((0, 0x1008FF13), spawn "amixer sset PCM 10+")
        , ((0, 0x1008FF11), spawn "amixer sset PCM 10-")
        , ((modm, xK_p),    spawn yeganesh)
        , ((modm, xK_u),    focusUrgent)
        , ((modm, xK_F1),   sendMessage $ JumpToLayout "Spacing 3 Tall")
        , ((modm, xK_F2),   sendMessage $ JumpToLayout "Mirror Spacing 3 Tall")
        , ((modm, xK_F3),   sendMessage $ JumpToLayout "Full")
        , ((0, xK_Print),   spawn "scrot")
        , ((shiftMask, xK_Print),   spawn "sleep 0.2; scrot -s")
        , ((shiftMask .|. modm, xK_Escape), spawn "xscreensaver-command --lock")
        , ((shiftMask, xK_Escape), spawn "xscreensaver-command --lock")
        ]
        ++
        -- Azerty layout
        [((m .|. modm, xK_z),    screenWorkspace 0 >>= flip whenJust (windows . f))
          | (f,m) <- [(W.view, 0), (W.shift, shiftMask)]]


yeganesh = "exe=`dmenu_path_c | yeganesh --` && exec $exe"

--myWorkspaces = ["1", "2:web"] ++ map show [3..9]
myWorkspaces = map show [1..9]

myLayout = smartBorders $ Mirror tiled ||| tiled ||| Full
    where
        tiled = spacing 7 $ Tall nmaster delta ratio
        nmaster = 1
        ratio = 1/2
        delta = 3/100

newManageHook = myManageHook <+> manageHook defaultConfig
myManageHook = composeAll
    [ className =? "Chromium" --> doShift "2:web"
     , className /=? "Chromium" <&&> currentWs =? "2:web" --> doShift "3" <+> doF (W.greedyView "3")
    ]
