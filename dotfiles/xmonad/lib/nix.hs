{-# LANGUAGE OverloadedStrings #-}

import XMonad.Util.Run(spawnPipe, runProcessWithInput, safeSpawn, safeSpawnProg)
data ProgramPaths = ProgramPaths
  { chromium :: String
  , emacs :: String
  , steam :: String
  -- WM stuff
  , dmenu :: String
  , rofi :: String
  , nitrogen :: String }


-- Evaluate nix expression
nixEval :: MonadIO m => String -> m String
nixEval expression = runProcessWithInput "nix" ["eval", "--raw", expression] ""

nixBin :: MonadIO m => String -> String -> m String
nixBin expression binary = do
  path <- nixEval expression
  return (path <> "/bin/" <> binary)

nixosBin :: MonadIO m => String -> String -> m String
nixosBin package = nixBin ("nixos." <> package)

nixosBinSimple :: MonadIO m => String -> m String
nixosBinSimple package = nixosBin package package

spawnNixosSimple :: MonadIO m => String -> m ()
spawnNixosSimple package = do
  bin <- nixosBinSimple package
  safeSpawnProg bin

spawnNixosSimpleWithArgs :: MonadIO m => String -> [String] -> m ()
spawnNixosSimpleWithArgs package args = do
  bin <- nixosBinSimple package
  safeSpawn bin args
  
loadPaths :: MonadIO m => m ProgramPaths
loadPaths = do
  chromium <- nixosBinSimple "chromium"
  emacs <- nixosBinSimple "emacs"
  steam <- nixosBinSimple "steam"
  dmenu <- nixosBinSimple "dmenu"
  rofi <- nixosBinSimple "rofi"
  nitrogen <- nixosBinSimple "nitrogen"
  return $ ProgramPaths chromium emacs steam dmenu rofi nitrogen
